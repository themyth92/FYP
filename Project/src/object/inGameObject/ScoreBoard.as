package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	
	import flash.geom.Point;
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
		private var _lifeIMG	: feathers.controls.Button;
		private var _timeIMG	: feathers.controls.Button;
		
		private var _maxLife 	:Number;
		
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
			this.addEventListener(TouchEvent.TOUCH		   		, onTouch);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME	, updateTimeTracker);
		}
		
		private function onAddedToStage(event:Event):void
		{
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
			
			this._timeIMG	 = new feathers.controls.Button();
			this._timeIMG.defaultIcon = new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.CLOCK_IMG));
			this._timeIMG.x  = TIME_IMG_POS.x;
			this._timeIMG.y  = TIME_IMG_POS.y;
			
			this._lifeIMG 	 = new feathers.controls.Button();
			this._lifeIMG.defaultIcon = new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.LIFE_IMG));
			this._lifeIMG.x  = LIFE_IMG_POS.x;
			this._lifeIMG.y  = LIFE_IMG_POS.y;
			
			this.addChild(this._coinText);
			this.addChild(this._lifeText);
			this.addChild(this._timeText);
			this.addChild(this._coinIMG);
			this.addChild(this._timeIMG);
			this.addChild(this._lifeIMG);
			
			this.addEventListener(Event.TRIGGERED, onButtonClicked);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			Alert.show("I just wanted you to know that I have a very important message to share with you.", "Alert", new ListCollection(
				[
					{ label: "OK" }
				]));
	
		}
		
		private function onButtonClicked(event:Event):void
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