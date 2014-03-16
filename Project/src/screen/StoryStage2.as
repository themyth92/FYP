package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import events.NavigationEvent;
	
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ScoreBoard;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StoryStage2 extends Sprite
	{
		private var _dialogue		:Dialogue;
		private var _indexBoard		:IndexBoard;
		private var _scoreBoard		:ScoreBoard;
		private var _console		:Console;
		
		private var _background		:Image;
		private var _screen			:Image;
		private var _frameIMG		:Image;
		private var _dialogueIMG	:Image;
		private var _guiderIMG		:Image;
		private var _lifeIMG		:Image;
		private var _escButton		:Button;
		
		private var _controller		:Controller;
		
		public function StoryStage2()
		{
			super();
			
			_controller 	= new Controller ();
			_console		= new Console(_controller);
			_dialogue		= new Dialogue(_controller);
			_indexBoard		= new IndexBoard(_controller);
			_scoreBoard		= new ScoreBoard(_controller);
			
			_controller.assignObjectController(_console, _dialogue, null, _indexBoard, null, null, _scoreBoard);
			_controller.assignScreen(Constant.STORY_SCREEN_2);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			placeImageOnScreen();
			setupGameObject();
			
			this.addEventListener(Event.TRIGGERED, onButtonClicked);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
			this._escButton		= new Button(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.ESCB_IMG));
			
			/* Place the image to correct position on screen */
			this._frameIMG.x 		= Constant.FRAME_STORY_POS.x;
			this._frameIMG.y 		= Constant.FRAME_STORY_POS.y;
			
			this._dialogueIMG.x 	= Constant.DIALOGUE_POS.x;
			this._dialogueIMG.y 	= Constant.DIALOGUE_POS.y;
			
			this._screen.x			= Constant.GRID_STORY_POS.x;
			this._screen.y			= Constant.GRID_STORY_POS.y;
			
			this._guiderIMG.x		= Constant.GUIDER_POS.x;
			this._guiderIMG.y		= Constant.GUIDER_POS.y;
			
			this._escButton.x		= Constant.ESCB_POS.x;
			this._escButton.y		= Constant.ESCB_POS.y;
			
			/* Add image to display */
			this.addChild(_background);
			this.addChild(_frameIMG);
			this.addChild(_dialogueIMG);
			this.addChild(_screen);
			this.addChild(_guiderIMG);
			this.addChild(_escButton);
		}
		
		private function setupGameObject():void
		{
			_console.x 		= Constant.CONSOLE_PLAY_POS.x;
			_console.y 		= Constant.CONSOLE_PLAY_POS.y;
			
			_dialogue.x 	= Constant.DIALOGUE_POS.x + 75;
			_dialogue.y 	= Constant.DIALOGUE_POS.y + 20;
			
			_indexBoard.x 	= Constant.GRID_STORY_POS.x;
			_indexBoard.y 	= Constant.GRID_STORY_POS.y;
			
			_scoreBoard.x 	= 160;
			
			this.addChild(_dialogue);
			this.addChild(_indexBoard);
			this.addChild(_scoreBoard);
		}
		
		private function onButtonClicked(event:Event):void
		{
			var buttonClicked	:Button = event.target as Button;
			if(buttonClicked == _escButton)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.MAIN_SCREEN}, true));
			}
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(_background);
			this.removeChild(_frameIMG);
			this.removeChild(_dialogueIMG);
			this.removeChild(_screen);
			this.removeChild(_guiderIMG);
			this.removeChild(_escButton);
			
			this.removeChild(_dialogue);
			this.removeChild(_console);
			this.removeChild(_indexBoard);
			this.removeChild(_scoreBoard);
			this._console.dispose();
			this._dialogue.dispose();
			this._indexBoard.dispose();
			this._scoreBoard.dispose();
			this.removeEventListener(Event.ADDED_TO_STAGE, onRemoveFromStage);
		}
		
		private function onEnterFrame(event:Event):void
		{	
			if(displayConsoleState())
				this.addChild(_console);
			if(isWon())
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.STORY_SCREEN_3}, true));
		}
		
		private function isWon():Boolean
		{
			return _controller.isWon;
		}
		
		private function displayConsoleState():Boolean
		{
			return _controller.stage2Info()[1];
		}
	}
}