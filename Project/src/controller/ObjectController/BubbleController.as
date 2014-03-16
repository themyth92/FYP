/*************************
 * ===================== *
 * CONTROLLER FOR BUBBLE *
 * ===================== * 
 *************************/

package controller.ObjectController
{
	import constant.ChapterOneConstant;
	import constant.Constant;
	import constant.StoryConstant;
	
	import object.inGameObject.Dialogue;
	
	public class BubbleController
	{
		private var _dialogBubble : Dialogue;
		private var _screen		  : String;
		
		public function BubbleController(dialogBubble : Dialogue)
		{
			this._dialogBubble = dialogBubble;	
		}
		
		public function currScreen(screen:String):void
		{
			this._screen = screen;
		}
		
		public function changeDialog(dialogNum:uint):void
		{
			var dialog :Array;
			switch(_screen){
				case Constant.CREATE_GAME_SCREEN:
					dialog = ChapterOneConstant.DIALOG;
					nextDialog(dialog,dialogNum);
					break;
				case Constant.STORY_SCREEN_1:
					dialog = StoryConstant.STAGE1_INSTRUCTION;
					nextDialog(dialog,dialogNum);
					break;
				case Constant.STORY_SCREEN_2:
					dialog = StoryConstant.STAGE2_INSTRUCTION;
					nextDialog(dialog,dialogNum);
					break;
				case Constant.STORY_SCREEN_3:
					dialog = StoryConstant.STAGE3_INSTRUCTION;
					nextDialog(dialog,dialogNum);
					break;
				case Constant.STORY_SCREEN_4:
					dialog = StoryConstant.STAGE4_INSTRUCTION;
					nextDialog(dialog,dialogNum);
					break;
				case Constant.STORY_SCREEN_5:
					dialog = StoryConstant.STAGE5_INSTRUCTION;
					nextDialog(dialog,dialogNum);
					break;
				default:
					break;
			}
		}
		
		private function nextDialog(dialog:Array, pos:uint):void
		{
			try{								
				if(pos <= dialog.length){
						
					_dialogBubble.changeDialogTextField(dialog[pos]);
					pos ++ ;
					_dialogBubble.dialogCurPos = pos;
				}
				else{
					trace('Dialog position out of range.');
				}
			}
			catch(error:Error){
				trace('The dialog position of the dialog bubble is not defined.');
			}
		}
		
		public function errorNotify(error:uint):void
		{
			if(error == 1)
				_dialogBubble.changeDialogTextField(StoryConstant.STAGE2_ERROR_GUIDER1);
			else
				_dialogBubble.changeDialogTextField(StoryConstant.STAGE2_ERROR_GUIDER2);
		}
			
		public function changeObjectState(currentState:String):void
		{
			this._dialogBubble.changeState(currentState);
		}
	}
}