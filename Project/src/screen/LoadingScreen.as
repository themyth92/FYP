/*
	we have 3 pages and depend on the page
	we will load the data from server differently
	1. story page which will load all the user defined data include : 
		question list and obstacle texture
	2. repair game which will load the user defined data include : question list 
		and obstacle texture plus the saved game data
	3. play game which will load the data from server which belong to the 
		game owner
*/
package screen
{
	import constant.Constant;
	
	import controller.LoaderControler.LoaderController;
	
	import events.NavigationEvent;
	
	import feathers.controls.ProgressBar;
	import feathers.layout.AnchorLayoutData;
	import feathers.themes.MetalWorksMobileTheme;
	
	import main.Game;
	
	import manager.ServerClientManager;
	
	import object.LoaderObject;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class LoadingScreen extends Sprite
	{	
		private static const LOAD_COMPLETE   	:String = 'LoadComplete';
		private static const STORY_PAGE 		:int = 1;
		private static const SAVE_PAGE  		:int = 2;
		private static const PLAY_PAGE  		:int = 3;
		
		private var _progress					:ProgressBar;
		private var _loadController 			:LoaderController;
		private var _serverClientManager     	:ServerClientManager;
		private var _pcent						:Number;
		
		public function LoadingScreen()
		{
			
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,  	onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,	onRemoveFromStage);
			this.addEventListener(LOAD_COMPLETE, 		 	onLoadComplete);
		}

		private function onEnterFrame(event:Event):void{
			this._progress.value = this._loadController.loadedPcent;
		}
		
		private function onAddedToStage(event:Event):void
		{
			
			new MetalWorksMobileTheme();
			
			this._progress 								= new ProgressBar();
			this._pcent									= 0;
			
			this._progress.minimum 						= 0;
			this._progress.maximum 						= 100;
			this._progress.value 						= 0;
			const progressLayoutData:AnchorLayoutData 	= new AnchorLayoutData();
			progressLayoutData.horizontalCenter	 		= 0;
			progressLayoutData.verticalCenter 			= 0;
			this._progress.layoutData 					= progressLayoutData;
			this._progress.x 							= 265;
			this._progress.y 							= 600/2;

			this.addChild(this._progress);
			
			//add loader object controller
			this._serverClientManager					= new ServerClientManager();
			var serverObj:Object 						= this._serverClientManager.initCallServer();
			
			this._loadController						= new LoaderController(serverObj);
			
			this.addEventListener(Event.ENTER_FRAME, 	 	onEnterFrame);
		}
		
		private function onLoadComplete(event:Event):void
		{

			//rely on the pageID from server
			//route the user to specific page
			//if page ID == story page then route to navigation page
			//if page ID == repair page then route to create game page 
			//if page ID == play gmae page the route to play game page
			if(event.data.pageID == STORY_PAGE)
			{
				
				//for some reason
				//this can not pass event to the game object
				//therefore use current starling stage instead
				Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.LOADING_SCREEN, to :Constant.NAVIGATION_SCREEN}, true));
			}
			
			else if(event.data.pageID == SAVE_PAGE){
				
				Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.LOADING_SCREEN, to :Constant.CREATE_GAME_SCREEN}, true));
			}
			
			else if(event.data.pageID == PLAY_PAGE){
				
				Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.LOADING_SCREEN, to :Constant.PLAY_SCREEN}, true));
			}
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(this._progress);
			this._progress		 		= null;
			this._loadController 		= null;
			this._serverClientManager	= null;
		}
	}
}