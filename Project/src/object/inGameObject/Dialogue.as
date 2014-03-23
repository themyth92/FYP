/*****************************************************
 * ================================================= *
 *                   DIALOG OBJECT                   *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	//import library
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	import constant.StoryConstant;
	
	import controller.ObjectController.Controller;
	
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
		private var _controller    		:Controller;
		private var _dialogue     		:TextField;
		private var _dialogueContainer	:Image;
		private var _dialogueAuthor		:TextField;
		private var _dialogCurPos  		:uint;
		private var _screen				:String;
		
		/*----------------------------
		|	     Bubble state        |
		-----------------------------*/
		private var _state					 :String = ChapterOneConstant.INSTRUCTING_STATE;
		private var _isKeyUp:Boolean;
		
		public function Dialogue(controller:Controller)
		{	
			this._controller = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, 	onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME, 		onEnterFrame);
		}
		
		public function set dialogCurPos(value:uint):void
		{
			_dialogCurPos = value;
		}

		public function changeDialogTextField(text:String):void
		{
			_dialogue.text = text;
			var info	:Array;
			if(_screen == Constant.STORY_SCREEN_2)
			{
				if(text == StoryConstant.STAGE2_INSTRUCTION[StoryConstant.STAGE2_INSTR_SHOW_MONSTER])
				{
					info = new Array(true,false,false);
					_controller.updateStageInfo(2,info);
				}
				else if(text == StoryConstant.STAGE2_INSTRUCTION[StoryConstant.STAGE2_INSTR_SHOW_CONSOLE])
				{
					info = new Array(false,true,false);
					_controller.updateStageInfo(2,info);
				}
				else if(text == StoryConstant.STAGE2_INSTRUCTION[StoryConstant.STAGE2_INSTR_CONSOLE_CHECK])
				{
					info = new Array(false,false,true);
					_controller.updateStageInfo(2,info);
				}	
			}else if(_screen == Constant.STORY_SCREEN_3)
			{
				if(text == StoryConstant.STAGE3_INSTRUCTION[StoryConstant.STAGE3_LIFE_CHECK])
				{
					info = new Array(true);
					_controller.updateStageInfo(3,info);
				}
			}
			else if(_screen == Constant.STORY_SCREEN_4)
			{
				if(text == StoryConstant.STAGE4_INSTRUCTION[StoryConstant.STAGE4_TIME_CHECK])
				{
					info = new Array(true);
					_controller.updateStageInfo(4,info);
				}
			}
					
			if(text == null)
			{
				if(_screen == Constant.CREATE_GAME_SCREEN)
				{
					_controller.receiveFromDialogue(ChapterOneConstant.STATE_CHANGE, ChapterOneConstant.EDITTING_STATE, null);
				}
				else 
				{
					_controller.receiveFromDialogue(ChapterOneConstant.STATE_CHANGE, ChapterOneConstant.PLAYING_STATE, null);
				}
			}
		}
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS 		                  | *
		 * ====================================================================**/
		private function onAddedToStage(e:Event):void
		{
			_dialogue 		= new TextField(500 , 100, null ,ChapterOneConstant.GROBOLD_FONT, 18);
			_dialogCurPos 	= 0;
					
			_dialogue.x = ChapterOneConstant.DIALOG_POSX;
			_dialogue.y = ChapterOneConstant.DIALOG_POSY + 30;
			
			_screen = _controller.screen;
			this.addChild(_dialogue);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onKeyDown(event:Event):void
		{
			if(!this._controller.gotPopUp)
			{
				if(_isKeyUp)
				{
					_controller.receiveFromDialogue(ChapterOneConstant.DIALOG_CHANGE, null, {event:ChapterOneConstant.TRIGGER, arg:_dialogCurPos, target:ChapterOneConstant.DIALOG_NEXT_ARROW});
					_isKeyUp = false;
				}
			}
		}
		
		private function onKeyUp(event:Event):void
		{
			_isKeyUp = true;
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeChild(_dialogue);
			_dialogue = null;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if(_state != ChapterOneConstant.INSTRUCTING_STATE)
			{
				this._dialogue.visible 	 = false;
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			else if(_screen == Constant.STORY_SCREEN_2 && _controller.stage2Info()[2])
			{
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			else if(_screen == Constant.STORY_SCREEN_3 && _controller.stageInfo(3)[0])
			{
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			else if(_screen == Constant.STORY_SCREEN_4 && _controller.stageInfo(4)[0])
			{
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			else
			{
				this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
		}		
	}
}