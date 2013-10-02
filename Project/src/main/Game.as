package main
{
	import events.NavigationEvent;
	
	import constant.Constant;
	
	import screen.loading.LoadingScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _loadingScreen:LoadingScreen;
		
		public function Game()
		{
			super();
			_loadingScreen = new LoadingScreen();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
		}
		
		private function onAddedToStage(event:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
					break;
					
					default:
						trace('stupid');
					break;
				}
			}
		}
	}
}