/**************************
 * ====================== *
 * CONTROLLER FOR LOADING *
 * ====================== * 
 **************************/

package controller.TextureController 
{
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class TextureLoaderControl extends Sprite
	{
		private var _loader       : Loader;
		private var _fileIndex    : uint;
		private var _numberOfFile : uint;
		private var _imgList      : Array;
		
		public function TextureLoaderControl()
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
			else{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id : Constant.MAIN_SCREEN}, true));
			}
		}
		
		//for every image, this function will be called once
		private function loadEachTexure():void{
			
			try{
				
				if(_imgList[_fileIndex] != null){
					
					_loader  				 = new Loader();
					
					_loader.load(new URLRequest('http://ec2-54-254-145-192.ap-southeast-1.compute.amazonaws.com:3000/uploads/' + _imgList[_fileIndex].address));
								
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
			
			try{
				var type  : String = _imgList[_fileIndex].title;
				var title : String = _imgList[_fileIndex].type;
			}
			catch(error:Error){
				throw(error);
			}
			
			Assets.storeUserTexture(texture, title, type);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader = null;
			
			if(_fileIndex < _numberOfFile - 1){
				_fileIndex ++;
				loadEachTexure();
			}
			else{
				//dispatch event here to change the screen
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id : Constant.MAIN_SCREEN}, true));	
			}
		}
	}
}
