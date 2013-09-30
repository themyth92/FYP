package Screens.LoadingScreen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import object.LoaderObject;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TextureLoader extends EventDispatcher
	{
		
		private var _loaderObject  : LoaderObject;
		private var _loader        : Loader;
		private var _xmlLoader     : URLLoader;
		private var _xml           : XML;
		private var _numberOfFiles : uint;
		private var _fileIndex     : uint;
		private var _fileInfo      : Array;
		
		public function TextureLoader(loaderObject: LoaderObject)
		{
			super(); 
			
			this._loaderObject  = loaderObject;
			this._fileIndex     = 0;
			this._loaderObject  = LoaderObject;		
			this._fileInfo      = new Array([Constant.SPRITE_ONE_PNG_ADDR, Constant.SPRITE_ONE_XML_ADDR]);		
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
			_xmlLoader.removeEventListener(Event.COMPLETE, onXMLComplete);
			_xmlLoader = null;
				
			_loader.load(new URLRequest(_fileInfo[_filendex][Constant.PNG_ADDR]);		
		}
		
		private function onLoadProgress():void{
			
			this._loaderObject.visible = true;		
		}
		
		private function onLoadComplete(event:Event):void{
			
			var bitmap : Bitmap = event.currentTarget.content as Bitmap;
			
		}
	}
}