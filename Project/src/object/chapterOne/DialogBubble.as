/*****************************************************
 * ================================================= *
 *                   DIALOG OBJECT                   *
 * ================================================= * 
 *****************************************************/

package object.chapterOne
{
	//import library
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	
	import controller.chapterOne.Controller;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class DialogBubble extends Sprite
	{
		/*----------------------------
		|	    Bubble variables     |
		-----------------------------*/
		private var _controller    	:Controller;
		private var _textField     	:TextField;
		private var _bubbles 		:Image;
		private var _arrow         	:starling.display.Button;
		private var _dialogCurPos  	:uint;
		
		/*----------------------------
		|	     Bubble state        |
		-----------------------------*/
		private var _state					 :String = ChapterOneConstant.INSTRUCTING_STATE;
		
		public function DialogBubble(controller:Controller)
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
			_textField.text = text;
			if(text == null)
				_controller.receiveFromDialogBubble(ChapterOneConstant.STATE_CHANGE, ChapterOneConstant.EDITTING_STATE,null);
		}
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS 		                  | *
		 * ====================================================================**/
		private function onAddedToStage(e:Event):void{
		
			_bubbles   		= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.BUBBLE_DIALOG));
			_textField 		= new TextField(ChapterOneConstant.DIALOG_TEXTFIELD_WIDTH , ChapterOneConstant.DIALOG_TEXTFIELD_HEIGHT, ChapterOneConstant.WELCOME_DIALOG ,ChapterOneConstant.GROBOLD_FONT);
			_arrow     		= new starling.display.Button(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.NEXT_ARROW));
			_dialogCurPos 	= 0;
			
			this.addChild(_bubbles);
			this.addChild(_textField);
			this.addChild(_arrow);
			
			_textField.x = ChapterOneConstant.DIALOG_POSX;
			_textField.y = ChapterOneConstant.DIALOG_POSY;
			
			_arrow.x     = ChapterOneConstant.DIALOG_ARROW_POSX;
			_arrow.y     = ChapterOneConstant.DIALOG_ARROW_POSY;
			
			_arrow.addEventListener(Event.TRIGGERED, onTriggerArrow);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			this.removeChild(_bubbles);
			this.removeChild(_textField);
			this.removeChild(_arrow);
			
			_arrow     = null;
			_bubbles   = null;
			_textField = null;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if(_state != ChapterOneConstant.INSTRUCTING_STATE)
			{
				this._bubbles.alpha		 = 0;
				this._textField.alpha 	 = 0;
				this._arrow.alpha 		 = 0;
			}
		}
		
		private function onTriggerArrow(e:Event):void{
			_controller.receiveFromDialogBubble(ChapterOneConstant.DIALOG_CHANGE, null, {event:ChapterOneConstant.TRIGGER, arg:_dialogCurPos, target:ChapterOneConstant.DIALOG_NEXT_ARROW});
		}
	}
}