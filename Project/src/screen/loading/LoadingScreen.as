/*

*Display all the element for the loading screen

*/

package screen.loading  
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.TextureLoaderControl;
	
	import events.NavigationEvent;
	
	import object.LoaderObject;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	

		
	public class LoadingScreen extends Sprite
	{	
		private var _textureLoader : TextureLoaderControl;
		private var _loaderObject  : LoaderObject;
		
		public function LoadingScreen()
		{
			super();
			
			//this is for game object to dispatch event
			this.addEventListener(Event.REMOVED_FROM_STAGE      , onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE          , onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			
			_loaderObject   = new LoaderObject();
			_textureLoader  = new TextureLoaderControl();
			//this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id : Constant.FIRST_CHAPTER_FUNC_SCREEN}, true));	
			this.addChild(_loaderObject);
			this.addChild(_textureLoader);
			
			_textureLoader.loadTexture();
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeChild(_textureLoader);
			this.removeChild(_loaderObject);
			_loaderObject  = null;
			_textureLoader = null;
		}
	}
}