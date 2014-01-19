/*******************
 * =============== *
 * MAIN CONTROLLER *
 * =============== * 
 *******************/

package controller.chapterOne
{
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.BubbleController;
	import controller.chapterOne.ButtonController;
	import controller.chapterOne.ConsoleController;
	import controller.chapterOne.IndexBoardController;
	import controller.chapterOne.InstrArrController;
	import controller.chapterOne.PatternListController;
	import controller.chapterOne.ScoreBoardController;
	
	import object.chapterOne.Button;
	import object.chapterOne.Console;
	import object.chapterOne.DialogBubble;
	import object.chapterOne.Hero;
	import object.chapterOne.IndexBoard;
	import object.chapterOne.InstrArrow;
	import object.chapterOne.PatternList;
	import object.chapterOne.ScoreBoard;
	
	public class Controller
	{
		private var _button					 : Button;
		private var _console		 		 : Console;
		private var _dialogBubble	 		 : DialogBubble;
		private var _hero					 : Hero;
		private var _indexBoard              : IndexBoard;
		private var _instrArrow     		 : InstrArrow;
		private var _patternList			 : PatternList;
		private var _scoreBoard				 : ScoreBoard;
	
		private var _dialogBubbleController  : BubbleController;
		private var _instrArrowController 	 : InstrArrController;
		private var _consoleController       : ConsoleController;
		private var _indexBoardController    : IndexBoardController;
		private var _scoreBoardController	 : ScoreBoardController;
		private var _buttonController		 : ButtonController;
		private var _patternListController	 : PatternListController;
		
		private var _coinCollected 			 : Number;
		private var _maxCoin				 : Number = 0;
		private var _currentLife			 : Number;
		private var _maxLife				 : Number = 0;
		
		public function Controller(){
		}
		
		public function notifyObserver(e:Object):void{
			
			if(e.event){
				if(e.event == Constant.TRIGGER){
					switch(e.target){
						case Constant.DIALOG_NEXT_ARROW:
							_dialogBubbleController.changeDialog(e.arg);
							_instrArrowController.showInstrArrowFromDialogBubble(e.arg);
						break;
						case Constant.PREVIEW_BTN:
							var commandArr:Array = _consoleController.consoleControllerActivate();
							_indexBoardController.analyzeArrayInput(commandArr);
						break;
						case Constant.SUBMIT_BTN:
							var gotCoin:Boolean = _indexBoardController.checkCoinAvail(); 		  //Check if got coin or not
							var gotHero:Boolean = _indexBoardController.checkHeroAvail();		  //Check if got hero or not
							playingState();
							if(gotCoin && gotHero) //If got both => start game
								trace("gotSth");
							else
								trace("noSth");
						break;
						default:
						break;
					}
				}
				else if(e.event == Constant.KEY_PRESSED){
					switch(e.target){
						case Constant.HERO:
							_indexBoardController.moveHero(e.arg);
						break;
					}
				}
				else if(e.event == Constant.KEY_UP){
					switch(e.target){
						case Constant.HERO:
							_indexBoardController.stopHero(e.arg);
						break;
					}
				}
			}
			else
				trace('Error with event undefined');
		}
		
		public function instructingState():void
		{
			_buttonController.changeObjectState			(Constant.INSTRUCTING_STATE);
			_consoleController.changeObjectState		(Constant.INSTRUCTING_STATE);
			_dialogBubbleController.changeObjectState	(Constant.INSTRUCTING_STATE);
			_indexBoardController.changeObjectState		(Constant.INSTRUCTING_STATE);
			_scoreBoardController.changeObjectState		(Constant.INSTRUCTING_STATE);
			_patternListController.changeObjectState 	(Constant.INSTRUCTING_STATE);
		}
		
		public function edittingState():void
		{
			_buttonController.changeObjectState			(Constant.EDITTING_STATE);
			_consoleController.changeObjectState		(Constant.EDITTING_STATE);
			_dialogBubbleController.changeObjectState	(Constant.EDITTING_STATE);
			_indexBoardController.changeObjectState		(Constant.EDITTING_STATE);
			_scoreBoardController.changeObjectState		(Constant.EDITTING_STATE);
			_patternListController.changeObjectState	(Constant.EDITTING_STATE);
		}
		
		public function playingState():void
		{
			_buttonController.changeObjectState			(Constant.PLAYING_STATE);
			_consoleController.changeObjectState		(Constant.PLAYING_STATE);
			_dialogBubbleController.changeObjectState	(Constant.PLAYING_STATE);
			_indexBoardController.changeObjectState		(Constant.PLAYING_STATE);
			_scoreBoardController.changeObjectState		(Constant.PLAYING_STATE);
			_patternListController.changeObjectState    (Constant.PLAYING_STATE);
			if(_maxLife == 0)
				_maxLife = 5;
			_currentLife 	= _maxLife;
			_coinCollected 	= 0;
			_indexBoardController.updateLifeOnGameStart(_maxLife);
			notifyScoreBoard("coin");
			notifyScoreBoard("life");
		}

		public function endingState():void
		{
			_buttonController.changeObjectState			(Constant.ENDING_STATE);
			_consoleController.changeObjectState		(Constant.ENDING_STATE);
			_dialogBubbleController.changeObjectState	(Constant.ENDING_STATE);
			_indexBoardController.changeObjectState		(Constant.ENDING_STATE);
			_scoreBoardController.changeObjectState		(Constant.ENDING_STATE);
			_scoreBoardController.changeObjectState		(Constant.ENDING_STATE);
		}
	
		public function debug():void
		{
			var commandArr:Array = _consoleController.consoleControllerActivate();
			_indexBoardController.analyzeArrayInput(commandArr);
		}
		
		public function assignObjectController(console:Console, dialogBubble:DialogBubble, instrArrow:InstrArrow, indexBoard:IndexBoard, button:Button, patternList:PatternList, scoreBoard:ScoreBoard):void
		{
			this._console 		    = console;
			this._dialogBubble      = dialogBubble;
			this._instrArrow        = instrArrow;
			this._indexBoard        = indexBoard;
			this._button 			= button;
			this._patternList		= patternList;
			this._scoreBoard        = scoreBoard;
			
			_dialogBubbleController = new BubbleController(_dialogBubble);
			_instrArrowController   = new InstrArrController(_instrArrow);
			_consoleController      = new ConsoleController(_console);
			_indexBoardController   = new IndexBoardController(_indexBoard);
			_buttonController		= new ButtonController(_button);
			_patternListController  = new PatternListController(_patternList);
			_scoreBoardController 	= new ScoreBoardController(_scoreBoard);
		}
		
		public function notifyForCollisionChecking(x:Number,y:Number):Array
		{
			return _indexBoardController.collisionDetect(x,y);
		}
		
		public function notifyCollectCoin(index:uint):void
		{
			_indexBoardController.removeCoinOnCollision(index);
		}
		
		public function notifyIndexBoard(type:String):void
		{
			_indexBoard.onTouchListener(true, type);
		}
		
		public function mouseInputAnalyze(type:String, x:Number, y:Number):void
		{
			_indexBoardController.dragDropAnalyze(type,x,y);
		}
		
		public function getGameStat(type:String, value:Number):void
		{
			if(type == "max coin")
				_maxCoin = value;
			if(type == "coin")
			{
				_coinCollected = value;
				notifyScoreBoard("coin");
			}
			if(type == "max life")
				_maxLife = value;
			if(type == "life")
			{
				_currentLife = value;
				notifyScoreBoard("life");
			}
		}
		
		private function notifyScoreBoard(type:String):void
		{
			if(type == "life")
				_scoreBoardController.lifeUpdateProcess(_currentLife, _maxLife);
			if(type == "coin")
				_scoreBoardController.coinUpdateProcess(_coinCollected, _maxCoin);
		}
	}
}