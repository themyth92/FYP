package object.CreateGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.controls.Radio;
	import feathers.controls.Scroller;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class CreateGameScoreBoard extends Sprite
	{
		private static const COIN_BOARD_POS : Point = new Point(60, 10);
		private static const COIN_IMG_POS	: Point	= new Point(40, 8);
		private static const LIFE_BOARD_POS : Point	= new Point(185,10);
		private static const LIFE_IMG_POS	: Point	= new Point(150, 8);
		private static const TIME_BOARD_POS : Point = new Point(300,10);
		private static const TIME_IMG_POS	: Point	= new Point(265, 8);
		private static const END_TIME		: Array = new Array("00","00");
		private static const START_TEXT		: Array = new Array("0/0", "1/1", "01 : 30");
		
		private var _coinText		:TextField;
		private var _lifeText		:TextField;
		private var _timeText		:TextField;
		
		private var _coinIMG		:Image;
		private var _lifeIMG		:starling.display.Button;
		private var _timeIMG		:starling.display.Button;
		
		private var _maxCoin		:int = 0;
		private var _maxLife		:int = 1;
		
		private var _minStart		:int = 1;
		private var _secStart		:int = 30;
		
		private var _popUpPanel		:Panel;
		private var _screenSelect  	:Panel;
		private var _screenImg		:Vector.<Image>;
		private var _screenList		:Vector.<Object>;
		private var _selectedScreen	:Object = {isUserDef:false, textureIndex:1};
		private var _screenSelectBtn:TextField;
				
		public function CreateGameScoreBoard()
		{
			this.addEventListener(Event.ADDED_TO_STAGE	  		, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE 		, onRemoveFromStage);
		}
		
		public function getScoreBoardInfo():Object{
			var scoreBoard	:Object = new Object();
			scoreBoard.maxCoin 	= this._maxCoin;
			scoreBoard.maxLife 	= this._maxLife;
			scoreBoard.minStart = this._minStart;
			scoreBoard.secStart = this._secStart;
			return scoreBoard;
		}
		
		public function reset():void
		{
			this._maxCoin = 0;
			this._maxLife = 1;
			this._minStart = 1;
			this._secStart = 30;
			this.reviewLife();
			this.reviewTime();
		}
		
		public function getScreen():Object{
			return this._selectedScreen;
		}
		
		public function get maxCoin():int{
			return _maxCoin;
		}
		
		public function get maxLife():int{
			return _maxLife;
		}
		
		public function get minStart():int{
			return _minStart;
		}
		
		public function get secStart():int{
			return _secStart;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._coinText 	 = new TextField(100, 30, START_TEXT[0], "Grobold", 24, 0xffffff, false);
			this._coinText.x = COIN_BOARD_POS.x;
			this._coinText.y = COIN_BOARD_POS.y;			
			
			this._lifeText 	 = new TextField(70, 30, START_TEXT[1], "Grobold", 24, 0xffffff, false);
			this._lifeText.x = LIFE_BOARD_POS.x;
			this._lifeText.y = LIFE_BOARD_POS.y;
			
			this._timeText 	 = new TextField(100, 30, START_TEXT[2], "Grobold", 24, 0xffffff, false);
			this._timeText.x = TIME_BOARD_POS.x;
			this._timeText.y = TIME_BOARD_POS.y;
			
			this._coinIMG 	 = new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.COIN_IMG));
			this._coinIMG.x  = COIN_IMG_POS.x;
			this._coinIMG.y  = COIN_IMG_POS.y;
			
			this._timeIMG	 = new starling.display.Button(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.CLOCK_IMG));
			this._timeIMG.x  = TIME_IMG_POS.x;
			this._timeIMG.y  = TIME_IMG_POS.y;
			
			this._lifeIMG 	 = new starling.display.Button(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.LIFE_IMG));
			this._lifeIMG.x  = LIFE_IMG_POS.x;
			this._lifeIMG.y  = LIFE_IMG_POS.y;
			
			//screen select choice
			this._screenSelectBtn = new TextField(100, 30,"+Screen", "Verdana", 20, 0x00ffe4, false);
			this._screenSelectBtn.underline = true;
			this._screenSelectBtn.hAlign = starling.utils.HAlign.LEFT; 
			this._screenSelectBtn.x = 400;
			this._screenSelectBtn.y	= 10;
			this._screenSelectBtn.addEventListener(TouchEvent.TOUCH, showScreenSelection);
			this._screenList = new Vector.<Object>();
			this._screenImg = new Vector.<Image>();
			
			this.addChild(this._coinText);
			this.addChild(this._lifeText);
			this.addChild(this._timeText);
			this.addChild(this._coinIMG);
			this.addChild(this._timeIMG);
			this.addChild(this._lifeIMG);
			this.addChild(this._screenSelectBtn);
			
			this._timeIMG.addEventListener(Event.TRIGGERED, onTimeClicked);
			this._lifeIMG.addEventListener(Event.TRIGGERED, onLifeClicked);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if(PreviewGameInfo._isSaved)
				this.initializeScore();
		}
		
		private function initializeScore():void{
			this._maxLife = PreviewGameInfo._maxLife;
			this._maxCoin = PreviewGameInfo._maxCoin;
			this._minStart = PreviewGameInfo._minStart;
			this._secStart = PreviewGameInfo._secStart;
			this.reviewTime();
			this.reviewLife();
		}
		
		private function showScreenSelection(e:TouchEvent):void{
			var touch	:Touch = e.getTouch(this._screenSelectBtn, TouchPhase.ENDED);
			if(touch)
			{
				this._screenSelectBtn.removeEventListener(TouchEvent.TOUCH, showScreenSelection);
				_screenSelect				= new Panel();
				_screenSelect.x = 50;
				_screenSelect.y = 50;
				_screenSelect.width = 700;
				_screenSelect.height = 500; 
				_screenSelect.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
				_screenSelect.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
				
				//layout default value from feathers
				const layout:TiledRowsLayout  		= new TiledRowsLayout();
				layout.paging                		= TiledRowsLayout.PAGING_NONE;
				layout.gap							= 20;
				layout.padding						= 20;
				layout.horizontalAlign         	 	= TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
				layout.verticalAlign            	= TiledRowsLayout.VERTICAL_ALIGN_TOP;
				layout.tileHorizontalAlign  	    = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
				layout.tileVerticalAlign  	      	= TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
				layout.manageVisibility 			= true;
				_screenSelect.layout                = layout;
				_screenSelect.snapToPages 					= true;
				_screenSelect.snapScrollPositionsToPixels 	= true;
				var field	:Image;
				var screenObj	:Object;
				for(var i:uint=1; i<6; i++)
				{
					field = new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture("Stage"+i+"Screen"));
					field.width = 200;
					field.height = 180;
					screenObj = new Object();
					screenObj.textureIndex = i;
					screenObj.isUserDef = false;
					this._screenImg.push(field);
					this._screenList.push(screenObj);
				}
				for(var j:uint=0; j<Assets.getUserScreenTexture().length; j++)
				{
					field = new Image(Assets.getUserScreenTexture()[j].texture);
					field.width = 200;
					field.height = 180;
					screenObj = new Object();
					screenObj.textureIndex = j;
					screenObj.isUserDef = true;
					this._screenImg.push(field);
					this._screenList.push(screenObj);
				}
				
				for(var k:uint=0; k<this._screenImg.length;k++)
					this._screenSelect.addChildAt(this._screenImg[k],k);
				
				this._screenSelect.addEventListener(TouchEvent.TOUCH, onScreenTouch);
				this.addChild(_screenSelect);
			}
		}
		
		private function onScreenTouch(e:TouchEvent):void
		{
			var glow	:BlurFilter = BlurFilter.createGlow();
			var touch:Touch = e.getTouch(this._screenSelect, TouchPhase.ENDED);
			
			if(touch)
			{
				if(touch.tapCount == 1)
				{
					clearGlowEffect();
					touch.target.filter = glow;
					return;
				}
				if(touch.tapCount == 2)
				{
					doneScreenSelection();
					return;
				}
			}
		}
		
		private function clearGlowEffect():void
		{
			for(var i:uint=0; i<this._screenSelect.numChildren; i++)	
				this._screenSelect.getChildAt(i).filter = null;
		}
		
		private function doneScreenSelection():void
		{
			for(var i:uint=0; i<this._screenSelect.numChildren; i++)
			{
				if(this._screenSelect.getChildAt(i).filter != null)
				{
					this._selectedScreen.isUserDef = this._screenList[i].isUserDef;
					this._selectedScreen.textureIndex = this._screenList[i].textureIndex;
					this._screenSelect.removeChildren();
					this.removeChild(this._screenSelect);
					this._screenSelectBtn.addEventListener(TouchEvent.TOUCH, showScreenSelection);
					this._screenImg.length = 0;
					this._screenList.length = 0;
					this.dispatchEventWith('GameFieldChanged', true, this._selectedScreen);
					break;
				}
			}
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			
		}
		
		private function onTimeClicked(event:Event):void
		{
			_popUpPanel = new Panel();
			_popUpPanel.width = 200;
			_popUpPanel.height = 250;
			
			var colonText :TextField = new TextField(100, 30, ":",'Verdana', 24, 0xffffff, false);
			colonText.x = 45;
			colonText.y = 10;
			var minuteText:TextInput = new TextInput();
			minuteText.x = 10;
			minuteText.textEditorProperties.fontSize = 20;
			minuteText.width = 75;
			minuteText.height = 40;
			var secondText:TextInput = new TextInput();
			secondText.x = 110;
			secondText.textEditorProperties.fontSize = 20;
			secondText.width = 75;
			secondText.height = 40;
			
			minuteText.text = formatLeadingZero(_minStart);
			secondText.text = formatLeadingZero(_secStart);
			_popUpPanel.addChild(colonText);
			_popUpPanel.addChild(minuteText);
			_popUpPanel.addChild(secondText);
			
			var closeButton :feathers.controls.Button = new feathers.controls.Button();
			closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void { onCloseTimeWindow(minuteText, secondText)});
			closeButton.x = 65;
			closeButton.y = 100;
			closeButton.label = "Ok";
			
			_popUpPanel.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Time";
				return header;
			}
			
			_popUpPanel.addChild(closeButton);
			PopUpManager.addPopUp( _popUpPanel);
		}
		
		private function onCloseTimeWindow(minute:TextInput, second:TextInput):void
		{	
			if(isDigit(minute.text) && isDigit(second.text))
			{
				_minStart = Number(minute.text);
				_secStart = Number(second.text);
				reviewTime();
				PopUpManager.removePopUp( _popUpPanel, true );
			}
			else
			{
				var errorMsg :TextField = new TextField(200, 100, "Invalid input.", "Grobold", 24, 0xfa0000, false);
				errorMsg.y = 75;
				errorMsg.x = 15;
				_popUpPanel.addChild(errorMsg);
			}
		}
		
		private function onLifeClicked(event:Event):void
		{
			_popUpPanel = new Panel();
			_popUpPanel.width = 200;
			_popUpPanel.height = 250;
			
			var lifeEdit:TextInput = new TextInput();
			lifeEdit.x = 55;
			lifeEdit.width = 80;
			lifeEdit.height = 40;

			lifeEdit.text = formatLeadingZero(_maxLife);
			_popUpPanel.addChild(lifeEdit);
			
			var closeButton :feathers.controls.Button = new feathers.controls.Button();
			closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void { onCloseLifeWindow(lifeEdit)});
			closeButton.x = 65;
			closeButton.y = 100;
			closeButton.label = "Ok";
			
			_popUpPanel.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Life";
				return header;
			}
			
			_popUpPanel.addChild(closeButton);
			PopUpManager.addPopUp( _popUpPanel);
		}
		
		private function onCloseLifeWindow(life:TextInput):void
		{
			if(isDigit(life.text))
			{
				_maxLife = Number(life.text);
				PopUpManager.removePopUp( _popUpPanel, true );
				reviewLife();
			}
			else
			{
				var errorMsg :TextField = new TextField(200, 100, "Invalid input.", "Grobold", 24, 0xfa0000, false);
				errorMsg.y = 75;
				errorMsg.x = 15;
				_popUpPanel.addChild(errorMsg);
			}
		} 
		
		private function reviewTime():void
		{
			_timeText.text = formatLeadingZero(_minStart) + " : " + formatLeadingZero(_secStart);
		}
		
		private function reviewLife():void
		{
			_lifeText.text = _maxLife + "/" + _maxLife;
		}
		
		private function formatLeadingZero(value:Number):String
		{
			return (value < 10) ? "0" + value.toString() : value.toString();
		}
		
		// Determines if a string is digit 
		private function isDigit(value : String) : Boolean {
			return isValidCode(value, 48, 57);
		}
		
		// The meat of the functions which checks the values 
		private function isValidCode(value : String, minCode : Number, maxCode : Number) : Boolean {
			if ((value == null) || (StringUtil.trim(value).length < 1))
				return false;
			
			for (var i : int=value.length-1;i >= 0; i--) {
				var code : Number = value.charCodeAt(i);
				if ((code < minCode) || (code > maxCode))
					return false;
			}
			return true;
		}
	}
}