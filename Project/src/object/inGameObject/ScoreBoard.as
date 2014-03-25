package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	import constant.StoryConstant;
	
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
	
	import mx.utils.StringUtil;
	
	import screen.StoryStage1;
	
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
		private static const END_TIME		: Array = new Array("00","00");
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
		
		private var _maxLife 	:Number = 1;
		private var _maxCoin	:Number = 0;
		private var _currLife	:Number = 1;
		private var _currCoin	:Number = 0;
		private var _panel		:Panel;
		private var _controller	    : Controller;
		
		/* Time variable */
		private var _markTime		: int = 0;
		private var _minutesOn		: int = 1;
		private var _secondsOn		: int = 5;
		
		private var _startPlaying	: Boolean = true;
		private var _isPoppedUp		: Boolean;
		private var _isOutOfTime	: Boolean = false;
		private var _screen			: String;
		private var _isLifeEnabled	: Boolean = false;
		private var _isTimeEnabled	: Boolean = false;
		
		public function ScoreBoard(controller:Controller)
		{
			this._controller    = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE	  		, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME				, onEnterFrame);
			this.addEventListener(Event.REMOVED_FROM_STAGE 		, onRemoveFromStage);
		}
		
		public function set isLifeEnabled(value:Boolean):void
		{
			this._isLifeEnabled = value;
		}
		
		public function set isTimeEnabled(value:Boolean):void
		{
			this._isTimeEnabled = value;
		}
		
		private function onEnterFrame(event:Event):void
		{
			_coinText.text = this._currCoin + "/" + this._maxCoin;
			_lifeText.text = this._currLife + "/" + this._maxLife;
			updateTimeTracker();
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._screen = this._controller.screen;
			new MetalWorksMobileTheme();
			var displayText :Array = setupScoreBoardText();

			//new MetalWorksMobileTheme();

			this._coinText 	 = new TextField(100, 30, displayText[0], "Grobold", 24, 0xffffff, false);
			this._coinText.x = COIN_BOARD_POS.x;
			this._coinText.y = COIN_BOARD_POS.y;			
			
			this._lifeText 	 = new TextField(70, 30, displayText[1], "Grobold", 24, 0xffffff, false);
			this._lifeText.x = LIFE_BOARD_POS.x;
			this._lifeText.y = LIFE_BOARD_POS.y;
						
			this._timeText 	 = new TextField(100, 30, displayText[2], "Grobold", 24, 0xffffff, false);
			this._timeText.x = TIME_BOARD_POS.x;
			this._timeText.y = TIME_BOARD_POS.y;
			
			setupScoreBoardText();
			
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
		
		private function setupScoreBoardText():Array
		{
			var result :Array;
			switch(this._screen){
				case Constant.STORY_SCREEN_1:
					result = new Array("0/0", "1/1", "01 : 30");
					_maxCoin	= 0;
					_maxLife 	= 1;
					_currLife	= _maxLife;
					_currCoin 	= _maxCoin;
					_minutesOn 	= 1;
					_secondsOn  = 30;
					break;
				case Constant.STORY_SCREEN_2:
					result = new Array("0/0", "1/1", "01 : 30");
					_maxCoin	= 0;
					_maxLife 	= 1;
					_currLife	= _maxLife;
					_currCoin 	= _maxCoin;
					_minutesOn 	= 1;
					_secondsOn  = 30;
					break;
				case Constant.STORY_SCREEN_3:
					result = new Array("0/0", "1/1", "01 : 30");
					_maxCoin	= 0;
					_maxLife 	= 1;
					_currLife	= _maxLife;
					_currCoin 	= _maxCoin;
					_minutesOn 	= 1;
					_secondsOn  = 30;
					break;
				case Constant.STORY_SCREEN_4:
					result = new Array("0/0", "1/1", "00 : 05");
					_maxCoin	= 0;
					_maxLife 	= 1;
					_currLife	= _maxLife;
					_currCoin 	= _maxCoin;
					_minutesOn 	= 0;
					_secondsOn  = 5;
					break;
				case Constant.STORY_SCREEN_5:
					result = new Array("0/0", "1/1", "01 : 30");
					_maxCoin	= 0;
					_maxLife 	= 1;
					_currLife	= _maxLife;
					_currCoin 	= _maxCoin;
					_minutesOn 	= 1;
					_secondsOn  = 30;
					break;
				default:
					result = new Array("0/0", "1/1", "01 : 30");
					break;
			}
			return result;
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			
		}
		
		private function onLifeClicked(event:Event):void
		{
			if(this._isLifeEnabled)
			{
				_panel = new Panel();
				_panel.width = 250;
				_panel.height = 300;
				
				var lifeEdit:TextInput = new TextInput();
				lifeEdit.x = 70;
				lifeEdit.width = 80;
				
				lifeEdit.prompt = formatLeadingZero(_maxLife);
				_panel.addChild(lifeEdit);
				
				var closeButton :feathers.controls.Button = new feathers.controls.Button();
				closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void { onCloseLifeWindow(lifeEdit)});
				closeButton.x = 75;
				closeButton.y = 150;
				closeButton.label = "Ok";
				
				_panel.headerFactory = function():Header
				{
					var header:Header = new Header();
					header.title = "Life";
					return header;
				}
				
				_panel.addChild(closeButton);
				this._controller.gotPopUp = true;
				PopUpManager.addPopUp( _panel);
			}
		}
		
		private function onCloseLifeWindow(life:TextInput):void
		{
			if(isDigit(life.text))
			{
				_maxLife = Number(life.text);
				_currLife = _maxLife;
				if(this._screen == Constant.STORY_SCREEN_3)
				{
					checkStage3Condition(life.text);
				}
				this._controller.gotPopUp = false;
				PopUpManager.removePopUp( _panel, true );
				
				_controller.getGameStat("max life", _maxLife);
				reviewLife();
			}
			else
			{
				var errorMsg :TextField = new TextField(200, 100, "Invalid input.", "Grobold", 24, 0xfa0000, false);
				errorMsg.y = 75;
				errorMsg.x = 15;
				_panel.addChild(errorMsg);
			}
		}
		
		private function checkStage3Condition(life:String):void
		{
			if(isDigit(life))
			{
				if(Number(life) < StoryConstant.STAGE3_LIFE_MIN)
					this._controller.showIncorrectDialouge("<");
				else if(Number(life) > StoryConstant.STAGE3_LIFE_MAX)
					this._controller.showIncorrectDialouge(">");
				else
				{
					var info	:Array = new Array(false);
					this._controller.updateStageInfo(3,info);
				}
			}
		}
		
		private function onTimeClicked(event:Event):void
		{
			if(this._isTimeEnabled)
			{
				_panel = new Panel();
				_panel.width = 250;
				_panel.height = 300;
							
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
				closeButton.y = 150;
				closeButton.label = "Ok";
				
				_panel.headerFactory = function():Header
				{
					var header:Header = new Header();
					header.title = "Time";
					return header;
				}
					
				_panel.addChild(closeButton);
				this._controller.gotPopUp = true;
				PopUpManager.addPopUp( _panel);
			}
		}	
		
		private function onCloseTimeWindow(minute:TextInput, second:TextInput):void
		{	
			if(isDigit(minute.text) && isDigit(second.text))
			{
				_minutesOn = Number(minute.text);
				_secondsOn = Number(second.text);
				reviewTime();
				if(this._screen == Constant.STORY_SCREEN_4)
				{
					checkStage4Condition(minute.text, second.text);
				}
				this._controller.gotPopUp = false;
				this._isPoppedUp = false;
				PopUpManager.removePopUp( _panel, true );
			}
			else
			{
				var errorMsg :TextField = new TextField(200, 100, "Invalid input.", "Grobold", 24, 0xfa0000, false);
				errorMsg.y = 75;
				errorMsg.x = 15;
				_panel.addChild(errorMsg);
			}
		}
		
		private function checkStage4Condition(minute:String, second:String):void
		{
			if(isDigit(minute))
			{
				if(Number(minute) != StoryConstant.STAGE4_TIME_MIN && Number(second) != StoryConstant.STAGE4_TIME_SEC)
					this._controller.showIncorrectDialouge("time");
				else
				{
					var info	:Array = new Array(false);
					this._controller.updateStageInfo(4,info);
				}
			}
		}

		public function updateCoinTracker(currentCoin:Number, maxCoin:Number):void
		{
			this._currCoin = currentCoin;
			this._maxCoin = maxCoin;
		}
		
		public function updateLifeTracker(currentLife:Number, maxLife:Number):void
		{
			this._currLife = currentLife;
			this._maxLife = maxLife;
		}
		
		private function updateTimeTracker():void
		{
			var timePassed	:Number 	= getTimer() - _markTime;
			var seconds		:int 		= _secondsOn - int((timePassed / 1000) % 60);
			var minutes		:int 		= _minutesOn - int((timePassed / (1000 * 60)) % 60);
			
			if(_state == ChapterOneConstant.PLAYING_STATE)
			{
				if(_startPlaying)
				{
					this._timeIMG.removeEventListener(Event.TRIGGERED, onTimeClicked);
					this._lifeIMG.removeEventListener(Event.TRIGGERED, onLifeClicked);
					_markTime = getTimer();
					_startPlaying = false;
				}
				if(!checkLostCondition())
				{
					if(seconds < 0)
					{
						minutes = minutes - 1;
						seconds = seconds + 60;
					}
					_timeText.text = formatLeadingZero(minutes) + " : " + formatLeadingZero(seconds);
				}
				else
					this._controller.isLost = true;
			}
		}
		
		private function checkLostCondition():Boolean
		{
			if(_timeText.text == "00 : 00")
				return true;
			else
				return false;
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
			return (value < 10) ? "0" + value.toString() : value.toString();
		}
	
		public function changeState(currentState:String):void
		{
			_state = currentState;
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