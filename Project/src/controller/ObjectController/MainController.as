/*******************
 * =============== *
 * MAIN CONTROLLER *
 * =============== * 
 *******************/

package controller.ObjectController
{
	//Import library
	import constant.Constant;
	import constant.StoryConstant;
		
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
		|	      Game Stat          |
		-----------------------------*/
		private var _heroX:Number;
		private var _heroY:Number;
		
		private var _currCollectedObs	:Number;
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
		
		public function set currCollectedObs(value:Number):void{
			this._currCollectedObs = value;
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
			this._screen = screen;
			
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
				case Constant.INSTRUCTING_STATE:
					changeToInstructingState();
					break;
				case Constant.EDITTING_STATE:
					changeToEdittingState();
					break;
				case Constant.PLAYING_STATE:
					changeToPlayingState();
					break;
				case Constant.ENDING_STATE:
					changeToEndingState();
					break;
				case Constant.PAUSE_STATE:
					changeToPauseState();
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
			this._dialogue.state 	= Constant.INSTRUCTING_STATE;
			this._indexBoard.state  = Constant.INSTRUCTING_STATE;
		}
		
		private function changeToEdittingState():void
		{
			this._console.state 	= Constant.EDITTING_STATE;
			this._console.enableConsole();
			this._dialogue.state	= Constant.EDITTING_STATE;
			this._indexBoard.state  = Constant.EDITTING_STATE;
			this._scoreBoard.state 	= Constant.EDITTING_STATE;
		}
		
		private function changeToPauseState():void
		{
			this._scoreBoard.state 	= Constant.PAUSE_STATE;
			this._dialogue.state 	= Constant.PAUSE_STATE;
			this._indexBoard.state  = Constant.PAUSE_STATE;
			if(this._screen != Constant.STORY_SCREEN_1)
			{
				this._console.state 	= Constant.PAUSE_STATE;
			}
		}
		
		private function changeToPlayingState():void
		{
			this._scoreBoard.state 	= Constant.PLAYING_STATE;
			this._dialogue.state 	= Constant.PLAYING_STATE;
			this._indexBoard.state  = Constant.PLAYING_STATE;
					
			if(_screen != Constant.STORY_SCREEN_1)
			{
				this._console.state 	= Constant.PLAYING_STATE;
				this._console.enableConsole();
			}
			if(_maxLife == 0)
				_maxLife = 1;
			_currLife 	= _maxLife;
			_coinCollected 	= 0;
			this._indexBoard.updateMaxLife(_maxLife);
			notifyScoreBoard("coin");
			notifyScoreBoard("life");
		}
		
		private function changeToEndingState():void
		{
			this._console.state 	= Constant.ENDING_STATE;
			this._dialogue.state 	= Constant.ENDING_STATE;
			this._indexBoard.state  = Constant.ENDING_STATE;			
			this._scoreBoard.state  = Constant.ENDING_STATE;
		}	
		
		/**====================================================================
		 * |                      RECEIVE FROM OBJECT			              | *
		 * ====================================================================**/		
		public function receiveFromConsole(type:String, state:String):void
		{
			switch(type)
			{
				case Constant.STATE_CHANGE:
					changeState(state);
					break;
				case Constant.CONSOLE_ENTER:
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
					_indexBoard.analyzeArrayInput(commandArr);
					break;
				default:
					break;
			}	
		}
		
		public function receiveFromDialogue(type:String, state:String, e:Object):void
		{
			switch(type)
			{
				case Constant.STATE_CHANGE:
					changeState(state);
					break;
				case Constant.DIALOG_CHANGE:
					break;
				default:
					break;
			}
		}
		
		public function receiveFromHero(type:String, state:String):void
		{
			switch(type)
			{
				case Constant.STATE_CHANGE:
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
				case Constant.STATE_CHANGE:
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
				case Constant.STATE_CHANGE:
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
				case Constant.STATE_CHANGE:
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
				case Constant.STATE_CHANGE:
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
					//this._indexBoardController.removeLockOnCorrect(StoryConstant.STAGE5_QUESTION_POS);
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