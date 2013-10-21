package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.Controller;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class DialogBubble extends Sprite
	{
		
		private var _controller    : Controller;
		private var _textField     :TextField;
		private var _bubbles 		:Image;
		private var _arrow         :starling.display.Button;
		private var _dialogCurPos     :uint;
		
		public function DialogBubble(controller:Controller)
		{	
			this._controller = controller;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}

		public function set dialogCurPos(value:uint):void
		{
			_dialogCurPos = value;
		}

		public function changeDialogTextField(text:String):void{
			
		}
		
		private function onAddedToStage(e:Event):void{
		
			_bubbles   = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.BUBBLE_DIALOG));
			_textField = new TextField(Constant.DIALOG_TEXTFIELD_WIDTH , Constant.DIALOG_TEXTFIELD_HEIGHT, Constant.WELCOME_DIALOG ,Constant.GROBOLD_FONT);
			_arrow     = new starling.display.Button(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.NEXT_ARROW));
			_dialogCurPos = 0;
			
			this.addChild(_bubbles);
			this.addChild(_textField);
			this.addChild(_arrow);
			
			_textField.x = Constant.DIALOG_POSX;
			_textField.y = Constant.DIALOG_POSY;
			
			_arrow.x     = Constant.DIALOG_ARROW_POSX;
			_arrow.y     = Constant.DIALOG_ARROW_POSY;
			
			_arrow.addEventListener(Event.TRIGGERED, onTriggerArrow);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			this.removeChild(_bubbles);
			this.removeChild(_textField);
			this.removeChild(_arrow);
			
			_arrow = null;
			_bubbles = null;
			_textField = null;
		}
		
		private function onTriggerArrow(e:Event):void{
			_controller.notifyObserver({event:Constant.TRIGGER, arg:_dialogCurPos, target:Constant.DIALOG_NEXT_ARROW});
		}
	}
}