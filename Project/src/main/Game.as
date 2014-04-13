package main
{
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import manager.ServerClientManager;
	
	import screen.CreateGameScreen;
	import screen.GameOverScreen;
	import screen.LoadingScreen;
	import screen.NavigationScreen;
	import screen.PlayScreen;
	import screen.StoryScreen;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class Game extends Sprite
	{	
		//parent screen
		private var _navigationScreen		:NavigationScreen;
		private var _createGameScreen	    :CreateGameScreen;	
		private var _loadingScreen			:LoadingScreen;
		private var _playScreen			:PlayScreen;
		private var _storyScreen			:StoryScreen;
		private var _gameOver				:GameOverScreen;
		private var _serverClientManager  	:ServerClientManager;
		
		public function Game()
		{	
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void{
			
			//loading all the textures and questions for first time bootstrapping the game
			//depend on the page that server reply, the texture and question load in the
			//game will be different
			//The pages include 3 page : 
			//1. story page
			//2. repair the game page
			//3. play the game page
			
			//use starling stage to pass the navigation event instead
			//for some reason can not use the current object to listen to the event

			stage.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);

			
			stage.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			this._loadingScreen 			= new LoadingScreen();
			this.addChild(this._loadingScreen);
			
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			var fromScreen:String = event.screenID.from;
			
			if(event.screenID.from && event.screenID.to){
				
				switch(event.screenID.to){
					
					case Constant.NAVIGATION_SCREEN:
						
						this.changeScreenToNavigationScreen(fromScreen);
						break;
					
					case Constant.STORY_SCREEN:
						
						this.changeScreenToStoryScreen();
						break;
					
					case Constant.CREATE_GAME_SCREEN:
						
						this.changeScreenToCreateGameScreen(fromScreen);
						break;
					
					case Constant.PLAY_SCREEN:
						
						this.changeScreenToPlayGameScreen(fromScreen);
						break;
					
					default:
						break;
				}	
			}
		}
		
		private function changeScreenToNavigationScreen(fromScreen:String):void
		{
			switch(fromScreen){
				
				case Constant.LOADING_SCREEN:
					
					this._navigationScreen	= new NavigationScreen();
					
					this.addChild(this._navigationScreen);
					//must remove the loading screen and set it to null 
					this.removeChild(this._loadingScreen);
					this._loadingScreen		= null;
					
					break;
				case Constant.CREATE_GAME_SCREEN:
					
					this._navigationScreen	= new NavigationScreen();
					this.addChild(this._navigationScreen);
					
					//remove rubbish
					this.removeChild(this._createGameScreen);
					this._createGameScreen.disposeScreen();
					this._createGameScreen 	= null;
					break;
				case Constant.STORY_SCREEN:
					
					this._navigationScreen	= new NavigationScreen();
					this.addChild(this._navigationScreen);
					
					this.removeChild(this._storyScreen);
					this._storyScreen		= null;
					break;
				default:
					break;
			}
		}
		
		//no need from screen here because we sure that it must from 
		//navigation screen
		private function changeScreenToStoryScreen():void
		{
			this._storyScreen			= new StoryScreen();
			this.addChild(this._storyScreen);
			
			//remove rubbish navigation here
			this.removeChild(this._navigationScreen);
			this._navigationScreen		=	null;
		}
		
		private function changeScreenToPlayGameScreen(fromScreen:String):void
		{
			switch(fromScreen){
				case Constant.LOADING_SCREEN:
					
					this._playScreen		= 	new PlayScreen();
					this.addChild(this._playScreen);
					
					this.removeChild(this._loadingScreen);
					this._loadingScreen		= null;
					
					break;
				case Constant.CREATE_GAME_SCREEN:
					
					//must create something to chage the state of the create game screen
					//so that it does not listen to the event from stage
					//MUST NOT DELETE THE CREATE GAME OBJECT HERE
					//so that we can retrieve it later
					this.removeChild(this._createGameScreen);
					this._playScreen		= 	new PlayScreen();
					this.addChild(this._playScreen);
					
					break;
			}
			
		}
		
		//3 cases : 
		//from navigation screen
		//from loading screen
		//from preview inside the create game screen
		private function changeScreenToCreateGameScreen(fromScreen: String):void
		{
			switch(fromScreen){
				
				case Constant.NAVIGATION_SCREEN:
					
					this._createGameScreen	= new CreateGameScreen();
					this.addChild(this._createGameScreen);
					
					this.removeChild(this._navigationScreen);
					this._navigationScreen = null;
					break;
				
				case Constant.LOADING_SCREEN:
					
					this._createGameScreen	= new CreateGameScreen();
					this.addChild(this._createGameScreen);
					
					this.removeChild(this._loadingScreen);
					this._loadingScreen 	= null;
					break;
				
				case Constant.PLAY_SCREEN:
					
					//must not remove the create game screen object here
					//because later we will resume it when user want to come back
					//to continue create their game
					this.addChild(this._createGameScreen);
					//must create something to retrieve all 
					//the event in create game screen	
					this.removeChild(this._playScreen);
					this._playScreen 		= null;
				default:
					break;
			}
		}
	}
}