package main
{
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import screen.ChapterOneScreen;
	import screen.CreateScreen;
	import screen.LoadingScreen;
	import screen.MainScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _loadingScreen    :LoadingScreen;
		private var _chapterOneScreen :screen.ChapterOneScreen;
		private var _mainScreen		  :MainScreen;
		private var _createScreen	  :CreateScreen;
		
		public function Game()
		{
			super();
			_loadingScreen   	= new LoadingScreen();
			_chapterOneScreen 	= new screen.ChapterOneScreen();
			_mainScreen  		= new MainScreen();
			_createScreen		= new CreateScreen();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			this.addChild(_loadingScreen);
		}
		
		private function onChangeScreen(e:NavigationEvent):void{
			
			if(e.screenID.id != undefined){
				switch(e.screenID.id){
					case Constant.LOADING_SCREEN:
						break;
					
					case Constant.FIRST_CHAPTER_SCREEN:
						this.removeChild(_mainScreen);
						this.addChild(_chapterOneScreen);
						break;
					
					case Constant.MAIN_SCREEN:
						this.removeChild(_loadingScreen);
						this.addChild(_mainScreen);
						break;
					
					case Constant.CREATE_GAME_SCREEN:
						this.removeChild(_mainScreen);
						this.addChild(_createScreen);
						break;
					default:
						break;
				}
			}
		}
	}
}