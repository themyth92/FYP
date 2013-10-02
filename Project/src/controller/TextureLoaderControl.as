package controller 
{
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import object.LoaderObject;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TextureLoaderControl extends Sprite
	{
		
		private var _loaderObject  : LoaderObject;
		private var _loader        : Loader;
		private var _xmlLoader     : URLLoader;
		private var _xml           : XML;
		private var _numberOfFiles : uint;
		private var _fileIndex     : uint;
		private var _fileInfo      : Array;
		
		public function TextureLoaderControl()
		{
			super(); 
			
			this._fileIndex     = 0;	
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
					
					try{
						
						_xmlLoader.load(new URLRequest(_fileInfo[_fileIndex][Constant.XML_ADDR]));
					}
					catch(e:Error){
						
						trace(Constant.LOAD_FILE_PROBLEM + ': ' + e.message);
						return;
					}
				}
			}	
		}
		
		private function onXMLLoadComplete(event:flash.events.Event):void{		
			
			_xml       = new XML(event.target.data);
			_xmlLoader.removeEventListener(Event.COMPLETE, onXMLLoadComplete);
			_xmlLoader = null;
			
			try{	
				
				_loader.load(new URLRequest(_fileInfo[_fileIndex][Constant.PNG_ADDR]));
			}
			catch(e:Error){
				
				trace(Constant.LOAD_FILE_PROBLEM + ': ' + e.message);
				return;
			}
		}
		
		private function onLoadProgress(e:ProgressEvent):void{
			
			var pcent:Number = e.target.bytesLoaded / e.target.bytesTotal * 100;
			
			trace('File ' + _fileIndex + ' is loading ' + pcent);
		}
		
		private function onLoadComplete(event:Event):void{
			
			var bitmap : Bitmap = event.currentTarget.content as Bitmap;
			
			var texture:Texture = Texture.fromBitmap(bitmap);
			
			Assets.storeAtlas(texture, _xml, Constant.SPRITE_ONE);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader = null;
			
			if(_fileIndex < _numberOfFiles - 1){
				this._fileIndex ++;
				this.loadTexture();
			}	
			else{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id : Constant.FIRST_CHAPTER_FUNC_SCREEN}, true));	
			}
		}
	}
}