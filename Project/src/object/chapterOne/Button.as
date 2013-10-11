package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.Controller;
	
	import feathers.controls.Button;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Button extends Sprite
	{
		private var _submitBtn:feathers.controls.Button;
		private var _controller:Controller;
		
		public function Button(controller:Controller)
		{	
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);	
			this._controller  = controller;
		}
		
		private function onAddedToStage(e:Event):void{
			
			_submitBtn = new feathers.controls.Button();
			_submitBtn.defaultSkin = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.SUBMIT_NORMAL));
			_submitBtn.downSkin    = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.SUBMIT_CLICK));
			_submitBtn.hoverSkin   = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.SUBMIT_HOVER));
			
			this.addChild(_submitBtn);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_submitBtn.addEventListener(Event.TRIGGERED, onSubmitBtnTrigger);
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeChild(_submitBtn);
			_submitBtn = null;
		}
		
		private function onSubmitBtnTrigger(e:Event):void{

		}
	}
}