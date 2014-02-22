/*******************
 * =============== *
 * MAIN CONTROLLER *
 * =============== * 
 *******************/

package controller.chapterOne
{
	//Import library
	import constant.ChapterOneConstant;
	
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
	import object.chapterOne.Enemies;
	import object.chapterOne.Hero;
	import object.chapterOne.IndexBoard;
	import object.chapterOne.InstrArrow;
	import object.chapterOne.PatternList;
	import object.chapterOne.ScoreBoard;
	
	public class Controller
	{
		/*----------------------------
		|	    Object variable      |
		-----------------------------*/
		private var _button					 : Button;
		private var _console		 		 : Console;
		private var _dialogBubble	 		 : DialogBubble;
		private var _hero					 : Hero;
		private var _enemy1					 : Enemies;
		private var _enemy2 				 : Enemies;
		private var _indexBoard              : IndexBoard;
		private var _instrArrow     		 : InstrArrow;
		private var _patternList			 : PatternList;
		private var _scoreBoard				 : ScoreBoard;
	
		/*----------------------------
		| 	 Controller variable     |
		-----------------------------*/
		private var _dialogBubbleController  : BubbleController;
		private var _instrArrowController 	 : InstrArrController;
		private var _consoleController       : ConsoleController;
		private var _indexBoardController    : IndexBoardController;
		private var _scoreBoardController	 : ScoreBoardController;
		private var _buttonController		 : ButtonController;
		private var _patternListController	 : PatternListController;
		
		/*----------------------------
		|	      Game Stat          |
		-----------------------------*/
		private var _heroX:Number;
		private var _heroY:Number;
		
		private var _coinCollected 			 : Number;
		private var _maxCoin				 : Number = 0;
		private var _currentLife			 : Number;
		private var _maxLife				 : Number = 0;
		
		public function Controller(){
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
		
		public function notifyObserver(e:Object):void
		{
			if(e.event){
				if(e.event == ChapterOneConstant.TRIGGER){
					switch(e.target){
						case ChapterOneConstant.DIALOG_NEXT_ARROW:
							_dialogBubbleController.changeDialog(e.arg);
							_instrArrowController.showInstrArrowFromDialogBubble(e.arg);
						break;
						default:
						break;
					}
				}
				else if(e.event == ChapterOneConstant.KEY_PRESSED){
					switch(e.target){
						case ChapterOneConstant.HERO:
							_indexBoardController.moveHero(e.arg);
						break;
					}
				}
				else if(e.event == ChapterOneConstant.KEY_RELEASED){
					switch(e.target){
						case ChapterOneConstant.HERO:
							_indexBoardController.stopHero(e.arg);
						break;
					}
				}
			}
			else
				trace('Error with event undefined');
		}
		
		public function notifyForCollisionChecking(x:Number,y:Number):Array
		{
			_heroX = x;
			_heroY = y;
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
	
		/**====================================================================
		 * |                      GAME STATE HANDLER			              | *
		 * ====================================================================**/
		private function changeState(state:String):void
		{
			switch(state)
			{
				case ChapterOneConstant.INSTRUCTING_STATE:
					changeToInstructingState();
					break;
				case ChapterOneConstant.EDITTING_STATE:
					changeToEdittingState();
					break;
				case ChapterOneConstant.PLAYING_STATE:
					changeToPlayingState();
					break;
				case ChapterOneConstant.ENDING_STATE:
					changeToEndingState();
					break;
				default:
					break;
			}
		}
		
		private function changeToInstructingState():void
		{
			_buttonController		.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_consoleController		.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_dialogBubbleController	.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_indexBoardController	.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_patternListController	.changeObjectState 	(ChapterOneConstant.INSTRUCTING_STATE);
		}
		
		private function changeToEdittingState():void
		{
			_buttonController		.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_consoleController		.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_dialogBubbleController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_indexBoardController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_patternListController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
		}
		
		private function changeToPlayingState():void
		{
			_buttonController		.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			_consoleController		.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			_dialogBubbleController	.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			_indexBoardController	.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			_patternListController	.changeObjectState  (ChapterOneConstant.PLAYING_STATE);
			
			if(_maxLife == 0)
				_maxLife = 5;
			_currentLife 	= _maxLife;
			_coinCollected 	= 0;
			_indexBoardController.updateLifeOnGameStart(_maxLife);
			notifyScoreBoard("coin");
			notifyScoreBoard("life");
		}
		
		private function changeToEndingState():void
		{
			_buttonController		.changeObjectState	(ChapterOneConstant.ENDING_STATE);
			_consoleController		.changeObjectState	(ChapterOneConstant.ENDING_STATE);
			_dialogBubbleController	.changeObjectState	(ChapterOneConstant.ENDING_STATE);
			_indexBoardController	.changeObjectState	(ChapterOneConstant.ENDING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.ENDING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.ENDING_STATE);
		}	
		
		/**====================================================================
		 * |                      RECEIVE FROM OBJECT			              | *
		 * ====================================================================**/
		public function receiveFromButton(type:String, state:String, e:Object):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				case ChapterOneConstant.BUTTON_PRESS:
					switch(e.target)
					{
						case ChapterOneConstant.PREVIEW_BTN:
							var commandArr:Array = _consoleController.consoleControllerActivate();
							_indexBoardController.analyzeArrayInput(commandArr);
							break;
						case ChapterOneConstant.SUBMIT_BTN:
							var gotCoin:Boolean = _indexBoardController.checkCoinAvail(); 		  //Check if got coin or not
							var gotHero:Boolean = _indexBoardController.checkHeroAvail();		  //Check if got hero or not
							changeState(ChapterOneConstant.PLAYING_STATE);
							if(gotCoin && gotHero) //If got both => start game
							{
								trace("Have coin and character");
								
							}
							else
								trace("Don't have coin and character");
							break;
						default:
							break;
					}
					break;
				default:
					break;
			}
		}
		
		public function receiveFromConsole(type:String, state:String):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				case ChapterOneConstant.CONSOLE_ENTER:
					var commandArr:Array = _consoleController.consoleControllerActivate();
					_indexBoardController.analyzeArrayInput(commandArr);
					break;
				default:
					break;
			}	
		}
		
		public function receiveFromDialogBubble(type:String, state:String, e:Object):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				case ChapterOneConstant.DIALOG_CHANGE:
					notifyBubbleController(ChapterOneConstant.DIALOG_CHANGE,e);
					notifyInstrArrController(ChapterOneConstant.DIALOG_CHANGE,e);
					break;
				default:
					break;
			}
		}
		
		public function receiveFromHero(type:String, state:String):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				default:
					break;
			}
		}
		
		public function receiveFromIndexBoard(type:String, state:String):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				default:
					break;
			}	
		}
		
		public function receiveFromInstrArrow(type:String, state:String):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				default:
					break;
			}
		}
		
		public function receiveFromPatterList(type:String, state:String):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				default:
					break;
			}
		}
		
		public function receiveFromScoreBoard(type:String, state:String):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				default:
					break;
			}	
		}
		
		public function checkAgro(enemy:Enemies):Array
		{
			return _indexBoardController.followPlayer(enemy, _heroX, _heroY);
		} 
		
		public function updateUnits(enemy1:Enemies,enemy2:Enemies, hero:Hero):void
		{
			if(enemy1 != null)
				this._enemy1 = enemy1;
			else if (enemy2 != null)
				this._enemy2 = enemy2;
			else
				this._hero = hero;	
		}
		
		/**====================================================================
		 * |                    NOTIFY OBJECT FOR ACTION			          | *
		 * ====================================================================**/
		private function notifyBubbleController(type:String, e:Object):void
		{
			switch(type)
			{
				case ChapterOneConstant.DIALOG_CHANGE:
					_dialogBubbleController.changeDialog(e.arg);		
					break;			
				default:
					break;
			}
		}
		
		private function notifyButtonController(type:String):void
		{
			switch(type)
			{
				default:
					break;
			}
		}
		
		private function notifyConsoleController(type:String):void
		{
			switch(type)
			{
				default:
					break;
			}	
		}
	
		private function notifyIndexBoardController(type:String):void
		{
			switch(type)
			{
				default:
					break;
			}	
		}
		
		private function notifyInstrArrController(type:String, e:Object):void
		{
			switch(type)
			{
				case ChapterOneConstant.DIALOG_CHANGE: 
					_instrArrowController.showInstrArrowFromDialogBubble(e.arg);
					break;
				default:
					break;
			}	
		}
		
		private function notifyPatterListController(type:String):void
		{
			switch(type)
			{
				default:
					break;
			}
		}
		
		private function notifyScoreBoardController(type:String):void
		{
			switch(type)
			{
				default:
					break;
			}
		}
	}
}