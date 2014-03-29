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
	
	import controller.ObjectController.IndexBoardController;
	
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.Enemies;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.Player;
	import object.inGameObject.ScoreBoard;
	
	public class MainController
	{
		/*----------------------------
		|	    Object variable      |
		-----------------------------*/
		private var _console		 		 : Console;
		private var _dialogue		 		 : Dialogue;
		private var _hero					 : Player;
		private var _enemy1					 : Enemies;
		private var _enemy2 				 : Enemies;
		private var _indexBoard              : IndexBoard;
		private var _scoreBoard				 : ScoreBoard;
	
		/*----------------------------
		| 	 Controller variable     |
		-----------------------------*/
		private var _indexBoardController    : IndexBoardController;
		
		/*----------------------------
		|	      Game Stat          |
		-----------------------------*/
		private var _heroX:Number;
		private var _heroY:Number;
		
		private var _coinCollected 			 : Number;
		private var _maxCoin				 : Number = 0;
		private var _currLife				 : Number;
		private var _maxLife				 : Number = 0;
		private var _isWon					:Boolean = false;
		private var _isLost					:Boolean = false;
		private var _screen					:String;
		private var _currDialogPos			:uint = 0;
		
		/*--------------------------------------
		|	      Story mode variables         |
		----------------------------------------*/
		//Control input variables
		private var _isCorrect			:Boolean;
		private var _gotPopUp			:Boolean;
		private var _state				:String;
		
		/* Stage 2 */
		private var _stage2Monster		:Boolean;
		private var _stage2Console		:Boolean;
		private var _consoleChecking	:Boolean;
		
		/* Stage 3 */
		private var _stage3CheckLife	:Boolean = false;
		
		/* Stage 4 */
		private var _stage4CheckTime	:Boolean = false;
		
		public function MainController(){
			
		}
		
		/**====================================================================
		 * |	                    STORY MODE HANDLERS			              | *
		 * ====================================================================**/
		public function enableLifeEdit(state:Boolean):void
		{
			if(state)
				this._scoreBoard.isLifeEnabled = true;
			else
			{
				this._dialogue.enableKeyListeners();
				this._dialogue.nextDialogueLine();
			}
		}
		
		public function enableTimeEdit(state:Boolean):void
		{
			if(state)
				this._scoreBoard.isTimeEnabled = true;
			else
			{
				this._dialogue.enableKeyListeners();
				this._dialogue.nextDialogueLine();
			}
		}
		
		public function stage2ShowMonster():void{
			this._indexBoard.stage2MonsterOn();
		}
		
		public function stage2ShowConsole():void{
			this._console.showConsole();
		}
		
		public function showIncorrectDialouge(type:String):void
		{
			if(_screen == Constant.STORY_SCREEN_3)
			{
				if(type == "<")
					this._dialogue.errorDialogue(StoryConstant.STAGE3_ERROR_SMALL);
				else if(type == ">")
					this._dialogue.errorDialogue(StoryConstant.STAGE3_ERROR_LARGE);
			}
			else if(_screen == Constant.STORY_SCREEN_4)
			{
				if(type == "time")
					this._dialogue.errorDialogue(StoryConstant.STAGE4_ERROR);
			}
		}

		/**====================================================================
		 * |	                    GET-SET FUNCTIONS			              | *
		 * ====================================================================**/
		
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
			if(this._console != null)
				this._console.screen = screen;
			if(this._dialogue != null)
				this._dialogue.screen = screen;
			if(this._indexBoard != null)
				this._indexBoard.screen = screen;
			if(this._scoreBoard != null)
				this._scoreBoard.screen = screen;
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
		
		public function assignObjectController(console: Console, dialogBubble: Dialogue, indexBoard: IndexBoard, scoreboard:ScoreBoard):void
		{
			this._console 		= console;
			this._dialogue      = dialogBubble;
			this._indexBoard    = indexBoard;
			this._scoreBoard 	= scoreboard;
			
			_indexBoardController   = new IndexBoardController	(_indexBoard);
		}
				
				
		public function checkOutOfGameArea():Array
		{
			return this._indexBoard.checkPlayerOutOfArea();
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
							//_dialogueController.changeDialog(e.arg);
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
			return _indexBoardController.collideWithObstacles(x,y);
		}
		
		public function checkCollision():void
		{
			_indexBoardController.collideWithEnemy();
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
				this._currLife = value;
				notifyScoreBoard("life");
			}
		}
		
		private function notifyScoreBoard(type:String):void
		{
			if(type == "life")
			{
				this._scoreBoard.currLife = this._currLife;
				this._scoreBoard.updateLifeText();
			}
			
			if(type == "coin")
			{
				this._scoreBoard.currCoin = this._coinCollected;
				this._scoreBoard.updateCoinText();
			}
		}
	
		/**====================================================================
		 * |                      GAME STATE HANDLER			              | *
		 * ====================================================================**/
		public function changeState(state:String):void
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
			this._console.state 	= Constant.INSTRUCTING_STATE;
			this._console.enableConsole();
			
			this._scoreBoard.state	= Constant.INSTRUCTING_STATE;
			this._dialogue.state = Constant.INSTRUCTING_STATE;
			_indexBoardController	.changeObjectState	(ChapterOneConstant.INSTRUCTING_STATE);
		}
		
		private function changeToEdittingState():void
		{
			this._console.state 	= Constant.EDITTING_STATE;
			this._console.enableConsole();
			this._dialogue.state = Constant.EDITTING_STATE;
			_indexBoardController	.changeObjectState	(ChapterOneConstant.EDITTING_STATE);
			this._scoreBoard.state = Constant.EDITTING_STATE;
		}
		
		private function changeToPlayingState():void
		{
			
			this._scoreBoard.state 	= Constant.PLAYING_STATE;
			this._dialogue.state = Constant.PLAYING_STATE;
			_indexBoardController	.changeObjectState	(ChapterOneConstant.PLAYING_STATE);
					
			if(_screen != Constant.STAGE1_SCREEN)
			{
				this._console.state 	= Constant.PLAYING_STATE;
				this._console.enableConsole();
			}
			if(_maxLife == 0)
				_maxLife = 1;
			_currLife 	= _maxLife;
			_coinCollected 	= 0;
			_indexBoardController.updateLifeOnGameStart(_maxLife);
			notifyScoreBoard("coin");
			notifyScoreBoard("life");
		}
		
		private function changeToEndingState():void
		{
			this._console.state 	= Constant.ENDING_STATE;
			this._dialogue.state = Constant.ENDING_STATE;
			_indexBoardController	.changeObjectState	(ChapterOneConstant.ENDING_STATE);
			
			this._scoreBoard.state = Constant.ENDING_STATE;
		}	
		
		/**====================================================================
		 * |                      RECEIVE FROM OBJECT			              | *
		 * ====================================================================**/		
		public function receiveFromConsole(type:String, state:String):void
		{
			switch(type)
			{
				case ChapterOneConstant.STATE_CHANGE:
					changeState(state);
					break;
				case ChapterOneConstant.CONSOLE_ENTER:
					var commandArr:Array = this._console.commandArray;
					if(commandArr[0] == false && _screen == Constant.STORY_SCREEN_2)
					{
						this._dialogue.errorDialogue(StoryConstant.STAGE2_ERROR_GUIDER1);
					}
					else
					{
						if(commandArr[0]==1 && commandArr[1]==0 && commandArr[2]==57)
						{
							this._dialogue.enableKeyListeners();
							this._dialogue.nextDialogueLine();
						}
						else
						{
							this._dialogue.errorDialogue(StoryConstant.STAGE2_ERROR_GUIDER2);						}
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
//					notifyDialogueController(ChapterOneConstant.DIALOG_CHANGE,e);
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
		
		public function updateUnits(enemy1:Enemies,enemy2:Enemies, hero:Player):void
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
		
		private function notifyPatterListController(type:String):void
		{
			switch(type)
			{
				default:
					break;
			}
		}
	}
}