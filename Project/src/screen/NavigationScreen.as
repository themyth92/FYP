package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.layout.VerticalLayout;
	
	import manager.ServerClientManager;
	
	import object.SoundObject;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	
	public class NavigationScreen extends Sprite
	{
		private var _background				:Image;
		private var _title					:Image;
		
		private var _playButton				:Button;
		private var _createButton			:Button;
		private var _quitButton				:Button;
		
		private var _serverClientManager 	:ServerClientManager;
		private var _soundObject			:SoundObject;
		private var _clickToContinue		:TextField;
		
		public function NavigationScreen()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			/* Server Client Connection */
			this._serverClientManager	= new ServerClientManager();
			
			/* Get Image from xml file */
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
			this._soundObject.playBackgroundMusic(Constant.NAVIGATION_SCREEN);
			
			this._clickToContinue		= new TextField(300, 100, "Press any key to continue", "Verdana", 26,0x0024a8,true);
			this._clickToContinue.x 	= 250;
			this._clickToContinue.y		= 375;
			
			this.addChild(this._background);
			this.addChild(this._clickToContinue);
			
			setupBlinkingText();
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/*-----------------------------------------------------------------------
		| @Key pressed event to display next screen			                     |		
		-------------------------------------------------------------------------*/
		private function onKeyPressed(e:KeyboardEvent):void
		{
			//Remove all animation
			Starling.juggler.purge();
			
			//Remove blinking text and event
			this.removeChild(this._clickToContinue);
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			
			//Animation until next screen
			var zoomIn	:Tween = new Tween(this._background, 1.5);
			zoomIn.fadeTo(0);
			zoomIn.scaleTo(1);
			zoomIn.onComplete = showButtons;
			Starling.juggler.add(zoomIn);
		}
		
		/*-----------------------------------------------------------------------
		| @Show new layout after keypressed					                     |		
		-------------------------------------------------------------------------*/
		private function showButtons():void
		{
			//Remove previous background
			this.removeChild(this._background);
			
			//Setup buttons in a layout
			var btnGroup	:LayoutGroup = new LayoutGroup();
			var btnLayout	:VerticalLayout = new VerticalLayout();
			btnLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			btnLayout.gap = 20;
			btnGroup.layout = btnLayout;
			btnGroup.addChild(this._playButton);
			btnGroup.addChild(this._createButton);
			btnGroup.addChild(this._quitButton);
			btnGroup.x = 290;
			btnGroup.y = 400;
			this.addChild(this._title);
			
			this.addChild(btnGroup);
			
			//Listen to certain events
			this._playButton.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
				onHover(e,1);
			});
			this._createButton.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
				onHover(e,2);
			});
			this._quitButton.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
				onHover(e,3);
			});
			this._title.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
				onHover(e,4);
			});
			this.addEventListener(Event.TRIGGERED, onMainClick);
		}
		
		/*-----------------------------------------------------------------------
		| @If mouse hover over button, highlight it			                     |		
		-------------------------------------------------------------------------*/
		private function onHover(e:TouchEvent,id:Number):void{
			var glow	:BlurFilter = BlurFilter.createGlow(0xca0000);
			var touch 	:Touch = e.getTouch(this, TouchPhase.HOVER);
			if(touch)
			{
				if(id == 2)
				{
					this._playButton.filter = null;
					this._createButton.filter = glow;
					this._quitButton.filter = null;
				}
				else if(id == 1)
				{
					this._playButton.filter = glow;
					this._createButton.filter = null;
					this._quitButton.filter = null;
				}
				else if(id == 3)
				{
					this._playButton.filter = null;
					this._createButton.filter = null;
					this._quitButton.filter = glow;
				}
				else 
				{
					this._playButton.filter = null;
					this._createButton.filter = null;
					this._quitButton.filter = null;
				}
			}
		}
		
		/*-----------------------------------------------------------------------
		| @Recursive function to blink the text				                     |		
		-------------------------------------------------------------------------*/
		private function setupBlinkingText():void{
			var glow	:BlurFilter = BlurFilter.createGlow();
			var blink	:Tween	= new Tween(this._clickToContinue, 2.0);
			this._clickToContinue.filter = glow;
			blink.fadeTo(0.3);
			blink.reverse = true;
			blink.repeatCount = 2;
			blink.onComplete = setupBlinkingText;
			Starling.juggler.add(blink);
			
			var blink1	:Tween	= new Tween(this._clickToContinue.filter, 2.0);
			blink1.fadeTo(0.3);
			blink1.reverse = true;
			blink1.repeatCount = 2;
			Starling.juggler.add(blink);
		}
		
		/*-----------------------------------------------------------------------
		| @Dispatch event upon clicking any button			                     |		
		-------------------------------------------------------------------------*/
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
		
		/*-----------------------------------------------------------------------
		| @Remove from stage								                     |		
		-------------------------------------------------------------------------*/
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