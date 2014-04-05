/*****************************************************
 * ================================================= *
 *                   DIALOG OBJECT                   *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	//import library
	import assets.Assets;
	
	import constant.Constant;
	import constant.StoryConstant;
	
	import controller.ObjectController.MainController;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;

	public class Dialogue extends Sprite
	{
		/*----------------------------
		|	    Bubble variables     |
		-----------------------------*/
		private var _controller    		:MainController;
		private var _dialogueLine     	:TextField;
		private var _dialogueWhole		:Array;
		private var _dialogueContainer	:Image;
		private var _dialogueAuthor		:TextField;
		private var _dialogCurPos  		:uint;
		private var _screen				:String;
		
		/*----------------------------
		|	     Bubble state        |
		-----------------------------*/
		private var _state					 :String = Constant.INSTRUCTING_STATE;
		
		private var _isKeyUp:Boolean;
		
		public function Dialogue(controller:MainController)
		{	
			this._controller = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, 	onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/**====================================================================
		 * |                      GET - SET FUNCTIONS	                      | *
		 * ====================================================================**/
		public function set dialogCurPos(value:uint):void{
			_dialogCurPos = value;
		}
		
		public function set state(value:String):void{
			this._state = value;
		}
		
		public function set screen(value:String):void{
			this._screen = value;
		}

		/**====================================================================
		 * |	                     	FUNCTIONS	 		                  | *
		 * ====================================================================**/
		private function setDialogue(userDefDialogue:Array):void
		{
			switch(this._screen){
				case Constant.STORY_SCREEN_1:
					this._dialogueWhole = StoryConstant.STAGE1_INSTRUCTION;
					break;
				case Constant.STORY_SCREEN_2:
					this._dialogueWhole = StoryConstant.STAGE2_INSTRUCTION;
					break;
				case Constant.STORY_SCREEN_3:
					this._dialogueWhole = StoryConstant.STAGE3_INSTRUCTION;
					break;
				case Constant.STORY_SCREEN_4:
					this._dialogueWhole = StoryConstant.STAGE4_INSTRUCTION;
					break;
				case Constant.STORY_SCREEN_5:
					this._dialogueWhole = StoryConstant.STAGE5_INSTRUCTION;
					break;
				default:
					if(userDefDialogue != null)
						this._dialogueWhole = userDefDialogue;
					break;
			}
		}
		
		public function nextDialogueLine():void{
			if(this._dialogCurPos <= this._dialogueWhole.length){
				this._dialogueLine.text = this._dialogueWhole[this._dialogCurPos];
				if(this._screen != Constant.PLAY_SCREEN)
					checkStoryEvent();
				this._dialogCurPos ++;
			}
			else{
				disableKeyListeners();
				this._controller.changeState(Constant.PLAYING_STATE);
			}
		}
		
		private function checkStoryEvent():void{
			switch(this._screen){
				case Constant.STORY_SCREEN_2:
					if(this._dialogCurPos == StoryConstant.STAGE2_INSTR_SHOW_MONSTER)
						this._controller.stage2ShowMonster();
					else if(this._dialogCurPos == StoryConstant.STAGE2_INSTR_SHOW_CONSOLE)
						this._controller.stage2ShowConsole();
					else if(this._dialogCurPos == StoryConstant.STAGE2_INSTR_CONSOLE_CHECK)
						disableKeyListeners();
					break;
				case Constant.STORY_SCREEN_3:
					if(this._dialogCurPos == StoryConstant.STAGE3_LIFE_CHECK)
					{
						this._controller.enableLifeEdit(true);
						disableKeyListeners();
					}
					break;
				case Constant.STORY_SCREEN_4:
					if(this._dialogCurPos == StoryConstant.STAGE4_TIME_CHECK)
					{
						this._controller.enableTimeEdit(true);
						disableKeyListeners();
					}
					break;
				default:
					break;
			}
		}
		
		public function errorDialogue(errorText:String):void{
			this._dialogueLine.text = errorText;
		}
		/**====================================================================
		 * |	                     EVENT HANDLERS 		                  | *
		 * ====================================================================**/
		private function onAddedToStage(e:Event):void
		{
			this._dialogueLine 		= new TextField(500 , 100, null ,Constant.GROBOLD_FONT, 18);
			this._dialogCurPos 		= 0;				
			this._dialogueLine.x 	= 10;
			this._dialogueLine.y 	= 10;

			setDialogue(null);
			this.addChild(_dialogueLine);
			enableKeyListeners();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onKeyDown(event:Event):void
		{
			if(!this._controller.gotPopUp)
			{
				nextDialogueLine();
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
		private function onKeyUp(event:Event):void
		{
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeChildren();
			_dialogueLine = null;
		}
		
		public function enableKeyListeners():void{
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function disableKeyListeners():void{
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
	}
}