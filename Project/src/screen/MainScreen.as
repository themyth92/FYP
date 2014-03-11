package screen
{
	import assets.Assets;
	import events.NavigationEvent;
	import constant.Constant;
	
	import feathers.controls.Screen;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MainScreen extends Sprite
	{
		private var _background		:Image;
		private var _title			:Image;
		
		private var _playButton		:Button;
		private var _createButton	:Button;
		private var _aboutButton	:Button;
		
		public function MainScreen()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_background = new Image(Assets.getAtlas(Constant.MAIN_SCREEN).getTexture("background"));
			this.addChild(_background);
			
			_title = new Image(Assets.getAtlas(Constant.MAIN_SCREEN).getTexture("title"));
			this.addChild(_title);
			
			_playButton = new Button(Assets.getAtlas(Constant.MAIN_SCREEN).getTexture("Story_Mode"));
			_playButton.x = 200;
			_playButton.y = 300;
			this.addChild(_playButton);
			
			_createButton = new Button(Assets.getAtlas(Constant.MAIN_SCREEN).getTexture("Create_Mode"));
			_createButton.x = 200;
			_createButton.y = 400;
			this.addChild(_createButton);
			
			_aboutButton = new Button(Assets.getAtlas(Constant.MAIN_SCREEN).getTexture("About"));
			_aboutButton.x = 200;
			_aboutButton.y = 500;
			this.addChild(_aboutButton);
			
			this.addEventListener(Event.TRIGGERED, onMainClick);
		}
		
		private function onMainClick(event:Event):void
		{
			var buttonClicked : Button = event.target as Button;
			if(buttonClicked == _createButton)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.CREATE_GAME_SCREEN}, true));
			}
			else if(buttonClicked == _playButton)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.STORY_SCREEN_1}, true));
			}
			else if(buttonClicked == _aboutButton)
			{
				
			}
		}
	}
}