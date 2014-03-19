package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Panel;
	import feathers.controls.PickerList;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class ScoreBoard extends Sprite
	{ 
		private static const COIN_BOARD_POS : Point = new Point(60, 10);
		private static const COIN_IMG_POS	: Point	= new Point(40, 8);
		private static const LIFE_BOARD_POS : Point	= new Point(185,10);
		private static const LIFE_IMG_POS	: Point	= new Point(150, 8);
		private static const TIME_BOARD_POS : Point = new Point(300,10);
		private static const TIME_IMG_POS	: Point	= new Point(265, 8);
		
		//STATES VARIABLE
		private var _state				  :String = ChapterOneConstant.INSTRUCTING_STATE;
		
		private var board : TextInput = new TextInput();

		private var _comfirmQuad : Quad;
		
		/* Information Text */
		private var _coinText	: TextField;
		private var _lifeText	: TextField;
		private var _timeText	: TextField;
		
		/* Image */
		private var _coinIMG	: Image;
		private var _lifeIMG	: starling.display.Button;
		private var _timeIMG	: starling.display.Button;
		
		private var _maxLife 	:Number = 5;
		private var _panel		:Panel;
		private var _controller	    : Controller;
		
		/* Time variable */
		private var _markTime		: int = 0;
		private var _minutesOn		: int = 5;
		private var _secondsOn		: int = 60;
		
		private var _startPlaying	: Boolean = true;
		
		public function ScoreBoard(controller:Controller)
		{
			this._controller   = controller;
		
			this.addEventListener(Event.ADDED_TO_STAGE	  		, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE 		, onRemoveFromStage);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME	, updateTimeTracker);
		}
		
		private function onAddedToStage(event:Event):void
		{
			//new MetalWorksMobileTheme();
			
			this._coinText 	 = new TextField(100, 30, "0/0", "Grobold", 24, 0xffffff, false);
			this._coinText.x = COIN_BOARD_POS.x;
			this._coinText.y = COIN_BOARD_POS.y;
						
			this._lifeText 	 = new TextField(70, 30, "0/0", "Grobold", 24, 0xffffff, false);
			this._lifeText.x = LIFE_BOARD_POS.x;
			this._lifeText.y = LIFE_BOARD_POS.y;
						
			this._timeText 	 = new TextField(100, 30, "00:00", "Grobold", 24, 0xffffff, false);
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
			
			this.addChild(this._coinText);
			this.addChild(this._lifeText);
			this.addChild(this._timeText);
			this.addChild(this._coinIMG);
			this.addChild(this._timeIMG);
			this.addChild(this._lifeIMG);
				
			this._timeIMG.addEventListener(Event.TRIGGERED, onTimeClicked);
			this._lifeIMG.addEventListener(Event.TRIGGERED, onLifeClicked);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			
		}
		
		private function onLifeClicked(event:Event):void
		{
			_panel = new Panel();
			_panel.width = 250;
			
			var lifeEdit:TextInput = new TextInput();
			lifeEdit.x = 70;
			lifeEdit.width = 80;
			
			lifeEdit.prompt = formatLeadingZero(_maxLife);
			_panel.addChild(lifeEdit);
			
			var closeButton :feathers.controls.Button = new feathers.controls.Button();
			closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void { onCloseLifeWindow(lifeEdit)});
			closeButton.x = 75;
			closeButton.y = 75;
			closeButton.label = "Ok";
			
			_panel.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Life";
				return header;
			}
			
			_panel.addChild(closeButton);
			PopUpManager.addPopUp( _panel);
		}
		
		private function onCloseLifeWindow(life:TextInput):void
		{
			PopUpManager.removePopUp( _panel, true );
			if(life.text != null)
				_maxLife = Number(life.text);
			
			_controller.getGameStat("max life", _maxLife);
			reviewLife();
		}
		
		private function onTimeClicked(event:Event):void
		{
			_panel = new Panel();
			_panel.width = 250;
						
			var colonText :TextField = new TextField(100, 30, ":",'Verdana', 24, 0xffffff, false);
			colonText.x = 65;
			colonText.y = 10;
			var minuteText:TextInput = new TextInput();
			minuteText.x = 30;
			minuteText.textEditorProperties.fontSize = 20;
			minuteText.width = 75;
			var secondText:TextInput = new TextInput();
			secondText.x = 125;
			secondText.textEditorProperties.fontSize = 20;
			secondText.width = 75;

			minuteText.prompt = formatLeadingZero(_minutesOn);
			secondText.prompt = "00";
			_panel.addChild(colonText);
			_panel.addChild(minuteText);
			_panel.addChild(secondText);
			
			var closeButton :feathers.controls.Button = new feathers.controls.Button();
			closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void { onCloseTimeWindow(minuteText, secondText)});
			closeButton.x = 75;
			closeButton.y = 75;
			closeButton.label = "Ok";
			
			_panel.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Time";
				return header;
			}
				
			_panel.addChild(closeButton);
			PopUpManager.addPopUp( _panel);
		}
		
		private function onCloseTimeWindow(minute:TextInput, second:TextInput):void
		{
			PopUpManager.removePopUp( _panel, true );
			if(minute.text != null)
				_minutesOn = Number(minute.text);
			if(second.text != null)
				_secondsOn = Number(second.text);
			reviewTime();
		}

		public function updateCoinTracker(currentCoin:Number, maxCoin:Number):void
		{
			_coinText.text = currentCoin + "/" + maxCoin;
		}
		
		public function updateLifeTracker(currentLife:Number, maxLife:Number):void
		{
			_lifeText.text = currentLife + "/" + maxLife;
		}
		
		public function updateTimeTracker(event:EnterFrameEvent):void
		{
			var timePassed	:Number 	= getTimer() - _markTime;
			var seconds		:int 		= _secondsOn - (timePassed / 1000) % 60;
			var minutes		:int 		= _minutesOn - (timePassed / (1000 * 60)) % 60;
			
			if(_state == ChapterOneConstant.PLAYING_STATE)
			{
				if(_startPlaying)
				{
					_markTime = getTimer();
					_startPlaying = false;
				}
				_timeText.text = formatLeadingZero(minutes) + " : " + formatLeadingZero(seconds);
			}
		}
		
		private function reviewTime():void
		{
			_timeText.text = formatLeadingZero(_minutesOn) + " : " + formatLeadingZero(_secondsOn);
		}
		
		private function reviewLife():void
		{
			_lifeText.text = _maxLife + "/" + _maxLife;
		}
		
		private function formatLeadingZero(value:Number):String
		{
			return (value < 10) ? "0" + value.toFixed() : value.toFixed();
		}
	
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}	
	}
}