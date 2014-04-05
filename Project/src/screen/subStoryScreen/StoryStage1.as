package screen.subStoryScreen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	import feathers.themes.MetalWorksMobileTheme;
	
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ScoreBoard;
	
	import screen.MenuScreen;
	import screen.Screen;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class StoryStage1 extends Screen
	{
		private var _dialogue		:Dialogue;
		private var _indexBoard	:IndexBoard;
		private var _scoreBoard	:ScoreBoard;
		
		private var _background	:Image;
		private var _screen		:Image;
		private var _frameIMG		:Image;
		private var _dialogueIMG	:Image;
		private var _guiderIMG		:Image;
		private var _lifeIMG		:Image;
		private var _gotPopUp		:Boolean;
		private var _controller	:MainController;
		
		public function StoryStage1()
		{
			super();		
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override public function resetCurrentActiveScreen():void
		{
			this.removeChild(_background);
			this.removeChild(_frameIMG);
			this.removeChild(_dialogueIMG);
			this.removeChild(_screen);
			this.removeChild(_guiderIMG);
			this.removeChild(_dialogue);
			this.removeChild(_indexBoard);
			this.removeChild(_scoreBoard);
			
			this._background  	= null;
			this._frameIMG    	= null;
			this._dialogueIMG 	= null;
			this._screen      	= null;
			this._guiderIMG   	= null;
			this._dialogue    	= null;
			this._indexBoard  	= null;
			this._scoreBoard  	= null;
			this._controller  	= null;
			
			this._controller 		= new MainController ();
			this._dialogue			= new Dialogue(_controller);
			this._indexBoard		= new IndexBoard(_controller);
			this._scoreBoard		= new ScoreBoard(_controller);
			
			this._controller.assignObjectController(null, _dialogue, _indexBoard, this._scoreBoard);
			this._controller.assignScreen(Constant.STORY_SCREEN_1);
			
			placeImageOnScreen();
			setupGameObject();
		}
		
		override public function pauseGame():void
		{
			this._controller.changeState(Constant.PAUSE_STATE);	
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._controller 		= new MainController ();
			this._dialogue			= new Dialogue(_controller);
			this._indexBoard		= new IndexBoard(_controller);
			this._scoreBoard		= new ScoreBoard(_controller);	
				
			this._controller.assignObjectController(null, _dialogue, _indexBoard, this._scoreBoard);
			this._controller.assignScreen(Constant.STORY_SCREEN_1);
			
			placeImageOnScreen();
			setupGameObject();
			
			this.addEventListener(Event.ENTER_FRAME, 			onEnterFrame);
			this.addEventListener(Event.REMOVED_FROM_STAGE, 	onRemoveFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE, 		onAddedToStage);
		}

		private function placeImageOnScreen():void
		{
			new MetalWorksMobileTheme();
			
			/* Load the image into variables */
			this._background	= new Image(Assets.getAtlas(Constant.BACKGROUND_SPRITE).getTexture(Constant.BG_STAGE1));
			this._screen		= new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture(Constant.STAGE1_SCREEN));
			this._frameIMG 		= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.FRAME_IMG));
			this._dialogueIMG 	= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.DIALOGUE_IMG));
			this._guiderIMG		= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.GUIDER_IMG));
			this._lifeIMG		= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.LIFE_IMG));
			
			/* Place the image to correct position on screen */
			this._frameIMG.x 		= Constant.FRAME_STORY_POS.x;
			this._frameIMG.y 		= Constant.FRAME_STORY_POS.y;
			
			this._dialogueIMG.x 	= Constant.DIALOGUE_POS.x;
			this._dialogueIMG.y 	= Constant.DIALOGUE_POS.y;
			
			this._screen.x			= Constant.GRID_STORY_POS.x;
			this._screen.y			= Constant.GRID_STORY_POS.y;
			
			this._guiderIMG.x		= Constant.GUIDER_POS.x;
			this._guiderIMG.y		= Constant.GUIDER_POS.y;
			
			/* Add image to display */
			this.addChild(_background);
			this.addChild(_frameIMG);
			this.addChild(_dialogueIMG);
			this.addChild(_screen);
			this.addChild(_guiderIMG);
		}
		
		private function setupGameObject():void
		{
			this._dialogue.x 	= Constant.DIALOGUE_POS.x + 75;
			this._dialogue.y 	= Constant.DIALOGUE_POS.y + 20;
			
			this._indexBoard.x 	= Constant.GRID_STORY_POS.x;
			this._indexBoard.y 	= Constant.GRID_STORY_POS.y;
			
			this._scoreBoard.x 	= 160;
			
			this.addChild(_dialogue);
			this.addChild(_indexBoard);
			this.addChild(_scoreBoard);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(_background);
			this.removeChild(_frameIMG);
			this.removeChild(_dialogueIMG);
			this.removeChild(_screen);
			this.removeChild(_guiderIMG);
			this.removeChild(_dialogue);
			this.removeChild(_indexBoard);
			this.removeChild(_scoreBoard);
			
			this._background  	= null;
			this._frameIMG    	= null;
			this._dialogueIMG 	= null;
			this._screen      	= null;
			this._guiderIMG   	= null;
			this._dialogue    	= null;
			this._indexBoard  	= null;
			this._scoreBoard  	= null;
			this._controller  	= null;

			this.removeEventListener(Event.ENTER_FRAME, 		onEnterFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, 	onRemoveFromStage);
		}
		
		private function onEnterFrame(event:Event):void
		{
			var isWon :Boolean;
			var isLost:Boolean;
			isWon 	= 	this._controller.isWon;
			isLost 	= 	this._controller.isLost;
			if(isWon){
				
				//dispatch event to change screen
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {to: Constant.STORY_SCREEN_2}, true));
			}
			if(isLost)
			{	
				//dispatch event to change screen
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.GAME_OVER_SCREEN}, true));
			}
		}
	}
}