package serverCom
{
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class TextureLoaderControler extends Sprite
	{
		private var _loader       : Loader;
		private var _fileIndex    : uint;
		private var _numberOfFile : uint;
		private var _imgList      : Array;
		
		public function TextureLoaderControler()
		{
			_fileIndex    = 0;
			_numberOfFile = 0;
			_imgList      = new Array();
		}
		
		//the image list will be passed here
		//retrieve from the question and img list from server
		public function loadUserTexture(imgList:Array):void{
			
			_imgList = imgList;
			
			if(_imgList != null && _imgList.length > 0){
				
				_numberOfFile = _imgList.length;
				loadEachTexure();	
			}
		}
		
		//for every image, this function will be called once
		private function loadEachTexure():void{
			
			try{
				
				if(_imgList[0] != null){
				
					_loader = new Loader();
					_loader.load(new URLRequest('/public/' + _imgList[0].address));
					
					_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				}
			}
			catch(error:Error){
				throw(error);
			}
		}
		
		//for debugging purpose
		private function onLoadProgress(e:ProgressEvent):void{
			
			var pcent:Number = e.target.bytesLoaded / e.target.bytesTotal * 100;
			trace('File ' + _fileIndex + ' is loading ' + pcent);
		}
		
		//complete the event when the file load complete
		//continue to load next file when there is still
		private function onLoadComplete(e:Event):void{
			
			var bitmap : Bitmap = e.currentTarget.content as Bitmap;
			
			var texture: Texture = Texture.fromBitmap(bitmap);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader = null;
			
			if(_fileIndex < _numberOfFile - 1){
				_fileIndex ++;
				loadEachTexure();
			}
			else{
				//dispatch event here to change the screen
			}
		}
	}
}