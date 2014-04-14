package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameOverScreen extends Sprite
	{		
		private static const QUIT_GAME_EVENT			: String = 'QuitButtonTrigger';
		private static const RESET_CURRENT_LEVEL_EVENT: String = 'ResetLevelButtonTrigger';
		private static const GAME_OVER_EVENT			: String = 'GameOverEvent';
		
		private var _background 	:Image;
		private var _fromScreen	:String;
		private var _quitBtn		:Button;
		private var _retryBtn		:Button;
		
		public function GameOverScreen(fromScreen:String)
		{
			super();
			this._fromScreen	=	 fromScreen;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._background 		= new Image(Assets.getTexture("GameOverScreen"));
			this.addChild(this._background);
			
			//check the screen which call the game over screen
			switch(this._fromScreen){
				case Constant.STORY_SCREEN:
					
					this._quitBtn				= new Button();
					this._quitBtn.label			= 'Quit';
					this._quitBtn.x 			= 100;
					this._quitBtn.y				= 400;
					this._quitBtn.width			= 200;
					
					this._retryBtn				= new Button();
					this._retryBtn.label		= 'Retry';
					this._retryBtn.x 			= 500;
					this._retryBtn.y			= 400;
					this._retryBtn.width		= 200;
					
					this.addChild(this._quitBtn);
					this.addChild(this._retryBtn);
					
					this._quitBtn.addEventListener(Event.TRIGGERED, 	onQuitBtnTrigger);
					this._retryBtn.addEventListener(Event.TRIGGERED, 	onRetryBtnTrigger);
					
					break;
				case Constant.PLAY_SCREEN:
					
					this._retryBtn				= new Button();
					this._retryBtn.label		= 'Retry';
					this._retryBtn.width		= 200;
					this._retryBtn.x 			= 300;
					this._retryBtn.y			= 400;
					
					this._retryBtn.addEventListener(Event.TRIGGERED, 	onRetryBtnTrigger);
					this.addChild(this._retryBtn);
					break;
				default:
					break;
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);	
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(this._background);
			this.removeChild(this._retryBtn);
			this.removeChild(this._quitBtn);
			
			this._background 	= null;
			this._retryBtn		= null;
			this._quitBtn		= null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);			
		}
		
		private function onQuitBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(GAME_OVER_EVENT, true, {event : QUIT_GAME_EVENT});
		}
		
		private function onRetryBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(GAME_OVER_EVENT, true, {event : RESET_CURRENT_LEVEL_EVENT});	
		}
	
	}
}