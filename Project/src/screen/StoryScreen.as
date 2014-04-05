package screen
{	
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	
	import object.SoundObject;
	
	import screen.subStoryScreen.StoryStage1;
	import screen.subStoryScreen.StoryStage2;
	import screen.subStoryScreen.StoryStage3;
	import screen.subStoryScreen.StoryStage4;
	import screen.subStoryScreen.StoryStage5;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StoryScreen extends Sprite
	{	
		private static const RESET_CURRENT_LEVEL_EVENT: String = 'OptionMenuResetLevelButtonTrigger';
		private static const RESET_STORY_EVENT		: String = 'OptionMenuResetStoryButtonTrigger';
		private static const RESUME_GAME_EVENT		: String = 'OptionMenuResumeButtonTrigger';
		private static const QUIT_GAME_EVENT			: String = 'OptionMenuQuitButtonTrigger';
		private static const MENU_EVENT				: String = 'MenuEvent';
		
		private static const STORY_STAGE_1 			: uint = 1;
		private static const STORY_STAGE_2 			: uint = 2;
		private static const STORY_STAGE_3 			: uint = 3;
		private static const STORY_STAGE_4 			: uint = 4;
		private static const STORY_STAGE_5 			: uint = 5;
		
		private var _storyStage1  	: StoryStage1;
		private var _storyStage2  	: StoryStage2;
		private var _storyStage3  	: StoryStage3;
		private var _storyStage4  	: StoryStage4;
		private var _storyStage5  	: StoryStage5;
		private var _currentStage 	: Screen;
		private var _menuButton	: Button;
		private var _menuScreen	: MenuScreen;
		private var _soundObject	: SoundObject;
		
		public function StoryScreen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private	 function onAddedToStage(event:Event):void
		{
			//if first time load 
			if(this._currentStage == null){
				
				//this variable keep track of the current stage from user
				//firstly it will be loaded by server
				//the we use it to store the current stage of user in flash
				switch(Assets.userCurrentStoryStage){
					case STORY_STAGE_1 : 
						this._storyStage1	= new StoryStage1();
						this._currentStage	= this._storyStage1;
	
						break;
					case STORY_STAGE_2 : 
						this._storyStage2 	= new StoryStage2();
						this._currentStage	= this._storyStage2;
						
						break;
					case STORY_STAGE_3 : 
						this._storyStage3 	= new StoryStage3();
						this._currentStage	= this._storyStage3;
							
						break;
					case STORY_STAGE_4 : 
						this._storyStage4 	= new StoryStage4();
						this._currentStage	= this._storyStage4;
						
						break;
					case STORY_STAGE_5 : 
						this._storyStage5 	= new StoryStage5();
						this._currentStage	= this._storyStage5;
						
						break;
				}
			}
			
			this._menuButton				= new Button();
			this._menuButton.label			= 'Option';
			this._menuButton.width			= 50;
			this._menuButton.height			= 50;
			this._menuButton.x				= 30;
			this._menuButton.y				= 30;
			
			this.addChild(this._currentStage);
			this.addChild(this._menuButton);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, 		onRemoveFromStage);
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, 	onChangeScreen);
			this.addEventListener(MENU_EVENT, 						onMenuTrigger);
			this._menuButton.addEventListener(Event.TRIGGERED, 		onMenuScreenBtnTrigger);

		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this._menuButton.removeEventListener(MENU_EVENT, 			onMenuTrigger);	
			this.removeChild(this._menuButton);		
			this.removeChild(this._currentStage);
	
			this._currentStage				= null;
			this._menuButton				= null;
			this._menuScreen				= null;
			this._storyStage1				= null;
			this._storyStage2				= null;
			this._storyStage3				= null;
			this._storyStage4				= null;
			this._storyStage5				= null;
			
			this.removeEventListener(NavigationEvent.CHANGE_SCREEN, 	onChangeScreen);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, 			onRemoveFromStage);
		}
		
		//switch story screen on change state
		//remember to keep track of the stage in currentStage
		private function onChangeScreen(event:NavigationEvent):void
		{
			
			//due to current architecture
			//we need to remove the option button first and add it again
			this.removeChild(this._menuButton);
			this.removeChild(this._currentStage);
			
			switch(event.screenID.to){
				
				case Constant.STORY_SCREEN_2:
					
					//store the current stage first
					Assets.userCurrentStoryStage	= STORY_STAGE_2;
					
					this._storyStage2 				= new StoryStage2();
					this._currentStage				= this._storyStage2;
					this._storyStage1				= null;
					break;
				
				case Constant.STORY_SCREEN_3:
					
					//store the current stage first
					Assets.userCurrentStoryStage	= STORY_STAGE_3;
					
					this._storyStage3 				= new StoryStage3();
					this._currentStage				= this._storyStage3;
					this._storyStage2				= null;
					break;
				
				case Constant.STORY_SCREEN_4:
					
					//store the current stage first
					Assets.userCurrentStoryStage	= STORY_STAGE_4;
					
					this._storyStage4 				= new StoryStage4();
					this._currentStage				= this._storyStage4;
					this._storyStage3				= null;
					break;
				
				case Constant.STORY_SCREEN_5:
					
					//store the current stage first
					Assets.userCurrentStoryStage	= STORY_STAGE_5;
					
					this._storyStage5 				= new StoryStage5();
					this._currentStage				= this._storyStage5;
					this._storyStage4				= null;
					break;
				
				default:
					break;
			}
			
			this.addChild(this._currentStage);
			this.addChild(this._menuButton);
		}
		
		//show menu screen
		private function onMenuScreenBtnTrigger(event:Event):void
		{
			
			//create a new menu screen each time press 
			//show menu button
			this._menuScreen	=	new MenuScreen(Constant.STORY_SCREEN);
			
			//pause the game first
			this._currentStage.pauseGame();
			this.addChild(this._menuScreen);
		}
		
		private function onMenuTrigger(event:Event):void
		{
			switch(event.data.event){
				case RESET_CURRENT_LEVEL_EVENT:
					this._currentStage.resetCurrentActiveScreen();
					this.removeChild(this._menuScreen);
					this._menuScreen	= null;
					
					break;
				case RESUME_GAME_EVENT:
					this.removeChild(this._menuScreen);
					this._menuScreen	= null;
					
					break;
				case RESET_STORY_EVENT:
					
					//reset everything
					//reset the current stage to stage 1
					Assets.userCurrentStoryStage	= 1;
					//remove current stage
					this.removeChild(this._currentStage);
					this.removeChild(this._menuScreen);
					this.removeChild(this._menuButton);

					this._currentStage	= null;
					this._menuScreen	= null;
					
					//reset object
					this._storyStage1	= null;
					
					//add stage 1
					this._storyStage1	= new StoryStage1();
					this._currentStage	= this._storyStage1;
					
					this.addChild(this._currentStage);
					this.addChild(this._menuButton);
					
					break;
				case QUIT_GAME_EVENT:
					Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.STORY_SCREEN, to :Constant.NAVIGATION_SCREEN}, true));
					
					break;
				default:
					break;
			}
		}
	}
}