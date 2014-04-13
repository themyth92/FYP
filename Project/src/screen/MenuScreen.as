package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	//from story screen
	//4 options : resume, quit, reset story, reset level
	//from create game
	//2 cases: 
	//	if user come from story website
	//		3 options : resume, quit, reset
	//	if user come from repair website
	//		2 options : resume, reset
	//from play game
	//2 cases:
	//	if it is a preview 
	//		2 options : quit, resume
	// 	if it is a play
	//		2 options : quit, resume
	//the quit function in two cases are different
	//because we have too many conditions for the menu scree,
	//we seperate the menu screen into objects and inject into separate screen
	//without creating a common menu screen in game class
	public class MenuScreen extends PanelScreen
	{
		private static const STORY_PAGE 	: int = 1;
		private static const SAVE_PAGE  	: int = 2;
		private static const PLAY_PAGE  	: int = 3;
		
		private static const RESET_CURRENT_LEVEL_EVENT: String = 'ResetLevelButtonTrigger';
		private static const RESET_STORY_EVENT		: String = 'OptionMenuResetStoryButtonTrigger';
		private static const RESUME_GAME_EVENT		: String = 'OptionMenuResumeButtonTrigger';
		private static const QUIT_GAME_EVENT			: String = 'QuitButtonTrigger';
		private static const MENU_EVENT				: String = 'MenuEvent';
		private static const RESET_GAME_CREATION_EVENT: String = 'Reset game creation';
		private static const RESET_PLAY_GAME_EVENT	: String = 'Reset play game';
		private static const QUIT_PREVIEW_GAME_EVENT	: String = 'Quit preview';	
		
		private var _buttonGroup	: ButtonGroup;
		private var _bg        	: Quad;
		private var _fromStage		: String;
		
		//keep track of the object call the menu screen
		public function MenuScreen(fromStage:String) 
		{
			
			this._fromStage				= fromStage;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{	
			this.width					= 800;
			this.height					= 600;
			this._bg 					= new Quad(800,600,0x000000);
			this._bg.alpha				= 0.8;
			
			this.layout = new AnchorLayout();
			
			this._buttonGroup  =  new ButtonGroup();
			
			switch(this._fromStage){
				case Constant.STORY_SCREEN:
					this._buttonGroup.dataProvider = new ListCollection(
						[
							{label : 'Resume your game'		, triggered : 	onResumeBtnTrigger},
							{label : 'Reset current level'	, triggered	:	onResetLevelBtnTrigger},
							{label : 'Reset story'				, triggered : 	onResetStoryBtnTrigger},
							{label : 'Quit game'				, triggered : 	onQuitBtnTrigger}
						])
					break;
				case Constant.CREATE_GAME_SCREEN:
					
					//check where use come from on website
					//story page or directly to repair game screen
					if(Assets.pageID == STORY_PAGE){
						this._buttonGroup.dataProvider = new ListCollection(
							[
								{label : 'Resume your game'		, triggered : 	onResumeBtnTrigger},
								{label : 'Reset your creation'	, triggered	:	onResetGameCreationTrigger},
								{label : 'Quit to main menu'		, triggered : 	onQuitBtnTrigger}
							])
					}
					else 
						if(Assets.pageID == SAVE_PAGE){
							this._buttonGroup.dataProvider = new ListCollection(
								[
									{label : 'Resume your game'		, triggered : 	onResumeBtnTrigger},
									{label : 'Reset your creation'	, triggered	:	onResetGameCreationTrigger}
								])
						}
					break;
				case Constant.PLAY_SCREEN:
					if(Assets.pageID == STORY_PAGE || Assets.pageID == SAVE_PAGE){
						this._buttonGroup.dataProvider = new ListCollection(
							[
								{label : 'Resume your game'			, triggered : 	onResumeBtnTrigger},
								{label : 'Reset your game'			, triggered	:	onResetPlayGameTrigger},
								{label : 'Return to your creation'	, triggered : 	onQuitPreviewGameTrigger}
							])
					}
					else 
						if(Assets.pageID == PLAY_PAGE){
							this._buttonGroup.dataProvider = new ListCollection(
								[
									{label : 'Resume your game'		, triggered : 	onResumeBtnTrigger},
									{label : 'Reset your game'		, triggered	:	onResetPlayGameTrigger}
								])
						}
				default:
					break;
			}
			
			const buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
			buttonGroupLayoutData.horizontalCenter = 0;
			buttonGroupLayoutData.verticalCenter = 0;
			this._buttonGroup.layoutData = buttonGroupLayoutData;
			this.headerFactory = function():Header
			{
				var header:Header 	= new Header();
				header.height 		= 60;
				header.title		= 'Main menu';
				return header;
			}
				
			this.addChild(this._bg);
			this.addChild(this._buttonGroup);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeChild(this._buttonGroup);
			this.removeChild(this._bg);
			
			this._bg 		   	= null;
			this._buttonGroup 	= null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onResumeBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(MENU_EVENT,true, {event : RESUME_GAME_EVENT});
		}
		
		private function onQuitBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(MENU_EVENT, true, {event : QUIT_GAME_EVENT});
		}
		
		private function onResetStoryBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(MENU_EVENT, true, {event : RESET_STORY_EVENT});
		}
		
		private function onResetLevelBtnTrigger(event:Event):void
		{
			this.dispatchEventWith(MENU_EVENT, true, {event : RESET_CURRENT_LEVEL_EVENT});
		}
		
		private function onResetGameCreationTrigger(event:Event):void
		{
			this.dispatchEventWith(MENU_EVENT, true, {event : RESET_GAME_CREATION_EVENT});
		}
		
		private function onResetPlayGameTrigger(event:Event):void
		{
			this.dispatchEventWith(MENU_EVENT, true , {event : RESET_PLAY_GAME_EVENT});
		}
		
		private function onQuitPreviewGameTrigger(event:Event):void
		{
			this.dispatchEventWith(MENU_EVENT, true ,{event : QUIT_PREVIEW_GAME_EVENT});
		}
	}
}