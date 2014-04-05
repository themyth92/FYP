package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameOverScreen extends Sprite
	{		
		private var _background 	:Image;
		private var _gameOverText	:Image;
		
		public function GameOverScreen()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._background = new Image(Assets.getTexture("GameOverScreen"));
			this._gameOverText = new Image(Assets.getTexture("GameOverText"));
			this._gameOverText.alpha = 0;
			this.addChild(_background);
			this.addChild(_gameOverText);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(this._gameOverText.alpha != 1)
				this._gameOverText.alpha += 0.005;
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				//this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.MAIN_SCREEN, needSaveState : true}, true));
			}
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this._background = null;
			this._gameOverText = null;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);			
		}
	
	}
}