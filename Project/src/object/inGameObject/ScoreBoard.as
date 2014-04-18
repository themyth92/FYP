/*****************************************************
 * ================================================= *
 *                 SCOREBOARD OBJECT                 *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	import constant.StoryConstant;
	
	import controller.ObjectController.MainController;
	
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
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class ScoreBoard extends Sprite
	{ 
		/* CONSTANT */
		private static const COIN_BOARD_POS : Point = new Point(60, 10);
		private static const COIN_IMG_POS	: Point	= new Point(40, 8);
		private static const LIFE_BOARD_POS : Point	= new Point(185,10);
		private static const LIFE_IMG_POS	: Point	= new Point(150, 8);
		private static const TIME_BOARD_POS : Point = new Point(300,10);
		private static const TIME_IMG_POS	: Point	= new Point(265, 8);
		private static const END_TIME		: String= "00 : 00";
		
		/* CONTROL VARIBALES */
		private var _state				  	: String = Constant.INSTRUCTING_STATE;
		private var _panel					: Panel;
		private var _controller	    		: MainController;
		private var _startPlaying			: Boolean = true;
		private var _isPoppedUp				: Boolean;
		private var _isOutOfTime			: Boolean = false;
		private var _screen					: String;
		private var _isLifeEnabled			: Boolean = false;
		private var _isTimeEnabled			: Boolean = false;
		
		/* Information Text */
		private var _coinText				: TextField;
		private var _lifeText				: TextField;
		private var _timeText				: TextField;
		
		/* Image */
		private var _coinIMG				: Image;
		private var _lifeIMG				: starling.display.Button;
		private var _timeIMG				: starling.display.Button;
		
		/* Stats */
		private var _maxLife 				: Number = 1;
		private var _maxCoin				: Number = 0;
		private var _currLife				: Number = 1;
		private var _currCoin				: Number = 0;
		
		/* Time variable */
		private var _markTime				: int = 0;
		private var _minutesOn				: int;
		private var _secondsOn				: int;
		private var _curMin					: int;
		private var _curSec					: int;

		public function ScoreBoard(controller:MainController)
		{
			this._controller    = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE	  		, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME				, onEnterFrame);
			this.addEventListener(Event.REMOVED_FROM_STAGE 		, onRemoveFromStage);
		}
		
		/**====================================================================
		 * |	                     GET-SET FUNCTIONS		                  | *
		 * ====================================================================**/
		public function set isLifeEnabled(value:Boolean):void{
			this._isLifeEnabled = value;
		}
		
		public function set isTimeEnabled(value:Boolean):void{
			this._isTimeEnabled = value;
		}
		
		public function set currCoin(value:Number):void{
			this._currCoin = value;
		}
		
		public function set maxCoin(value:Number):void{
			this._maxCoin = value;
		}
		
		public function set state(value:String):void{
			this._state = value;
		}
		
		public function set currLife(value:Number):void{
			this._currLife = value;
		}
		
		public function get maxLife():Number{
			return this._maxLife;	
		}
		
		public function set screen(value:String):void{
			this._screen = value;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		private function onAddedToStage(event:Event):void
		{
			var displayText :Array = setupScoreBoardText();
			
			this._coinText 	 = new TextField(100, 30, displayText[0], "Grobold", 24, 0xffffff, false);
			this._coinText.x = COIN_BOARD_POS.x;
			this._coinText.y = COIN_BOARD_POS.y;			
			
			this._lifeText 	 = new TextField(70, 30, displayText[1], "Grobold", 24, 0xffffff, false);
			this._lifeText.x = LIFE_BOARD_POS.x;
			this._lifeText.y = LIFE_BOARD_POS.y;
						
			this._timeText 	 = new TextField(100, 30, displayText[2], "Grobold", 24, 0xffffff, false);
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
				
			this._timeIMG.addEventListener	(Event.TRIGGERED, 		onTimeClicked);
			this._lifeIMG.addEventListener	(Event.TRIGGERED, 		onLifeClicked);
			this.removeEventListener		(Event.ADDED_TO_STAGE, 	onAddedToStage);
		}
		
		private function onEnterFrame(event:Event):void{
			updateTimeText();
			if(_state == Constant.PAUSE_STATE && _startPlaying == false)
			{
				_startPlaying = true;
				this._secondsOn = this._curSec;
				this._minutesOn = this._curMin;
			}
		}
		
		//Setup starting text for scoreboard display
		private function setupScoreBoardText():Array
		{
			var result :Array;
			switch(this._screen){
				case Constant.STORY_SCREEN_4:
					result = new Array("0/0", "1/1", "00 : 05");
					_maxCoin	= 0;
					_maxLife 	= 1;
					_currLife	= _maxLife;
					_currCoin 	= _maxCoin;
					_minutesOn 	= 0;
					_secondsOn  = 5;
					break;
				case Constant.PLAY_SCREEN:
					var coinText	:String = PreviewGameInfo._maxCoin + "/" + PreviewGameInfo._maxCoin;
					var lifeText	:String = PreviewGameInfo._maxLife + "/" + PreviewGameInfo._maxLife;
					var timeText	:String = formatLeadingZero(PreviewGameInfo._minStart) + " : " + formatLeadingZero(PreviewGameInfo._secStart);
					result = new Array(coinText, lifeText, timeText);
					_maxCoin = PreviewGameInfo._maxCoin;
					_maxLife = PreviewGameInfo._maxLife;
					_currLife = _maxLife;
					_currCoin = _maxCoin;
					_minutesOn = PreviewGameInfo._minStart;
					_secondsOn = PreviewGameInfo._secStart;
					_controller.getGameStat("max life", _maxLife);
					break;
				default:
					result = new Array("0/0", "1/1", "01 : 30");
					_maxCoin	= 0;
					_maxLife 	= 1;
					_currLife	= _maxLife;
					_currCoin 	= _maxCoin;
					_minutesOn 	= 1;
					_secondsOn  = 30;
					break;
			}
			return result;
		}
		
		private function onLifeClicked(event:Event):void
		{
			if(this._isLifeEnabled)
			{
				_panel = new Panel();
				_panel.width = 200;
				_panel.height = 250;
				
				var lifeEdit:TextInput = new TextInput();
				lifeEdit.x = 55;
				lifeEdit.width = 80;
				lifeEdit.height = 40;
				lifeEdit.text = formatLeadingZero(_maxLife);
				_panel.addChild(lifeEdit);
				
				var closeButton :feathers.controls.Button = new feathers.controls.Button();
				closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void { onCloseLifeWindow(lifeEdit)});
				closeButton.x = 65;
				closeButton.y = 100;
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
				updateLifeText();
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
					this._isLifeEnabled = false;
					this._controller.enableLifeEdit(false);
				}
			}
		}
		
		private function onTimeClicked(event:Event):void
		{
			if(this._isTimeEnabled)
			{
				_panel = new Panel();
				_panel.width = 200;
				_panel.height = 250;
							
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
	
				minuteText.text = formatLeadingZero(_minutesOn);
				secondText.text = formatLeadingZero(_secondsOn);
				_panel.addChild(colonText);
				_panel.addChild(minuteText);
				_panel.addChild(secondText);
				
				var closeButton :feathers.controls.Button = new feathers.controls.Button();
				closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void { onCloseTimeWindow(minuteText, secondText)});
				closeButton.x = 65;
				closeButton.y = 100;
				closeButton.label = "Ok";
				
				_panel.headerFactory = function():Header
				{
					var header:Header = new Header();
					header.title = "Time";
					return header;
				}
				
				_panel.headerProperties.@height = 20;
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
			if(Number(minute) != StoryConstant.STAGE4_TIME_MIN || Number(second) != StoryConstant.STAGE4_TIME_SEC)
				this._controller.showIncorrectDialouge("time");
			else
			{
				this._isTimeEnabled = false;
				this._controller.enableTimeEdit(false);
			}
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChildren();
			this._controller = null;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/**====================================================================
		 * |	                     	FUNCTIONS			                  | *
		 * ====================================================================**/
		// Update the time text on scoreboard
		private function updateTimeText():void
		{
			var timePassed	:Number 	= getTimer() - _markTime;
			var seconds		:int 		= _secondsOn - int((timePassed / 1000) % 60);
			var minutes		:int 		= _minutesOn - int((timePassed / (1000 * 60)) % 60);
			
			if(_state == Constant.PLAYING_STATE)
			{
				//Get the time at the start of playing only
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
					this._curSec = seconds;
					this._curMin = minutes;
				}
				else
					this._controller.isLost = true;
			}
		}
		
		// Check whether the time reach 00:00, if yes => lost
		private function checkLostCondition():Boolean{
			if(_timeText.text == END_TIME)
				return true;
			else
				return false;
		}
		
		// Review time upon editting
		private function reviewTime():void{
			this._timeText.text = formatLeadingZero(_minutesOn) + " : " + formatLeadingZero(_secondsOn);
		}
		
		// Review coin upon change
		public function updateCoinText():void{
			this._coinText.text = this._currCoin + "/" + this._maxCoin;
		}
		
		// Review the life upon change
		public function updateLifeText():void{
			this._lifeText.text = this._currLife + "/" + this._maxLife;
		}
		
		// Add in the 0 in front of the number for those are smaller than 10
		// Use for displaying clock
		private function formatLeadingZero(value:Number):String{
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