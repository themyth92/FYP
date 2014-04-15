package screen
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	
	import flashx.textLayout.elements.BreakElement;
	
	import gameData.GameData;
	
	import main.Game;
	
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ScoreBoard;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class PlayScreen extends Sprite
	{
		private static const STORY_PAGE 	: int = 1;
		private static const SAVE_PAGE  	: int = 2;
		private static const PLAY_PAGE  	: int = 3;
		
		private static const MENU_EVENT				: String = 'MenuEvent';
		private static const RESUME_GAME_EVENT		: String = 'OptionMenuResumeButtonTrigger';
		private static const RESET_PLAY_GAME_EVENT	: String = 'Reset play game';
		private static const QUIT_PREVIEW_GAME_EVENT	: String = 'Quit preview';	
		
		private static const RESET_CURRENT_LEVEL_EVENT: String = 'ResetLevelButtonTrigger';
		private static const GAME_OVER_EVENT			: String = 'GameOverEvent';
		
		private static const SUCCESS_EVENT			: String = 'SuccessEvent';
		
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
		
		private var _controller	 :MainController;
		private var _menuButton    :feathers.controls.Button;
		private var _menuScreen    :MenuScreen;
		private var _gameOver		:GameOverScreen;
		private var _successScreen : SucessScreen;
		
		public function PlayScreen()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
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
		
		private function onMenuBtnTrigger(event:Event):void
		{
			this._menuScreen				= new MenuScreen(Constant.PLAY_SCREEN);
			this.addChild(this._menuScreen);
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
			
			this._menuButton				= new feathers.controls.Button();
			this._menuButton.label			= 'Option';
			this._menuButton.width			= 50;
			this._menuButton.height			= 50;
			this._menuButton.x				= 2;
			this._menuButton.y				= 2;
			this.addChild(this._menuButton);
			
			//resume the game
			//happens when reset
			
			this._controller.changeState(Constant.PLAYING_STATE);
			
			this._menuButton.addEventListener(Event.TRIGGERED, onMenuBtnTrigger);
			
			this.addEventListener(MENU_EVENT, onMenuEvent);
			this.addEventListener(Event.TRIGGERED, onButtonClicked);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(GAME_OVER_EVENT, onGameOverEvent);
			this.addEventListener(SUCCESS_EVENT, onSuccessEvent);
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
			
			/* Place the image to correct position on screen */
			this._frameIMG.x 	= Constant.FRAME_STORY_POS.x;
			this._frameIMG.y 	= Constant.FRAME_STORY_POS.y;
			
			this._dialogueIMG.x = Constant.DIALOGUE_POS.x;
			this._dialogueIMG.y = Constant.DIALOGUE_POS.y;
			
			this._screen.x		= Constant.GRID_STORY_POS.x;
			this._screen.y		= Constant.GRID_STORY_POS.y;
			
			this._guiderIMG.x	= Constant.GUIDER_POS.x;
			this._guiderIMG.y	= Constant.GUIDER_POS.y;
			
			/* Add image to display */
			this.addChild(this._background);
			this.addChild(this._frameIMG);
			this.addChild(this._dialogueIMG);
			this.addChild(this._screen);
			this.addChild(this._guiderIMG);
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
			
			//there is some problem with cosole
			//therefore hide it
			this._console.alpha	= 0;
			this.addChild(this._dialogue);
			this.addChild(this._indexBoard);
			this.addChild(this._scoreBoard);
			this._controller.changeState(Constant.PLAYING_STATE);
		}
		
		private function onButtonClicked(event:Event):void
		{
			var buttonClicked	:Button = event.target as Button;
			
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(this._background);
			this.removeChild(this._frameIMG);
			this.removeChild(this._dialogueIMG);
			this.removeChild(this._screen);
			this.removeChild(this._guiderIMG);
			
			this.removeChild(this._dialogue);
			this.removeChild(this._console);
			this.removeChild(this._indexBoard);
			this.removeChild(this._scoreBoard);
			this.removeChild(this._menuButton);
			
			this._background		= null;
			this._frameIMG			= null;
			this._dialogueIMG		= null;
			this._screen			= null;
			this._guiderIMG			= null;
			this._dialogue			= null;
			this._console			= null;
			this._indexBoard		= null;
			this._scoreBoard		= null;
			this._menuButton		= null;
			this._menuScreen		= null;
			
			this.removeEventListener(Event.TRIGGERED, onButtonClicked);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(MENU_EVENT, onMenuEvent);
			this.removeEventListener(GAME_OVER_EVENT, onGameOverEvent);
			this.removeEventListener(SUCCESS_EVENT, onSuccessEvent);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(isWon()){
				if(Assets.pageID == PLAY_PAGE){
					this._controller.changeState(Constant.PAUSE_STATE);
					this.gameSuccess();
				}
				else{
					//return to the create game screen 
					Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.PLAY_SCREEN, to :Constant.CREATE_GAME_SCREEN}, true));
				}
				
			}
			if(isLost())
			{
				if(Assets.pageID == PLAY_PAGE){
					//return a gameover screen
					//pause gem first
					this._controller.changeState(Constant.PAUSE_STATE);
					this.gameOver();
				}
				else
				{
					//return to the create game screen 
					Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.PLAY_SCREEN, to :Constant.CREATE_GAME_SCREEN}, true));
				}
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
		
		private function onMenuEvent(event:Event):void
		{
			this._controller.changeState(Constant.PAUSE_STATE);
			switch(event.data.event){
				case RESUME_GAME_EVENT:
					this.removeChild(this._menuScreen);
					this._menuScreen = null;
					this._controller.changeState(Constant.PLAYING_STATE);
					break;
				case RESET_PLAY_GAME_EVENT:
					this.reset();
					break;
				case QUIT_PREVIEW_GAME_EVENT:
					Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.PLAY_SCREEN, to :Constant.CREATE_GAME_SCREEN}, true));
					break;
				default:
					break;
			}
		}
		
		private function reset():void
		{
			this.removeEventListener(Event.TRIGGERED, onButtonClicked);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(MENU_EVENT, onMenuEvent);
			this.removeEventListener(GAME_OVER_EVENT, onGameOverEvent);
			this.removeEventListener(SUCCESS_EVENT, onSuccessEvent);
			
			this.removeChild(this._background);
			this.removeChild(this._frameIMG);
			this.removeChild(this._dialogueIMG);
			this.removeChild(this._screen);
			this.removeChild(this._guiderIMG);
			
			this.removeChild(this._dialogue);
			this.removeChild(this._console);
			this.removeChild(this._indexBoard);
			this.removeChild(this._scoreBoard);
			this.removeChild(this._menuButton);
			this.removeChild(this._menuScreen);
			
			this._background		= null;
			this._frameIMG			= null;
			this._dialogueIMG		= null;
			this._screen			= null;
			this._guiderIMG			= null;
			this._dialogue			= null;
			this._console			= null;
			this._indexBoard		= null;
			this._scoreBoard		= null;
			this._menuButton		= null;
			this._menuScreen		= null;
			
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
		
		
		//do this for game over or game success
		//remove the game state permantly due to laggy game
		private function disposeState():void
		{
			this.removeChild(this._background);
			this.removeChild(this._frameIMG);
			this.removeChild(this._dialogueIMG);
			this.removeChild(this._screen);
			this.removeChild(this._guiderIMG);
			
			this.removeChild(this._dialogue);
			this.removeChild(this._console);
			this.removeChild(this._indexBoard);
			this.removeChild(this._scoreBoard);
			this.removeChild(this._menuButton);
			this.removeChild(this._menuScreen);
			
			this._background		= null;
			this._frameIMG			= null;
			this._dialogueIMG		= null;
			this._screen			= null;
			this._guiderIMG			= null;
			this._dialogue			= null;
			this._console			= null;
			this._indexBoard		= null;
			this._scoreBoard		= null;
			this._menuButton		= null;
			this._menuScreen		= null;
			
			this.removeEventListener(Event.TRIGGERED, onButtonClicked);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(MENU_EVENT, onMenuEvent);
			this.removeEventListener(SUCCESS_EVENT, onSuccessEvent);
		}
		
		private function gameOver():void
		{
			//pause game first
			//remove the whole game also
			this.disposeState();
			this._gameOver			= new GameOverScreen(Constant.PLAY_SCREEN);
			this.addChild(this._gameOver);
		}
		
		private function onGameOverEvent(event:Event):void
		{
			if(event.data.event == RESET_CURRENT_LEVEL_EVENT){
				this.reset();
				this.removeChild(this._gameOver);
				this._gameOver	= null;
			}		
		}
		
		private function gameSuccess():void
		{
			this.disposeState();
			this._successScreen			= new SucessScreen();
			this.addChild(this._successScreen);
		}
		
		private function onSuccessEvent(event:Event):void
		{
			if(event.data.event == RESET_CURRENT_LEVEL_EVENT){
				this.reset();
				this.removeChild(this._successScreen);
				this._successScreen	= null;
			}
		}
	}
}