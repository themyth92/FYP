package object
{
	import assets.Assets;
	
	import constant.Constant;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.core.Starling;
	
	public class LoaderObject extends Sprite
	{
		private var _loaderObject : MovieClip;
		private var _loaderText   : Image;
		
		public function LoaderObject()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createLoaderAnimation();
		}
		
		public function createLoaderAnimation():void{
			
			_loaderObject   = new MovieClip(Assets.getAtlas(Constant.LOADING_SCREEN).getTextures('preLoader_'));
			_loaderText     = new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('loadingText'));
			
			_loaderObject.x = Math.ceil(_loaderObject.width*0.5);
			_loaderObject.y = Math.ceil(_loaderObject.height*0.5);
			
			_loaderText.x   = Math.ceil(_loaderText.width*0.5);
			_loaderText.y   = Math.ceil(_loaderText.y*0.5);
			
			Starling.juggler.add(_loaderObject);
			
			this.addChild(_loaderText);
			this.addChild(_loaderObject);
		}
	}
}