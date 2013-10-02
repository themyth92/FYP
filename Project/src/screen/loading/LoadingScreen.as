/*

*Display all the element for the loading screen

*/

package screen.loading 
{
	
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import object.LoaderObject;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
		
	public class LoadingScreen extends Sprite
	{	
		private var _textureLoader : LoadingTexture;
		private var _loaderObject  : LoaderObject;
		
		public function LoadingScreen()
		{
			super();
			//the change screen event is used when loader object dispatch a change screen event
			this.addEventListener(NavigationEvent.CHANGE_SCREEN , onChangeScreen);
			
			//this is for game object to dispatch event
			this.addEventListener(Event.REMOVED_FROM_STAGE      , onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE          , onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			
			_loaderObject   = new LoaderObject();
			_textureLoader  = new LoadingTexture();
				
			this.addChild(_loaderObject);
			_textureLoader.loadTexture();
		}
		
		private function onRemoveFromStage(e:Event):void{
			this.removeChild(_loaderObject);
			_loaderObject  = null;
			_textureLoader = null;
		}
		
		private function onChangeScreen(e:NavigationEvent):void{
			this.removeEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, e.screenID));
		}
	}
}