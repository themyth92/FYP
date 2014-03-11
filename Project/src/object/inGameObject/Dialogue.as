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
		
		/*----------------------------
		|	     Bubble state        |
		-----------------------------*/
		private var _state					 :String = ChapterOneConstant.INSTRUCTING_STATE;
		
		public function Dialogue(controller:Controller)
		{	
			this._controller = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function set dialogCurPos(value:uint):void
		{
			_dialogCurPos = value;
		}

		public function changeDialogTextField(text:String):void
		{
			_dialogue.text = text;
			if(text == null)
			{
				trace("text null")
				_controller.receiveFromDialogue(ChapterOneConstant.STATE_CHANGE, ChapterOneConstant.EDITTING_STATE, null);
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
			_dialogue 		= new TextField(500 , 100, ChapterOneConstant.WELCOME_DIALOG ,ChapterOneConstant.GROBOLD_FONT);
			_dialogCurPos 	= 0;
					
			_dialogue.x = ChapterOneConstant.DIALOG_POSX;
			_dialogue.y = ChapterOneConstant.DIALOG_POSY + 30;
			
			this.addChild(_dialogue);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onKeyPress(event:Event):void
		{
			_controller.receiveFromDialogue(ChapterOneConstant.DIALOG_CHANGE, null, {event:ChapterOneConstant.TRIGGER, arg:_dialogCurPos, target:ChapterOneConstant.DIALOG_NEXT_ARROW});
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
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			}
			else
			{
				this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			}
		}		
	}
}