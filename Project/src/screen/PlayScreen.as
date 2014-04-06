package screen
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import events.NavigationEvent;
	
	import gameData.GameData;
	
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ScoreBoard;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class PlayScreen extends Sprite
	{
		private var _dialogue		:Dialogue;
		private var _indexBoard		:IndexBoard;
		private var _scoreBoard		:ScoreBoard;
		private var _console		:Console;
		
		private var _gameTitle		:TextField;
		private var _background		:Image;
		private var _screen			:Image;
		private var _frameIMG		:Image;
		private var _dialogueIMG	:Image;
		private var _guiderIMG		:Image;
		private var _escButton		:Button;
		
		private var _controller		:MainController;
		
		public function PlayScreen()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			//Setup object and connect them to main controller
			this._controller 	= new MainController ();
			
			this._console		= new Console(this._controller);
			this._dialogue		= new Dialogue(this._controller);
			this._indexBoard	= new IndexBoard(this._controller);
			this._scoreBoard	= new ScoreBoard(this._controller);
			
			this._controller.assignObjectController(this._console, this._dialogue, this._indexBoard, this._scoreBoard);
			this._controller.assignScreen(Constant.PLAY_SCREEN);
			
			//Display Game Title
			this.displayGameTitle();
		}
		
		private function displayGameTitle():void
		{
			//add game title to screen
			//display game title for 1-2 seconds
			//remove the title
			this._gameTitle = new TextField(600, 400, PreviewGameInfo._gameTitle,"Verdana",48,0xffffff, true);
			this._gameTitle.x = 100;
			this._gameTitle.y = 100;
			this._gameTitle.alpha = 0;
			this.addChild(this._gameTitle);
			var showTitle	:Tween = new Tween (this._gameTitle, 2.0);
			showTitle.fadeTo(1);
			showTitle.reverse = true;
			showTitle.repeatCount = 2;
			showTitle.repeatDelay = 1.0;
			showTitle.onComplete = continueSetup;
			Starling.juggler.add(showTitle);
		}
		
		private function continueSetup():void
		{
			this.removeChild(this._gameTitle);
			
			//Setup image on the screen
			this.placeImageOnScreen();
			this.setupGameObject();
			
			this.addEventListener(Event.TRIGGERED, onButtonClicked);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function placeImageOnScreen():void
		{
			/* Load the image into variables */
			this._background	= new Image(Assets.getAtlas(Constant.BACKGROUND_SPRITE).getTexture(Constant.BG_STAGE2));
			if(PreviewGameInfo._gameScreen.isUserDef)
			{
				this._screen	= new Image(Assets.getUserScreenTexture()[PreviewGameInfo._gameScreen.textureIndex].texture);
				this._screen.width = 440;
				this._screen.height = 360;
			}
			else
				this._screen	= new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture("Stage"+PreviewGameInfo._gameScreen.textureIndex+"Screen"));
			
			this._frameIMG 		= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.FRAME_IMG));
			this._dialogueIMG 	= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.DIALOGUE_IMG));
			this._guiderIMG		= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.GUIDER_IMG));
			this._escButton		= new Button(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.ESCB_IMG));
			
			/* Place the image to correct position on screen */
			this._frameIMG.x 	= Constant.FRAME_STORY_POS.x;
			this._frameIMG.y 	= Constant.FRAME_STORY_POS.y;
			
			this._dialogueIMG.x = Constant.DIALOGUE_POS.x;
			this._dialogueIMG.y = Constant.DIALOGUE_POS.y;
			
			this._screen.x		= Constant.GRID_STORY_POS.x;
			this._screen.y		= Constant.GRID_STORY_POS.y;
			
			this._guiderIMG.x	= Constant.GUIDER_POS.x;
			this._guiderIMG.y	= Constant.GUIDER_POS.y;
			
			this._escButton.x	= Constant.ESCB_POS.x;
			this._escButton.y	= Constant.ESCB_POS.y;
			
			/* Add image to display */
			this.addChild(this._background);
			this.addChild(this._frameIMG);
			this.addChild(this._dialogueIMG);
			this.addChild(this._screen);
			this.addChild(this._guiderIMG);
			this.addChild(this._escButton);
		}
		
		private function setupGameObject():void
		{
			//setup Game Object on stage
			this._console.x 	= Constant.CONSOLE_PLAY_POS.x;
			this._console.y 	= Constant.CONSOLE_PLAY_POS.y;
			
			this._dialogue.x 	= Constant.DIALOGUE_POS.x + 75;
			this._dialogue.y 	= Constant.DIALOGUE_POS.y + 20;
			
			this._indexBoard.x 	= Constant.GRID_STORY_POS.x;
			this._indexBoard.y 	= Constant.GRID_STORY_POS.y;
			
			this._scoreBoard.x 	= 160;
			
			this.addChild(this._console);
			this.addChild(this._dialogue);
			this.addChild(this._indexBoard);
			this.addChild(this._scoreBoard);
			this._controller.changeState(Constant.PLAYING_STATE);
		}
		
		private function onButtonClicked(event:Event):void
		{
			var buttonClicked	:Button = event.target as Button;
			if(buttonClicked == _escButton)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.NAVIGATION_SCREEN}, true));
			}
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(this._background);
			this.removeChild(this._frameIMG);
			this.removeChild(this._dialogueIMG);
			this.removeChild(this._screen);
			this.removeChild(this._guiderIMG);
			this.removeChild(this._escButton);
			
			this.removeChild(this._dialogue);
			this.removeChild(this._console);
			this.removeChild(this._indexBoard);
			this.removeChild(this._scoreBoard);
			
			this._background		= null;
			this._frameIMG			= null;
			this._dialogueIMG		= null;
			this._screen			= null;
			this._guiderIMG			= null;
			this._escButton			= null;
			this._dialogue			= null;
			this._console			= null;
			this._indexBoard		= null;
			this._scoreBoard		= null;
			
			this.removeEventListener(Event.TRIGGERED, onButtonClicked);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(isWon()){
				//If won
				//Display "Congratulation"
				//Replay Or Quit
			}
			if(isLost())
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.GAME_OVER_SCREEN}, true));
		}
		
		private function isWon():Boolean
		{
			return _controller.isWon;
		}
		
		private function isLost():Boolean
		{
			return _controller.isLost;
		}
	}
}