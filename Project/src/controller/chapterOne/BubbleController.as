/*************************
 * ===================== *
 * CONTROLLER FOR BUBBLE *
 * ===================== * 
 *************************/

package controller.chapterOne
{
	import constant.chapterOne.Constant;
	
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
				
				if(dialogNum <= Constant.DIALOG.length){
					
					_dialogBubble.changeDialogTextField(Constant.DIALOG[dialogNum]);
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
	}
}