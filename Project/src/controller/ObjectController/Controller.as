/*******************
 * =============== *
 * MAIN CONTROLLER *
 * =============== * 
 *******************/

package controller.ObjectController
{
	//Import library
	import constant.ChapterOneConstant;
	import constant.Constant;
	import constant.StoryConstant;
	
	import controller.ObjectController.BubbleController;
	import controller.ObjectController.ButtonController;
	import controller.ObjectController.ConsoleController;
	import controller.ObjectController.IndexBoardController;
	import controller.ObjectController.InstrArrController;
	import controller.ObjectController.ObstaclesBoardController;
	import controller.ObjectController.ScoreBoardController;
	
	import object.inGameObject.Button;
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.Enemies;
	import object.inGameObject.Hero;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.InstrArrow;
	import object.inGameObject.ObstaclesBoard;
	import object.inGameObject.ScoreBoard;
	
	public class Controller
	{
		/*----------------------------
		|	    Object variable      |
		-----------------------------*/
		private var _button					 : Button;
		private var _console		 		 : Console;
		private var _dialogBubble	 		 : Dialogue;
		private var _hero					 : Hero;
		private var _enemy1					 : Enemies;
		private var _enemy2 				 : Enemies;
		private var _indexBoard              : IndexBoard;
		private var _instrArrow     		 : InstrArrow;
		private var _patternList			 : ObstaclesBoard;
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
		private var _patternListController	 : ObstaclesBoardController;
		
		/*----------------------------
		|	      Game Stat          |
		-----------------------------*/
		private var _heroX:Number;
		private var _heroY:Number;
		
		private var _coinCollected 			 : Number;
		private var _maxCoin				 : Number = 0;
		private var _currentLife			 : Number;
		private var _maxLife				 : Number = 0;
		private var _isWon					:Boolean = false;
		private var _isLost					:Boolean = false;
		private var _screen					:String;
		private var _currDialogPos			:uint = 0;
		
		// STAGE VARIABLE
		/* Stage 2 */
		private var _stage2Monster		:Boolean;
		private var _stage2Console		:Boolean;
		private var _consoleChecking	:Boolean;
		
		/* Stage 3 */
		private var _stage3CheckLife	:Boolean = false;
		
		/* Stage 4 */
		private var _stage4CheckTime	:Boolean = false;
		
		//Control input variables
		private var _isCorrect			:Boolean;
		private var _gotPopUp			:Boolean;
		private var _state				:String;
		
		public function Controller(){
			
		}
		
		public function updateAnswerStatus(isCorrect:Boolean):void{
			this._isCorrect = isCorrect;
			if(this._screen == Constant.STORY_SCREEN_5 && this._isCorrect)
				this.notifyIndexBoardController("stage5RemoveLock");
		}
		
		public function set gotPopUp(value:Boolean):void
		{
			this._gotPopUp = value;
		}
		
		public function get gotPopUp():Boolean
		{
			return _gotPopUp;
		}
			
		public function assignScreen(screen:String):void
		{
			_screen = screen;
			updateScreen(_screen);
		}
		
		private function updateScreen(screen:String):void
		{
			_dialogBubbleController.currScreen(screen);
		}
		
		public function get screen():String
		{
			return _screen;
		}
		
		public function set isWon(isWon:Boolean):void
		{
			_isWon = isWon;
		}
		
		public function get isWon():Boolean
		{
			return _isWon;
		}
		
		public function set isLost(value:Boolean):void
		{
			_isLost = value;
		}
		
		public function get isLost():Boolean
		{
			return _isLost;
		}
		
		public function assignObjectController(console: Console, dialogBubble: Dialogue, instrArrow: InstrArrow, indexBoard: IndexBoard, button: Button, patternList: ObstaclesBoard, scoreBoard: ScoreBoard):void
		{
			_console 		   	= console;
			_dialogBubble      	= dialogBubble;
			_instrArrow        	= instrArrow;
			_indexBoard        	= indexBoard;
			_button 			= button;
			_patternList		= patternList;
			_scoreBoard        	= scoreBoard;
			
			_dialogBubbleController = new BubbleController		(_dialogBubble);
			_instrArrowController   = new InstrArrController	(_instrArrow);
			_consoleController      = new ConsoleController		(_console);
			_indexBoardController   = new IndexBoardController	(_indexBoard);
			_buttonController		= new ButtonController		(_button);
			_patternListController  = new ObstaclesBoardController	(_patternList);
			_scoreBoardController 	= new ScoreBoardController	(_scoreBoard);
		}
				
		public function stage2Info():Array
		{
			var result:Array = new Array(_stage2Monster, _stage2Console, _consoleChecking);
			return result;	
		}
		
		public function stageInfo(stage:Number):Array
		{
			var info :Array;
			switch(stage){
				case 2:
					info = new Array(_stage2Monster, _stage2Console, _consoleChecking);
					break;
				case 3:
					info = new Array(_stage3CheckLife);
					break;
				case 4:
					info = new Array(_stage4CheckTime);
					break;
				case 5:
					break;
				default:
					break;
			}
			
			return info;
		}
		
		public function updateStageInfo(stage:Number,value:Array):void
		{
			switch(stage)
			{
				case 2:
					if(value[0])
					{
						_stage2Monster	= true;
						_indexBoard.stage2MonsterOn();
					}
					if(value[1])
						_stage2Console	= true;
					if(value[2])
						_consoleChecking = true;
					break;
				case 3:
					this._stage3CheckLife = value[0];
					if(value[0])
						notifyScoreBoardController("enableLifeEdit");
					else
						notifyDialogueController(ChapterOneConstant.DIALOG_CHANGE,null);
					break;
				case 4:
					this._stage4CheckTime = value[0];
					if(value[0])
						notifyScoreBoardController("enableTimeEdit");
					else
						notifyDialogueController(ChapterOneConstant.DIALOG_CHANGE,null);
					break;
				default:
					break;
			}
		}

		public function showIncorrectDialouge(type:String):void
		{
			if(_screen == Constant.STORY_SCREEN_3)
			{
				if(type == "<")
					notifyDialogueController(StoryConstant.STAGE3_ERROR_SMALL, null);
				else if(type == ">")
					notifyDialogueController(StoryConstant.STAGE3_ERROR_LARGE, null);
			}
			else if(_screen == Constant.STORY_SCREEN_3)
			{
				if(type == "time")
					notifyDialogueController(StoryConstant.STAGE4_ERROR, null);
			}
		}
		
		public function updateStage4Info():void
		{
			this._stage4CheckTime = true;
		}
		
		public function startGame(player:Array, enemy1:Array, enemy2:Array):String
		{
			var enemyType :Array = new Array(enemy1[0], enemy2[0]);
			var enemyPos  :Array = new Array(enemy1[1], enemy2[1]);
			var enemySpd  :Array = new Array(enemy1[2], enemy2[2]);
			var enemyImg  :Array = new Array(enemy1[3], enemy2[3]);
			
			_indexBoardController.createEnemies(enemyType, enemySpd, enemyImg, enemyPos);
			_indexBoardController.createPlayer(player[0], player[1]);
			
			changeState(ChapterOneConstant.PLAYING_STATE);
			return null;
		}
		
		public function previewGame(player:Array, enemy1:Array, enemy2:Array):String
		{
			var enemyType :Array = new Array(enemy1[0], enemy2[0]);
			var enemyPos  :Array = new Array(enemy1[1], enemy2[1]);
			var enemySpd  :Array = new Array(enemy1[2], enemy2[2]);
			var enemyImg  :Array = new Array(enemy1[3], enemy2[3]);
			
			_indexBoardController.createEnemies(enemyType, enemySpd, enemyImg, enemyPos);
			_indexBoardController.createPlayer(player[0], player[1]);
			
			return null;
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
		
		public function checkCollision():void
		{
			_indexBoardController.checkPlayerCollideEnemy();
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
			_consoleController		.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_dialogBubbleController	.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_indexBoardController	.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
			_patternListController	.changeObjectState 	(ChapterOneConstant.INSTRUCTING_STATE);
		}
		
		private function changeToEdittingState():void
		{
		
			_consoleController		.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_dialogBubbleController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_indexBoardController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			_patternListController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
		}
		
		private function changeToPlayingState():void
		{	
			_dialogBubbleController	.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			_indexBoardController	.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			_scoreBoardController	.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			
			if(_screen != Constant.STAGE1_SCREEN)
			{
				_consoleController		.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
			}
			
			if(_screen == Constant.CREATE_GAME_SCREEN)
			{
				_patternListController	.changeObjectState  (ChapterOneConstant.PLAYING_STATE);
			}
			
			if(_maxLife == 0)
				_maxLife = 1;
			_currentLife 	= _maxLife;
			_coinCollected 	= 0;
			_indexBoardController.updateLifeOnGameStart(_maxLife);
			notifyScoreBoard("coin");
			notifyScoreBoard("life");
		}
		
		private function changeToEndingState():void
		{
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
					if(commandArr[0] == false && _screen == Constant.STORY_SCREEN_2)
					{
						notifyDialogueController(ChapterOneConstant.ERROR_NOTIFY1,null);
					}
					else
					{
						if(commandArr[0]==1 && commandArr[1]==0 && commandArr[2]==57)
						{
							_consoleChecking = false;
							notifyDialogueController(ChapterOneConstant.DIALOG_CHANGE,null);
						}
						else
						{
							notifyDialogueController(ChapterOneConstant.ERROR_NOTIFY2,null);
						}
					}
					_indexBoardController.analyzeArrayInput(commandArr);
					break;
				default:
					break;
			}	
		}
		
		public function receiveFromDialogue(type:String, state:String, e:Object):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				case ChapterOneConstant.DIALOG_CHANGE:
					notifyDialogueController(ChapterOneConstant.DIALOG_CHANGE,e);
//					notifyInstrArrController(ChapterOneConstant.DIALOG_CHANGE,e);
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
		private function notifyDialogueController(type:String, e:Object):void
		{
			switch(type)
			{
				case ChapterOneConstant.DIALOG_CHANGE:
					if(e != null)
						_currDialogPos = e.arg;
					else
						_currDialogPos += 1;
					_dialogBubbleController.changeDialog(_currDialogPos);		
					break;	
				case ChapterOneConstant.ERROR_NOTIFY1:
					_dialogBubbleController.errorNotify(1);
					break;
				case ChapterOneConstant.ERROR_NOTIFY2:
					_dialogBubbleController.errorNotify(2);
					break;
				case StoryConstant.STAGE3_ERROR_SMALL:
					_dialogBubbleController.errorNotify(3);
					break;
				case StoryConstant.STAGE3_ERROR_LARGE:
					_dialogBubbleController.errorNotify(4);
					break;
				case StoryConstant.STAGE4_ERROR:
					_dialogBubbleController.errorNotify(5);
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
				case "stage5RemoveLock":
					this._indexBoardController.removeLockOnCorrect(StoryConstant.STAGE5_QUESTION_POS);
					break;
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
				case "enableLifeEdit":
					this._scoreBoardController.enableLifeEdit(true);
					break;
				case "enableTimeEdit":
					this._scoreBoardController.enableTimeEdit(true);
					break;
				default:
					break;
			}
		}
	}
}