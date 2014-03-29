/*

*Display all the element for the loading screen

*/

package screen  
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.TextureController.TextureLoaderControl;
	
	import events.NavigationEvent;
	
	import object.LoaderObject;
	
	import serverCom.ServerClientCom;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
		
	public class LoadingScreen extends Sprite
	{	
		private var _textureLoader : TextureLoaderControl;
		private var _loaderObject  : LoaderObject;
		private var _serCliObj     : ServerClientCom;
		
		public function LoadingScreen()
		{
			super();
			
			//this is for game object to dispatch event
			this.addEventListener(Event.REMOVED_FROM_STAGE      , onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE          , onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			
			_loaderObject   = new LoaderObject();
			_textureLoader  = new TextureLoaderControl();
			_serCliObj      = new ServerClientCom();
			
			this.addChild(_loaderObject);
			this.addChild(_textureLoader);
			
			var qsImgList:Object 				= _serCliObj.retrieveQuestionAndImageListFromServer();
		
			_textureLoader.loadUserTexture(this.getImgList(qsImgList), this.getQsList(qsImgList));	
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeChild(_loaderObject);
			_loaderObject  = null;
			_textureLoader = null;
		}
		
		//process to return the image list from data from server
		private function getImgList(qsImgList : Object):Array{

			if(qsImgList != {} && qsImgList != null){
				
				if(qsImgList.image){
					
					return qsImgList.image;
				}
			}
			
			return new Array();
		}
		
		//process to return the question list from data from server
		private function getQsList(qsImgList : Object):Array{
			
			if(qsImgList != {} && qsImgList != null){
				
				if(qsImgList.question){
					
					return qsImgList.question;
				}
			}
			
			return new Array();
		}
	}
}