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
		private var _questionList : Array;
		
		//keep track of the index of the image loaded
		//to be either screen or obstacle
		private var _screenTexIndex	:uint = 0;
		private var _obstaclesTexIndex : uint = 0;
		
		public function TextureLoaderControl()
		{
			_fileIndex    = 0;
			_numberOfFile = 0;
			_imgList      = new Array();
			_questionList = new Array();
		}
		
		//the image list will be passed here
		//retrieve from the question and img list from server
		public function loadUserTexture(imgList:Array, questionList:Array):void{
			
			_imgList 		= imgList;
			_questionList 	= questionList; 
			
			if(_questionList != null && _questionList.length > 0){
				this.loadAllQuestion();	
			}
			
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
					
					_loader.load(new URLRequest('http://themyth92.com:3000/uploads/' + _imgList[_fileIndex].address));
								
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
				var title  		: String = _imgList[_fileIndex].title;
				var type 		: Number;
				var address 	: String = _imgList[_fileIndex].address;
				
				if(_imgList[_fileIndex].type == 'Obstacles'){
					Assets.storeUserTexture(texture, title, 0, address, this._obstaclesTexIndex);
					this._obstaclesTexIndex ++;
				}
				else{
					if(_imgList[_fileIndex].type == 'Rewards'){
						Assets.storeUserTexture(texture, title, 1, address, this._obstaclesTexIndex);
						this._obstaclesTexIndex ++;
					}	
					else
						if(_imgList[_fileIndex].type == 'Screen'){
							Assets.storeUserScreenTexture(texture, 2, title, address, this._screenTexIndex);
							this._screenTexIndex ++;
						}
				}		
			}
			catch(error:Error){
				throw(error);
			}
			
			
			
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
		
		//load all user defined question 
		//and save it into assets class
		private function loadAllQuestion():void{
			
			for(var i :uint = 0 ; i < this._questionList.length ; i++){
				
				if(	this._questionList[i].title && 
				   	this._questionList[i].select && 
					this._questionList[i].hint && 
					this._questionList[i].answers){
					
					Assets.storeUserQuestion(this._questionList[i].title, 
											 this._questionList[i].select, 
											 this._questionList[i].answers, 
											 this._questionList[i].hint, i); 
				}
			}
		}
	}
}
