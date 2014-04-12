/**************************
 * ====================== *
 * CONTROLLER FOR LOADING *
 * ====================== * 
 **************************/

package controller.LoaderControler 
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	
	import screen.LoadingScreen;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class LoaderController extends LoadingScreen
	{
		private static const STORY_PAGE 	: int = 1;
		private static const SAVE_PAGE  	: int = 2;
		private static const PLAY_PAGE  	: int = 3;
		private static const LOAD_COMPLETE: String =  'LoadComplete';
		
		private var _loader       			: Loader;
		private var _fileIndex    			: uint;
		private var _numberOfFile 			: uint;
		private var _imgList      			: Array;
		private var _questionList 			: Array;
		private var _serverData   			: Object;
		private var _loadedPcent			: Number;
		
		//keep track of the index of the image loaded
		//to be either screen or obstacle
		private var _screenTexIndex		: uint = 0;
		private var _obstaclesTexIndex 	: uint = 0;
		
		public function LoaderController(serverData : Object)
		{
			super();
			
			this._fileIndex    		= 0;
			this._numberOfFile 		= 0;
			
			this._serverData		= serverData;
			
			this.processDataFromServer();
		}

		public function get loadedPcent():Number
		{
			return _loadedPcent;
		}
		
		private function processDataFromServer():void
		{
			if(this._serverData && this._serverData.pageID){
				
				//keep the pageID somewhere
				Assets.pageID	=	this._serverData.pageID;
				
				//if the server repond with attributes pageID = 1
				if(this._serverData.pageID == STORY_PAGE){
					
					//set the current story stage for user
					if(this._serverData.storyStage)
						Assets.userCurrentStoryStage	=	this._serverData.storyStage;
						
					this._questionList 	= this.getQsList(this._serverData);
					this._imgList	  	= this.getImgList(this._serverData);
					this.loadUserTexture();
				}
				
				else if(this._serverData.pageID == SAVE_PAGE)
				{
					PreviewGameInfo._isSaved = true;
					PreviewGameInfo._gameID 	= this._serverData._id;
					PreviewGameInfo._gameScreen = this._serverData.screen;
					PreviewGameInfo._gameTitle 	= this._serverData.title;
					PreviewGameInfo.storePlayerInfo		 (this._serverData.player);
					PreviewGameInfo.storeObstaclesInfo	 (this._serverData.obstacles);
					PreviewGameInfo.storeScoreInfo		 (this._serverData.scoreBoard);
					PreviewGameInfo.storeEnemyInfo(this._serverData.enemy, null, null);
					this._questionList 	= this.getQsList (this._serverData);
					this._imgList	  	= this.getImgList(this._serverData);
					this.loadUserTexture();
				}
				
				else if(this._serverData.pageID == PLAY_PAGE)
				{
					PreviewGameInfo._gameID 	= this._serverData._id;
					PreviewGameInfo._gameScreen = this._serverData.screen;
					PreviewGameInfo._gameTitle 	= this._serverData.title;
					PreviewGameInfo.storePlayerInfo		 (this._serverData.player);
					PreviewGameInfo.storeObstaclesInfo	 (this._serverData.obstacles);
					PreviewGameInfo.storeScoreInfo		 (this._serverData.scoreBoard);
					this._questionList 	= this.getQsList(this._serverData);
					this._imgList	  	= this.getImgList(this._serverData);
					this.loadUserTexture();
				}
			}
		}
		
		//the image list will be passed here
		//retrieve from the question and img list from server
		private function loadUserTexture():void{ 
			
			if(this._questionList != null && this._questionList.length > 0){
				this.loadAllQuestion();	
			}
			
			if(this._imgList != null && this._imgList.length > 0){
				
				this._numberOfFile = this._imgList.length;
				loadEachTexure();	
			}
			else{
				this._loadedPcent = 100;
				//dispatch event when load complete
				this.dispatchEventWith(LOAD_COMPLETE, false, {pageID : this._serverData.pageID});
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
		
		//keep track of data loaded
		private function onLoadProgress(e:ProgressEvent):void{
			
			this._loadedPcent =  e.target.bytesLoaded / e.target.bytesTotal * 100;
		
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
					Assets.storeUserTexture(texture, title, 1, address, this._obstaclesTexIndex);
					this._obstaclesTexIndex ++;
				}
				else{
					if(_imgList[_fileIndex].type == 'Rewards'){
						Assets.storeUserTexture(texture, title, 2, address, this._obstaclesTexIndex);
						this._obstaclesTexIndex ++;
					}	
					else
						if(_imgList[_fileIndex].type == 'Screen'){
							Assets.storeUserScreenTexture(texture, 0, title, address, this._screenTexIndex);
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
				
				//when load complete
				this.dispatchEventWith(LOAD_COMPLETE, false, {pageID : this._serverData.pageID});
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
		
		/*
			function will be used to decode the data from server
			when user come to page story or repair their own game
			These function will retrieve all the user defined texture 
			and question from data from server
		*/
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
