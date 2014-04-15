package screen
{
	import assets.Assets;
	
	import feathers.controls.Button;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SucessScreen extends Sprite
	{
		private static const QUIT_GAME_EVENT			: String = 'QuitButtonTrigger';
		private static const RESET_CURRENT_LEVEL_EVENT: String = 'ResetLevelButtonTrigger';
		private static const SUCCESS_EVENT			: String = 'SuccessEvent';
		
		private static const STORY_PAGE 	: int = 1;
		private static const SAVE_PAGE  	: int = 2;
		private static const PLAY_PAGE  	: int = 3;
		
		private var _background 	: Image;
		private var _retryBtn   	: Button;
		private var _quitBtn	 	: Button;
		
		public function SucessScreen()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._background 			= new Image(Assets.getTexture('WinScreen'));
			this._background.x 			= 400 - this._background.width/2;
			this._background.y 			= 300 - this._background.height/2;
			this.addChild(this._background);
			
			switch(Assets.pageID){
				case STORY_PAGE:
					
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
					break;
				case PLAY_PAGE:
					
					this._retryBtn				= new Button();
					this._retryBtn.label		= 'Retry';
					this._retryBtn.width		= 200;
					this._retryBtn.x 			= 300;
					this._retryBtn.y			= 400;
					
					this._retryBtn.addEventListener(Event.TRIGGERED, 	onRetryBtnTrigger);
					this.addChild(this._retryBtn);
					
					break;
			}

			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE, 	onAddedToStage);
		}
		
		private function onRetryBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(SUCCESS_EVENT, true, {event : RESET_CURRENT_LEVEL_EVENT});	
		}
		
		private function onQuitBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(SUCCESS_EVENT, true, {event : QUIT_GAME_EVENT});
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(this._retryBtn);
			this.removeChild(this._quitBtn);
			this._retryBtn	= null;
			this._quitBtn	= null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE,	onRemoveFromStage);
		}
	}
}