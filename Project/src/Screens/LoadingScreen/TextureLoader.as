package Screens.LoadingScreen
{
	import starling.display.Sprite;
	
	import assets.Assets;
	
	public class TextureLoader extends Sprite
	{
<<<<<<< HEAD
		
		private var _loaderObject  : LoaderObject;
		private var _loader        : Loader;
		private var _xmlLoader     : URLLoader;
		private var _xml           : XML;
		private var _numberOfFiles : uint;
		private var _fileIndex     : uint;
		private var _fileInfo      : Array;
		
		public static const TEXTURE_LOADED:String  = 'textureLoaded';
		public static const TEXTURE_LOADING:String = 'textureLoading'; 
		
		public function TextureLoader()
		{
			super(); 
			
			this._fileIndex     = 0;	
			this._fileInfo      = new Array([Constant.SPRITE_ONE_PNG_ADDR, Constant.SPRITE_ONE_XML_ADDR],[Constant.SPRITE_THREE_PNG_ADDR, Constant.SPRITE_THREE_XML_ADDR],[Constant.SPRITE_TWO_PNG_ADDR, Constant.SPRITE_TWO_XML_ADDR],[Constant.SPRITE_FOUR_PNG_ADDR, Constant.SPRITE_FOUR_XML_ADDR]);		
			this._numberOfFiles = this._fileInfo.length;
		}
		
		public function loadTexture():void{
			
			_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);	
			
			if(_fileInfo[_fileIndex] != null){
				
				if(_fileInfo[_fileIndex][Constant.PNG_ADDR] !=null && _fileInfo[_fileIndex][Constant.XML_ADDR] !=null){
					
					_xmlLoader = new URLLoader();
					_xmlLoader.addEventListener(Event.COMPLETE, onXMLLoadComplete);
					_xmlLoader.load(new URLRequest(_fileInfo[_fileIndex][Constant.XML_ADDR]));
				}
			}
		}
		
		private function onXMLLoadComplete(event:Event):void{		
			
			_xml       = new XML(event.target.data);
			_xmlLoader.removeEventListener(Event.COMPLETE, onXMLLoadComplete);
			_xmlLoader = null;
				
			_loader.load(new URLRequest(_fileInfo[_fileIndex][Constant.PNG_ADDR]));		
		}
		
		private function onLoadProgress(e:ProgressEvent):void{
			var pcent:Number = e.target.bytesLoaded / e.target.bytesTotal * 100;
			trace(pcent);
		}
		
		private function onLoadComplete(event:Event):void{
			
			var bitmap : Bitmap = event.currentTarget.content as Bitmap;
			
			var textureAtlas: TextureAtlas = new TextureAtlas(Texture.fromBitmap(bitmap), _xml);
			
			Assets.storeGameTextureAtlas(textureAtlas, Constant.SPRITE_ONE);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader = null;
			
			if(_fileIndex < _numberOfFiles - 1){
				this._fileIndex ++;
				this.loadTexture();
			}	
			else{
				
				dispatchEvent(new Event(TextureLoader.TEXTURE_LOADED));	
			}
=======
		public function TextureLoader()
		{
			super(); 
>>>>>>> parent of 48d8052... Added sprite sheet for chapter 1 function
		}
	}
}