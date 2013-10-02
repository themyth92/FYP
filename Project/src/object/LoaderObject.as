package object
{
	import assets.Assets;
	
	import constant.Constant;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class LoaderObject extends Sprite
	{
		private var _loaderObject : MovieClip;
		private var _loaderText   : Image;
		private var _background   : Image;
		
		public function LoaderObject()
		{
			super();
<<<<<<< HEAD
=======
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddedToStage(event:Event):void{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createLoaderAnimation();
>>>>>>> origin/nhat
		}
		
		public function createLoaderAnimation():void{
			
			_loaderObject   = new MovieClip(Assets.getAtlas(Constant.LOADING_SCREEN).getTextures('preLoader_'));
			_loaderText     = new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('loadingText'));
			_background     = new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('background'));
			
			_loaderObject.x = 461;
			_loaderObject.y = 239;
			
			_loaderText.x   = 351;
			_loaderText.y   = 422;

			_background.x   = 0;
			_background.y   = 0;
			
			Starling.juggler.add(_loaderObject);
			
			this.addChild(_background);
			this.addChild(_loaderText);
			this.addChild(_loaderObject);

		}
		
		private function onRemoveFromStage():void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			this.removeChild(_loaderText);
			this.removeChild(_loaderObject);
			
			_loaderText   = null;
			_loaderObject = null;
		}
		
		public function removeLoaderAnimation():void{
			this.removeChild(_loaderText);
			this.removeChild(_loaderObject);
		}
	}
}