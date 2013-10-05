package main
{
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import screen.chapterOne.ChapterScreen;
	import screen.loading.LoadingScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _loadingScreen    :LoadingScreen;
		private var _chapterOneScreen : screen.chapterOne.ChapterScreen;
		
		public function Game()
		{
			super();
			_loadingScreen    = new LoadingScreen();
			_chapterOneScreen = new screen.chapterOne.ChapterScreen();
			
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
						trace('loading screen');
						
					break;
					
					case Constant.FIRST_CHAPTER_FUNC_SCREEN:
						trace('first chapter func screen');
						this.addChild(_chapterOneScreen);
						//this.removeChild(_loadingScreen);

						//_loadingScreen = null;

					break;
					
					default:
						trace('stupid');
					break;
				}
			}
		}
	}
}