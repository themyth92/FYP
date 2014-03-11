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
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TextureLoaderControl extends Sprite
	{
		//loader to load the png file
		//xml loader to load the xml file
		//xml : private var to temporaily store the xml file and later will be added with the png file in the dictionary in Assets class
		//file index : keep track of the current row/file load from the file info array
		//file info array : 2D array 
		//first column will be the png address
		//second column will be the xml address
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
		
		/*=====================================================================================================
			@in the load texture function
			@I actually load the xml file first and added an event listener for the xml file to be fully loaded
			@after that I will load the png file correspond to the xml file
		=====================================================================================================*/
		public function loadTexture():void{
			
			_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);	
			
			//check if the file Info array got element
			if(_fileInfo[_fileIndex] != null){
				
				if(_fileInfo[_fileIndex][Constant.PNG_ADDR] !=null && _fileInfo[_fileIndex][Constant.XML_ADDR] !=null){
					
					_xmlLoader = new URLLoader();
					_xmlLoader.addEventListener(Event.COMPLETE, onXMLLoadComplete);
					
					//put the try catch here if the xml file can not be found by the system
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
			
			//put the try catch here if the file can not be found by the system
			try{	
				
				_loader.load(new URLRequest(_fileInfo[_fileIndex][Constant.PNG_ADDR]));
			}
			catch(e:Error){
				
				trace(Constant.LOAD_FILE_PROBLEM + ': ' + e.message);
				return;
			}
		}
		
		//just one function to show on console the percent of the current loading file
		private function onLoadProgress(e:ProgressEvent):void{
			
			var pcent:Number = e.target.bytesLoaded / e.target.bytesTotal * 100;
			
			trace('File ' + _fileIndex + ' is loading ' + pcent);
		}
		
		/*=======================================================================================================
		when the load for one file complete
			@the continuity of the loading depends on the number of file still left from the file info array
			@if there is some file still left then continues to load
			@otherwise a new event will be dispatch to notify the other classes for change their screens, etc ...
		========================================================================================================*/
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
				//dispatch the change screen event with the default screen change change ID will be the first chapter function screen
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id : Constant.MAIN_SCREEN}, true));	
				
			}
		}
	}
}
