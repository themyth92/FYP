package screen.subStoryScreen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import events.NavigationEvent;
	
	import gameData.GameData;
	
	import manager.ServerClientManager;
	
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ScoreBoard;
	
	import screen.Screen;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StoryStage2 extends Screen
	{
		private var _dialogue		:Dialogue;
		private var _indexBoard	:IndexBoard;
		private var _scoreBoard	:ScoreBoard;
		private var _console		:Console;
		private var _background	:Image;
		private var _screen		:Image;
		private var _frameIMG		:Image;
		private var _dialogueIMG	:Image;
		private var _guiderIMG		:Image;
		private var _lifeIMG		:Image;	
		private var _controller	:MainController;
		
		public function StoryStage2()
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
			this.removeChild(_console);
			this.removeChild(_indexBoard);
			this.removeChild(_scoreBoard);
			
			this._background  			= null;
			this._indexBoard  			= null;
			this._scoreBoard  			= null;
			this._console     			= null;
			this._frameIMG    			= null;
			this._dialogueIMG 			= null;
			this._screen      			= null;
			this._guiderIMG   			= null;
			this._controller  			= null;
			
			this._controller 		= new MainController ();
			this._console			= new Console(_controller);
			this._dialogue			= new Dialogue(_controller);
			this._indexBoard		= new IndexBoard(_controller);
			this._scoreBoard		= new ScoreBoard(_controller);
			
			this._controller.assignObjectController(this._console, this._dialogue, this._indexBoard, this._scoreBoard);
			this._controller.assignScreen(Constant.STORY_SCREEN_2);
			
			placeImageOnScreen();
			setupGameObject();
		}
		
		override public function pauseGame():void
		{
			this._controller.changeState(Constant.PAUSE_STATE);	
		}
		
		override public function unpauseGame():void
		{
			this._controller.changeState(Constant.PLAYING_STATE);
		}
		
		private function onAddedToStage(event:Event):void
		{
			
			this._controller 		= new MainController ();
			this._console			= new Console(_controller);
			this._dialogue			= new Dialogue(_controller);
			this._indexBoard		= new IndexBoard(_controller);
			this._scoreBoard		= new ScoreBoard(_controller);

			this._controller.assignObjectController(_console, _dialogue,  _indexBoard, this._scoreBoard);
			this._controller.assignScreen(Constant.STORY_SCREEN_2);
			
			placeImageOnScreen();
			setupGameObject();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, 	onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME, 			onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, 		onAddedToStage);
		}
		
		private function placeImageOnScreen():void
		{
			/* Load the image into variables */
			this._background	= new Image(Assets.getAtlas(Constant.BACKGROUND_SPRITE).getTexture(Constant.BG_STAGE2));
			this._screen		= new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture(Constant.STAGE2_SCREEN));
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
			this._console.x 		= Constant.CONSOLE_PLAY_POS.x;
			this._console.y 		= Constant.CONSOLE_PLAY_POS.y;
			
			this._dialogue.x 	= Constant.DIALOGUE_POS.x + 75;
			this._dialogue.y 	= Constant.DIALOGUE_POS.y + 20;
			
			this._indexBoard.x 	= Constant.GRID_STORY_POS.x;
			this._indexBoard.y 	= Constant.GRID_STORY_POS.y;
			
			this._scoreBoard.x 	= 160;
			
			this.addChild(_console);
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
			this.removeChild(_console);
			this.removeChild(_indexBoard);
			this.removeChild(_scoreBoard);
			
			this._background  = null;
			this._indexBoard  = null;
			this._scoreBoard  = null;
			this._console     = null;
			this._frameIMG    = null;
			this._dialogueIMG = null;
			this._screen      = null;
			this._guiderIMG   = null;
			this._controller  = null;
			
			this.removeEventListener(Event.ENTER_FRAME, 			onEnterFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,		onRemoveFromStage);
		}
		
		private function onEnterFrame(event:Event):void
		{	
			if(isWon()){
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {to: Constant.STORY_SCREEN_3}, true));
			}
			else if(isLost())
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {to: Constant.GAME_OVER_SCREEN}, true));
			}
		}
		private function isWon():Boolean
		{
			return this._controller.isWon;
		}
		
		private function isLost():Boolean
		{
			return this._controller.isLost;
		}
	}
}