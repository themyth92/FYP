package main
{
	import Screens.LoadingScreen.LoadingScreen;

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
			
		}
		
		private function onAddedToStage(event:Event):void{
			this.addChild(_loadingScreen);
		}
	}
}