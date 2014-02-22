/*************************
 * ===================== *
 * CONTROLLER FOR BUBBLE *
 * ===================== * 
 *************************/

package controller.chapterOne
{
	import constant.ChapterOneConstant;
	
	import object.chapterOne.DialogBubble;
	
	public class BubbleController
	{
		private var _dialogBubble : DialogBubble;
		
		public function BubbleController(dialogBubble : DialogBubble)
		{
			this._dialogBubble = dialogBubble;	
		}
		
		public function changeDialog(dialogNum:uint):void{

			try{
				
				dialogNum ++ ;
				
				if(dialogNum <= ChapterOneConstant.DIALOG.length){
					
					_dialogBubble.changeDialogTextField(ChapterOneConstant.DIALOG[dialogNum]);
					_dialogBubble.dialogCurPos = dialogNum;
				}
				else{
					trace('Dialog position out of range.');
				}
			}
			catch(error:Error){
				trace('The dialog position of the dialog bubble is not defined.');
			}
		}
		
		public function changeObjectState(currentState:String):void
		{
			this._dialogBubble.changeState(currentState);
		}
	}
}