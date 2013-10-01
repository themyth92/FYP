package Screens.LoadingScreen 
{
	
	import flash.events.Event;
	
	import object.LoaderObject;
	
	import starling.display.Sprite;
	import starling.display.Image;
	import assets.Assets;
	import constant.Constant;
	
	public class LoadingScreen extends Sprite
	{
		private var _textureLoader : TextureLoader;
		private var _loaderObject  : LoaderObject;
		
		public function LoadingScreen()
		{
			super();
			_loaderObject  = new LoaderObject();
			_textureLoader = new TextureLoader();
			_loaderObject.createLoaderAnimation();
			this.addChild(_loaderObject);
			_textureLoader.addEventListener(TextureLoader.TEXTURE_LOADING, onTextureLoading);
			_textureLoader.addEventListener(TextureLoader.TEXTURE_LOADED, onTextureLoaded);
			_textureLoader.loadTexture();
		}
		
		private function onTextureLoading(event:Event):void{
			
			
			_textureLoader.removeEventListener(TextureLoader.TEXTURE_LOADING, onTextureLoading);
			
		}
		
		private function onTextureLoaded(event:Event):void{
			var _loaderText:Image = new Image(Assets.getGameTextureAtlas(Constant.SPRITE_ONE).getTexture('heart'));
			_loaderText.x = 500;
			_loaderText.y = 500;
			this.addChild(_loaderText);
			
			_loaderObject.removeLoaderAnimation();
			_textureLoader.removeEventListener(TextureLoader.TEXTURE_LOADED, onTextureLoaded);
			this.removeChild(_loaderObject);
		}
	}
}