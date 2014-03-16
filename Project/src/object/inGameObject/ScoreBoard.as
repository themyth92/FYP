package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	
	import flash.utils.getTimer;
	
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
		private static const COIN_BOARD_X : Number  = 60;
		private static const LIFE_BOARD_X : Number 	= 185;
		private static const TIME_BOARD_X : Number  = 300;
		private static const SCOREBOARD_Y : Number  = 10;
		
		//STATES VARIABLE
		private var _state				  :String = ChapterOneConstant.INSTRUCTING_STATE;
		
		private var board : TextInput = new TextInput();

		private var _comfirmQuad : Quad;
		
		private var _coinText	: TextField;
		private var _lifeText	: TextField;
		private var _timeText	: TextField;
		
		private var _coinIMG	: Image;
		private var _lifeIMG	: Image;
		private var _timeIMG	: Image;
		
		private var _maxLife 	:Number;
		
		private var _controller	    : Controller;
		
		private var _markTime		: int = 0;
		private var _minutesOn		: int = 5;
		private var _secondsOn		: int = 60;
		
		private var _startPlaying	: Boolean = true;
		
		public function ScoreBoard(controller:Controller)
		{
			this._controller   = controller;

			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE	   , onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE , onRemoveFromStage);
			this.addEventListener(TouchEvent.TOUCH		   , onTouch);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, updateTimeTracker);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_coinText = new TextField(100, 30, "0/0", "Grobold", 24, 0xffffff, false);
			_coinText.x = COIN_BOARD_X;
			_coinText.y = SCOREBOARD_Y;
			this.addChild(_coinText);
			
			_lifeText = new TextField(70, 30, "0/0", "Grobold", 24, 0xffffff, false);
			_lifeText.x = LIFE_BOARD_X;
			_lifeText.y = SCOREBOARD_Y;
			_lifeText.touchable = true;
			this.addChild(_lifeText);
			
			_timeText = new TextField(100, 30, "00:00", "Grobold", 24, 0xffffff, false);
			_timeText.x = TIME_BOARD_X;
			_timeText.y = SCOREBOARD_Y;
			_timeText.touchable = true;
			this.addChild(_timeText);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			if(_state == ChapterOneConstant.EDITTING_STATE)
			{
				var touchLife			: Touch;
				var touchTime			: Touch;
				var touchcomfirm		: Touch;
				
				touchLife = event.getTouch(this._lifeText);
				touchTime = event.getTouch(this._timeText);
				touchcomfirm = event.getTouch(this._comfirmQuad);
				if(touchLife)
					modifyLife();
				else if(touchTime)
					modifyTime();
				else if(touchcomfirm)
					updateLifeTracker(Number(board.text),Number(board.text));
			}
		}
		
		private function modifyLife():void
		{
			var maxLife : String;
			maxLife = displayEditBoard("life");			
		}
		
		private function modifyTime():void
		{
			displayEditBoard("time");
		}
		
		private function displayEditBoard(type:String):String
		{
			var input : String;
			switch (type){
				case "life":
					board.x = 500;
					board.y = 300;
					board.width = 50;
					board.height = 50;
					board.isEditable = true;
					board.text = input;
					board.backgroundSkin = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.CONSOLE_FOCUS));
					this.addChild(board);
					this.board.addEventListener(FeathersEventType.ENTER, onLifeEnter);
					
					break;
				case "time":
					board.x = 200;
					board.y = 300;
					board.width = 50;
					board.height = 50;
					board.isEditable = true;
					board.text = input;
					board.backgroundSkin = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.CONSOLE_FOCUS));
					this.addChild(board);
					this.board.addEventListener(FeathersEventType.ENTER, onTimeEnter);
					
					break;
			}
			return input;
		}
		
		private function onLifeEnter(e:Event):void
		{	
			_maxLife = Number(board.text);
			_controller.getGameStat("max life", _maxLife);
			this.removeChild(board);
		}
		
		private function onTimeEnter(e:Event):void
		{
			_minutesOn =  Number(board.text.substr(0,board.text.indexOf(","))) + 1;
			_secondsOn =  Number(board.text.substr(board.text.indexOf(",")+1, board.text.length));
			this.removeChild(board);
		}
		
		public function updateCoinTracker(currentCoin:Number, maxCoin:Number):void
		{
			if(_state == ChapterOneConstant.PLAYING_STATE)
				_coinText.text = currentCoin + "/" + maxCoin;
		}
		
		public function updateLifeTracker(currentLife:Number, maxLife:Number):void
		{
			if(_state == ChapterOneConstant.PLAYING_STATE)
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