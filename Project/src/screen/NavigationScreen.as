package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import feathers.controls.Screen;
	
	import manager.ServerClientManager;
	
	import object.SoundObject;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class NavigationScreen extends Sprite
	{
		private var _background			:Image;
		private var _title					:Image;
		
		private var _playButton			:Button;
		private var _createButton			:Button;
		private var _quitButton			:Button;
		
		private var _serverClientManager 	:ServerClientManager;
		private var _soundObject			:SoundObject; 
		
		public function NavigationScreen()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._serverClientManager	= new ServerClientManager();
					
			this._background 			= new Image(Assets.getAtlas(Constant.NAVIGATION_SCREEN).getTexture("background"))
			
			this._title 				= new Image(Assets.getAtlas(Constant.NAVIGATION_SCREEN).getTexture("title"));
				
			this._playButton 			= new Button(Assets.getAtlas(Constant.NAVIGATION_SCREEN).getTexture("Story_Mode"));
			this._playButton.x 			= 200;
			this._playButton.y 			= 300;
			
			this._createButton 			= new Button(Assets.getAtlas(Constant.NAVIGATION_SCREEN).getTexture("Create_Mode"));
			this._createButton.x 		= 200;
			this._createButton.y 		= 400;	
			
			this._quitButton 			= new Button(Assets.getAtlas(Constant.NAVIGATION_SCREEN).getTexture("About"));
			this._quitButton.x 			= 200;
			this._quitButton.y 			= 500;
			
			this._soundObject			= new SoundObject();
			this._soundObject.x			= 620;
			this._soundObject.y			= 550;
			this._soundObject.playBackgroundMusic(Constant.NAVIGATION_SCREEN);
			
			this.addChild(this._background);
			this.addChild(this._title);
			this.addChild(this._playButton);
			this.addChild(this._createButton);
			this.addChild(this._quitButton);
			this.addChild(this._soundObject);
			
			this.addEventListener(Event.TRIGGERED, onMainClick);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onMainClick(event:Event):void
		{
			var buttonClicked : Button = event.target as Button;
			
			if(buttonClicked == this._createButton)
			{
				//stop music first then dispatch event
				this._soundObject.stopBackgroundMusic();
				
				Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.NAVIGATION_SCREEN, to: Constant.CREATE_GAME_SCREEN}, true));
				this.removeEventListener(Event.TRIGGERED, onMainClick);
			}
			else if(buttonClicked == this._playButton)
			{
				//stop music first then dispatch event
				this._soundObject.stopBackgroundMusic();
				
				Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.NAVIGATION_SCREEN, to : Constant.STORY_SCREEN}, true));
				this.removeEventListener(Event.TRIGGERED, onMainClick);
			}
			else if(buttonClicked == this._quitButton)
			{
				//stop music
				this._soundObject.stopBackgroundMusic();
				
				//call server to change view
				this._serverClientManager.quitGame();
			}
		}
		
		private function onRemoveFromStage(event:Event):void{
			
			this.removeChild(this._background);
			this.removeChild(this._title);
			this.removeChild(this._playButton);
			this.removeChild(this._createButton);
			this.removeChild(this._quitButton);
			this.removeChild(this._soundObject);
			
			this._background   	= null;
			this._title        	= null;
			this._playButton   	= null;
			this._createButton 	= null;
			this._quitButton  	= null;
			this._soundObject	= null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	}
}