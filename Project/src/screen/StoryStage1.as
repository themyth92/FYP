package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	import feathers.themes.MetalWorksMobileTheme;
	
	import gameData.GameData;
	
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ScoreBoard;
	
	import serverCom.ServerClientCom;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class StoryStage1 extends Sprite
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
		private var _escButton		:Button;
		private var _gotPopUp		:Boolean;
		private var _com           :ServerClientCom;
		private var _optionBtn     :Button;
		private var _menuScreen	:MenuScreen;
				
		private var _controller	:MainController;
		
		public function StoryStage1()
		{
			super();		
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._controller 		= new MainController ();
			this._dialogue			= new Dialogue(_controller);
			this._indexBoard		= new IndexBoard(_controller);
			this._scoreBoard		= new ScoreBoard(_controller);
			this._com            	= new ServerClientCom();	
			this._optionBtn 		= new Button();		
			this._menuScreen		= new MenuScreen();
				
			this._controller.assignObjectController(null, _dialogue, _indexBoard, this._scoreBoard);
			this._controller.assignScreen(Constant.STORY_SCREEN_1);
			
			placeImageOnScreen();
			setupGameObject();
			
			this.addEventListener(Event.TRIGGERED, onButtonClicked);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this._optionBtn.addEventListener(Event.TRIGGERED, onOptionBtnTrigger);
			
			//add all event listener from the menu screen here
			this.addEventListener('OptionMenuResumeButtonTrigger'		, onMenuCloseBtnTrigger);
			this.addEventListener('OptionMenuQuitButtonTrigger'			, onMenuQuitBtnTrigger);
			this.addEventListener('OptionMenuResetStateButtonTrigger'	, onMenuResetStateBtnTrigger);
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
	
			this._optionBtn.label	= 'Options';
			this._optionBtn.useHandCursor	= true;
			
			/* Add image to display */
			this.addChild(_background);
			this.addChild(_frameIMG);
			this.addChild(_dialogueIMG);
			this.addChild(_screen);
			this.addChild(_guiderIMG);
			this.addChild(this._optionBtn);
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
			this.removeChild(_escButton);
			this.removeChild(_dialogue);
			this.removeChild(_indexBoard);
			this.removeChild(_scoreBoard);
			this.removeChild(this._optionBtn);
			this.removeChild(this._menuScreen);
			
			this._background  	= null;
			this._frameIMG    	= null;
			this._dialogueIMG 	= null;
			this._screen      	= null;
			this._guiderIMG   	= null;
			this._escButton   	= null;
			this._dialogue    	= null;
			this._indexBoard  	= null;
			this._scoreBoard  	= null;
			this._controller  	= null;
			this._com         	= null;
			this._optionBtn		= null;
			this._menuScreen 	= null;

			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onButtonClicked(event:Event):void
		{
			var buttonClicked	:Button = event.target as Button;
			if(buttonClicked == _escButton)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.MAIN_SCREEN}, true));
				this.removeEventListener(Event.TRIGGERED, onButtonClicked);
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			var isWon :Boolean;
			var isLost:Boolean;
			isWon 	= 	this._controller.isWon;
			isLost 	= 	this._controller.isLost;
			if(isWon){
				
				//save the state to server with the state number 1
				//which means user has passed the first state
				_com.saveUserIngameState(1);
				
				//save the state of the user in game
				GameData.setGameState(2);
				
				//dispatch event to change screen
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.STORY_SCREEN_2}, true));
			}
			if(isLost)
			{	
				//dispatch event to change screen
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.GAME_OVER_SCREEN}, true));
			}
		}
		
		private function onOptionBtnTrigger(event:Event):void
		{
			
			//must pause the game first
			this.addChild(this._menuScreen);
		}
		
		private function onMenuCloseBtnTrigger(event:Event):void
		{
			//remove the menu screen
			this.removeChild(this._menuScreen);
		}
		
		private function onMenuQuitBtnTrigger(event:Event):void
		{
			//dispatch event to change screen
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.MAIN_SCREEN}, true));
		}
		
		private function onMenuResetStateBtnTrigger(event:Event):void
		{	
			//reset the state here
			this.removeChild(this._dialogue, 	true);
			this.removeChild(this._indexBoard, true);
			this.removeChild(this._scoreBoard, true);
			
			this._dialogue			= new Dialogue(this._controller);
			this._indexBoard		= new IndexBoard(this._controller);
			this._scoreBoard		= new ScoreBoard(this._controller);
			
			this.setupGameObject();

			//reassign all the object to the repsective object in controller
			this._controller.assignObjectController(null, this._dialogue, this._indexBoard, this._scoreBoard);
		}
	}
}