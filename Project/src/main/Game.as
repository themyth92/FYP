package main
{
<<<<<<< HEAD
	import Screens.LoadingScreen.LoadingScreen;

=======
	import events.NavigationEvent;
	
	import constant.Constant;
	
	
>>>>>>> origin/nhat
	import starling.display.Sprite;
	import starling.events.Event;
	import screen.loading.LoadingScreen;
	
	public class Game extends Sprite
	{
		private var _loadingScreen:LoadingScreen;
		
		public function Game()
		{
			super();
			_loadingScreen = new LoadingScreen();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void{
<<<<<<< HEAD
			this.addChild(_loadingScreen);
=======
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
					break;
					
					default:
						trace('stupid');
					break;
				}
			}
>>>>>>> origin/nhat
		}
	}
}