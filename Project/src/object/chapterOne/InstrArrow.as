package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class InstrArrow extends Sprite
	{
		private var _arrowLeft : Image;
		private var _arrowRight: Image;
		private var _leftPosX  : int;
		private var _leftPosY  : int;
		private var _rightPosX : int;
		private var _rightPosY : int;
		
		public function InstrArrow()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddedToStage(e:Event):void{
			
			_arrowLeft  = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.INSTRUC_ARROW_LEFT));
			_arrowRight = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.INSTRUC_ARROW_RIGHT));
			
			_leftPosX   = 0;
			_leftPosY   = 0;
			_rightPosX  = 0;
			_rightPosY  = 0;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);	
		}
	}
}