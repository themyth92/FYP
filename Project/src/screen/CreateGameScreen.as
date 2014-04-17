package screen
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import com.adobe.base64.Base64Encoder;
	import com.adobe.images.PNGEncoder;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Panel;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import manager.ServerClientManager;
	
	import object.CreateGameObject.ComponentPanel;
	import object.CreateGameObject.CreateGameScoreBoard;
	import object.CreateGameObject.GridPanel;
	import object.CreateGameObject.ObstacleObj;
	import object.CreateGameObject.ObstaclePanel;
	import object.SoundObject;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	
	public class CreateGameScreen extends Sprite
	{	
		private static const DRAG_FORMAT				: String = 'draggableQuad';
		private static const RESUME_GAME_EVENT		: String = 'OptionMenuResumeButtonTrigger';		
		private static const QUIT_GAME_EVENT			: String = 'QuitButtonTrigger';
		private static const RESET_GAME_CREATION_EVENT: String = 'Reset game creation';		
		private static const MENU_EVENT				: String = 'MenuEvent';
		
		private var _obstaclePanel  	:ObstaclePanel;
		private var _gridPanel      	:GridPanel;
		private var _componentPanel 	:ComponentPanel;
		private var _scoreBoard		:CreateGameScoreBoard;
		private var _com				:ServerClientManager;
		
		private var _data				:Object;
		
		//button
		private var _saveBtn 			:feathers.controls.Button;
		private var _previewBtn     	:feathers.controls.Button;
		private var _publishBtn     	:feathers.controls.Button;
		private var _gameInfoBtn		:starling.display.Button;
		private var _charactersInfoBtn	:starling.display.Button;
		private var _glow				:BlurFilter	= BlurFilter.createGlow();
		private var _menuButton		:feathers.controls.Button;
		private var _menuScreen		: MenuScreen;
		
		//sound
		private var _soundObject		: SoundObject;
		
		//check whether the the create game screen is created
		//the problem happens when from the preview game to create game
		//we no need to addchild all the element
		private var _isCreated			:Boolean	=false;
		
		//need to pass in here the user 
		//defined image and question list
		public function CreateGameScreen(serverData:Object = null)	
		{		
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener('displayCharacters', onDisplayCharacter);
			this.addEventListener('startChoosingEndPt', onChoosingEndPt);
			this.addEventListener('GameFieldChanged', onGameFieldChange);
			this.addEventListener('popUpDisplay', onPopUpDisplayed);
			this.addEventListener('popUpClose', onPopUpClosed);
			this.addEventListener('removeEndPts', onRemoveEndPts);
			this.addEventListener(MENU_EVENT, onMenuEvent);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		//dispose the screen when wanna quit this create game screen
		//the reason that can not use remove from stage
		//because we must keep this screen for the preview
		//therefore we remove it whenever we quit to main menu
		public function disposeScreen():void
		{
			this.removeChild(this._obstaclePanel);
			this.removeChild(this._gridPanel);
			this.removeChild(this._componentPanel);
			this.removeChild(this._scoreBoard);
			this.removeChild(this._saveBtn);			
			this.removeChild(this._previewBtn);
			this.removeChild(this._publishBtn);
			this.removeChild(this._gameInfoBtn);
			this.removeChild(this._charactersInfoBtn);
			this.removeChild(this._menuButton);
			this.removeChild(this._menuScreen);
			
			this._obstaclePanel		= null;
			this._gridPanel  		= null;
			this._componentPanel	= null;
			this._scoreBoard		= null;
			this._saveBtn			= null;
			this._previewBtn		= null;
			this._publishBtn		= null;
			this._gameInfoBtn		= null;
			this._charactersInfoBtn	= null;
			this._menuButton		= null;
			this._menuScreen		= null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.removeEventListener('displayCharacters', onDisplayCharacter);
			this.removeEventListener('startChoosingEndPt', onChoosingEndPt);
			this.removeEventListener('GameFieldChanged', onGameFieldChange);
			this.removeEventListener('popUpDisplay', onPopUpDisplayed);
			this.removeEventListener('popUpClose', onPopUpClosed);
			this.removeEventListener(MENU_EVENT, onMenuEvent);
			this.removeEventListener(Event.TRIGGERED, onChangeMenu);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			
		}
		
		private function onPopUpDisplayed(event:Event):void{
			this.broadcastEventWith('gotPopUp');
		}
		
		private function onPopUpClosed(event:Event):void{
			this.broadcastEventWith('closedPopUp', event.data);
		}
		
		private function onRemoveEndPts(event:Event):void{
			this._gridPanel.removeEndPts(event.data.enemy);
		}
		
		private function onAddedToStage(event:Event):void{
			
			if(!this._isCreated){
				new MetalWorksMobileTheme();
				
				this._com					= new ServerClientManager();
				this._com.registerSaveGameCallBack(this.onSaveButtonTriggerCallBack);
				
				this._scoreBoard			= new CreateGameScoreBoard();
				
				//obstacle panel
				this._obstaclePanel        	= new ObstaclePanel(DRAG_FORMAT);
				this._obstaclePanel.width  	= 216;
				this._obstaclePanel.height 	= 400;
				this._obstaclePanel.x      	= Constant.INFOBOARD_POS.x + Constant.OBSBOARD_POS.x + 10; 
				this._obstaclePanel.y      	= Constant.INFOBOARD_POS.y + 100;
				
				//index grid panel
				this._gridPanel            	= new GridPanel(DRAG_FORMAT);
				this._gridPanel.width  	    = 440;
				this._gridPanel.height 	    = 360;
				this._gridPanel.x          	= Constant.GRID_CREATE_POS.x;
				this._gridPanel.y          	= Constant.GRID_CREATE_POS.y;
				
				//component right side panel
				this._componentPanel      	= new ComponentPanel();
				this._componentPanel.width 	= 440;
				this._componentPanel.height	= 600;
				this._componentPanel.x 		= Constant.INFOBOARD_POS.x;
				this._componentPanel.y		= 0;
				
				this._gameInfoBtn = new starling.display.Button(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture('Obstacles'));
				this._gameInfoBtn.x = Constant.INFOBOARD_POS.x + 18;
				this._gameInfoBtn.y = 17;
				this._gameInfoBtn.filter = this._glow;
				
				this._charactersInfoBtn = new starling.display.Button(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture('Characters'));
				this._charactersInfoBtn.x  = Constant.INFOBOARD_POS.x + 145;
				this._charactersInfoBtn.y = 17;
				
				//background
				var background:Image 		= new Image(Assets.getAtlas(Constant.BACKGROUND_SPRITE).getTexture('CreateBackground'));
				var gridFrame :Image      	= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture('CreateFrame'));	
				var rightBox  :Image      	= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.INFO_BOARD));
				
				gridFrame.x                 = Constant.FRAME_CREATE_POS.x;
				gridFrame.y 				= Constant.FRAME_CREATE_POS.y;
				rightBox.x   				= Constant.INFOBOARD_POS.x;
				rightBox.y 					= 0;
				
				//button
				this._saveBtn   		    = new feathers.controls.Button();
				this._saveBtn.useHandCursor	= true;
				this._saveBtn.x		 		= Constant.STARTB_POS.x;
				this._saveBtn.y 			= Constant.STARTB_POS.y;
				this._saveBtn.height	    = 45;
				this._saveBtn.width			= 130;
				this._saveBtn.label			= 'Save';
				
				this._previewBtn			= new feathers.controls.Button();
				this._previewBtn.useHandCursor	= true;
				this._previewBtn.x 			= Constant.PREVIEWB_POS.x;
				this._previewBtn.y 			= Constant.PREVIEWB_POS.y;
				this._previewBtn.height    	= 45;
				this._previewBtn.width    	= 130;
				this._previewBtn.label    	= 'Preview';
				
				this._publishBtn			= new feathers.controls.Button();
				this._publishBtn.useHandCursor	= true;
				this._publishBtn.x 			= Constant.PUBLISHB_POS.x;
				this._publishBtn.y 			= Constant.PUBLISHB_POS.y; 
				this._publishBtn.height    	= 45;
				this._publishBtn.width		= 130;
				this._publishBtn.label		= 'Publish';
				
				this._soundObject			= new SoundObject();
				this._soundObject.playBackgroundMusic(Constant.CREATE_GAME_SCREEN);
				
				this._menuButton				= new feathers.controls.Button();
				this._menuButton.label			= 'Option';
				this._menuButton.width			= 50;
				this._menuButton.height			= 50;
				this._menuButton.x				= 2;
				this._menuButton.y				= 2;
				
				this.addChild(background);
				this.addChild(gridFrame);
				this.addChild(rightBox);
				this.addChild(this._gameInfoBtn);
				this.addChild(this._charactersInfoBtn);
				this.addChild(this._saveBtn);
				this.addChild(this._previewBtn);
				this.addChild(this._publishBtn);
				this.addChild(this._gridPanel);
				this.addChild(this._componentPanel);
				this.addChild(this._obstaclePanel);
				this.addChild(this._scoreBoard);
				this.addChild(this._menuButton);
				
				this._componentPanel.alpha = 0;
				this._componentPanel.disableInput();
				
				this.addEventListener(Event.TRIGGERED, onChangeMenu);
				this._saveBtn.addEventListener(Event.TRIGGERED, onSaveBtnTrigger);
				this._previewBtn.addEventListener(Event.TRIGGERED, onPreviewBtnTrigger);
				this._publishBtn.addEventListener(Event.TRIGGERED, onPublishBtnTrigger);
				this._menuButton.addEventListener(Event.TRIGGERED, onMenuBtnTrigger);
				PreviewGameInfo._isSaved = false;
				this._isCreated	= true;
			}
			else{
			}
		}
		
		private function onChangeMenu(event:Event):void
		{
			var target	:starling.display.Button = event.target as starling.display.Button;
			if(target == this._gameInfoBtn)
			{
				this._gameInfoBtn.filter = this._glow;
				this._charactersInfoBtn.filter = null;
				this._obstaclePanel.alpha = 1;
				this._componentPanel.alpha = 0;
				this._componentPanel.disableInput();
				this._obstaclePanel.enableInput();
			}
			else if(target == this._charactersInfoBtn)
			{
				this._gameInfoBtn.filter = null;
				this._charactersInfoBtn.filter = this._glow;
				this._obstaclePanel.alpha = 0;
				this._componentPanel.alpha = 1;
				this._obstaclePanel.disableInput();
				this._componentPanel.enableInput();
			}
		}
		
		private function onGameFieldChange(event:Event):void
		{
			var bg	:Image;
			if(event.data.isUserDef)
				bg = new Image(Assets.getUserScreenTexture()[event.data.textureIndex].texture);
			else
				bg = new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture("Stage"+event.data.textureIndex+"Screen"));
			
			this._gridPanel.changeBackground(bg);
		}
		
		private function onDisplayCharacter(event:Event):void{
			this._gridPanel.onShowCharacterEvent(event.data);
		}
		
		private function onChoosingEndPt(event:Event):void{
			this._gridPanel.startChoosingEndPt(event.data);
		}
		
		private function onSaveBtnTrigger(event:Event):void
		{
			var data:Object = new Object();
			var enemy:Array = this._componentPanel.getEnemyInfo();
			enemy[0].endPts = [].concat(this._gridPanel.Enemy1EndPts);
			enemy[1].endPts = [].concat(this._gridPanel.Enemy2EndPts);
			
			data.id 		= Assets.gameID;
			data.title 		= this._componentPanel.getTitle();
			data.player		= this._componentPanel.getPlayerInfo();
			data.enemy		= enemy;
			data.obstacles	= this._gridPanel.getObsList();
			data.screen		= this._scoreBoard.getScreen();
			data.scoreboard	= this._scoreBoard.getScoreBoardInfo();
			data.screenShot = this.takeScreenShot(DisplayObject(this._gridPanel));

			//send to server this information whenever the 
			//save game button is clicked, all the information will be stored on server
			
			this._com.saveUserGameCreation(data, onSaveButtonTriggerCallBack);
		}
		
		private function onSaveButtonTriggerCallBack(data: String):void
		{
			Assets.gameID	= data;
		}
		
		private function onPreviewBtnTrigger(event:Event):void
		{	
			/* Check invalid information */
			/* Player does not have position */
			/* Enemy got type but does not have position */
			var alert : Alert;
			if(this._componentPanel.getPlayerInfo().pos == 0)
			{
				alert = Alert.show("Please give Player a start position.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				alert.addEventListener(Event.CLOSE, function(e:Event):void{
					_componentPanel.setPosFocus(0);
				});
				return;
			}
			if(this._componentPanel.getEnemyInfo()[0].type != "None" && this._componentPanel.getEnemyInfo()[0].pos == 0)
			{
				alert = Alert.show("Please give Enemy1 a start position.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				alert.addEventListener(Event.CLOSE, function(e:Event):void{
					_componentPanel.setPosFocus(1);
				});
				return;
			}
			if(this._componentPanel.getEnemyInfo()[1].type != "None" && this._componentPanel.getEnemyInfo()[1].pos == 0)
			{
				alert = Alert.show("Please give Enemy 2 a start position.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				alert.addEventListener(Event.CLOSE, function(e:Event):void{
					_componentPanel.setPosFocus(2);
				});
				return;
			}
			
			if(!this._gridPanel.hasGoal)
			{
				alert = Alert.show("There is no 'Goal'.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				return;
			}
			PreviewGameInfo._gameTitle = "Preview Game";
			PreviewGameInfo._gameScreen.isUserDef = this._scoreBoard.getScreen().isUserDef;
			PreviewGameInfo._gameScreen.textureIndex = this._scoreBoard.getScreen().textureIndex;
			PreviewGameInfo.storeObstaclesInfo(this._gridPanel.getObsList());
			PreviewGameInfo.storePlayerInfo(this._componentPanel.getPlayerInfo());
			PreviewGameInfo.storeScoreInfo(this._scoreBoard.getScoreBoardInfo());
			PreviewGameInfo.storeEnemyInfo(this._componentPanel.getEnemyInfo(), this._gridPanel.Enemy1EndPts, this._gridPanel.Enemy2EndPts);
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.CREATE_GAME_SCREEN, to : Constant.PLAY_SCREEN}, true));
		}
		
		private function onPublishBtnTrigger(event:Event):void
		{
			/* Check invalid information */
			/* Player does not have position */
			/* Enemy got type but does not have position */
			var alert : Alert;
			if(this._componentPanel.getPlayerInfo().pos == 0)
			{
				alert = Alert.show("Please give Player a start position.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				alert.addEventListener(Event.CLOSE, function(e:Event):void{
					_componentPanel.setPosFocus(0);
				});
				return;
			}
			if(this._componentPanel.getEnemyInfo()[0].type != "None" && this._componentPanel.getEnemyInfo()[0].pos == 0)
			{
				alert = Alert.show("Please give Enemy1 a start position.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				alert.addEventListener(Event.CLOSE, function(e:Event):void{
					_componentPanel.setPosFocus(1);
				});
				return;
			}
			if(this._componentPanel.getEnemyInfo()[1].type != "None" && this._componentPanel.getEnemyInfo()[1].pos == 0)
			{
				alert = Alert.show("Please give Enemy 2 a start position.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				alert.addEventListener(Event.CLOSE, function(e:Event):void{
					_componentPanel.setPosFocus(2);
				});
				return;
			}
			
			if(!this._gridPanel.hasGoal)
			{
				alert = Alert.show("There is no 'Goal'.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				return;
			}
			
			var titlePanel	:Panel = new Panel();
			titlePanel.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Title";
				return header;
			}
			titlePanel.x = 150;
			titlePanel.y = 150;
			
			titlePanel.width = 500;
			titlePanel.height = 250;
				
			var title	:TextInput = new TextInput();
			title.x = 100;
			title.width = 300;
			title.height = 50;
			title.textEditorProperties.@fontSize = 30;
			titlePanel.addChild(title);
			
			var closeButton :feathers.controls.Button = new feathers.controls.Button();
			closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void {
				if(title.text != null)
					publishData(titlePanel, title.text);
			});
			closeButton.x = 225;
			closeButton.y = 100;
			closeButton.label = "Ok";
			titlePanel.addChild(closeButton);
			this.addChild(titlePanel);
		}
		
		private function publishData(panel:Panel, title:String):void
		{
			this.removeChild(panel);
			
			var data:Object = new Object();
			var enemy:Array = this._componentPanel.getEnemyInfo();
			enemy[0].endPts = [].concat(this._gridPanel.Enemy1EndPts);
			enemy[1].endPts = [].concat(this._gridPanel.Enemy2EndPts);
			
			data.id 		= Assets.gameID;
			data.title 		= title;
			data.player		= this._componentPanel.getPlayerInfo();
			data.enemy		= enemy;
			data.obstacles	= this._gridPanel.getObsList();
			data.screen		= this._scoreBoard.getScreen();
			data.scoreboard	= this._scoreBoard.getScoreBoardInfo();
			data.screenShot = this.takeScreenShot(DisplayObject(this._gridPanel));
			this._com.publishGame(data);
			this.resetGameCreation();
		}
		
		//change the xindex and yindex inside the 2D array
		//into the grid index in the screen
		private function decodeGridIndex(xIndex:Number, yIndex:Number):Number
		{	
			return xIndex + yIndex*11 + 1;
		}
		
		//take the screen shot
		private function takeScreenShot(disp : DisplayObject, scl:Number=1.0):String
		{
			var rc:Rectangle = new Rectangle();
			disp.getBounds(disp, rc);
			
			var stage:Stage= Starling.current.stage;
			var rs:RenderSupport = new RenderSupport();
			
			rs.clear();
			rs.scaleMatrix(scl, scl);
			rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
			rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
			disp.render(rs, 1.0);
			rs.finishQuadBatch();
			
			var outBmp:BitmapData = new BitmapData(rc.width*scl, rc.height*scl, true);
			Starling.context.drawToBitmapData(outBmp);
			
			return this.convertToBase64Encode(outBmp);
		}
		
		private function convertToBase64Encode(bitmap:BitmapData):String
		{	
			var base64:Base64Encoder = new Base64Encoder();
			base64.encodeBytes(PNGEncoder.encode(bitmap));
			
			return base64.toString();
		}
		
		private function onMenuBtnTrigger(event:Event):void
		{
			//create a new menu screen each time press 
			//show menu button
			this._menuScreen	=	new MenuScreen(Constant.CREATE_GAME_SCREEN);
			this.addChild(this._menuScreen);	
		}
		
		private function onMenuEvent(event:Event):void
		{
			switch(event.data.event){
				case RESUME_GAME_EVENT:
					this.removeChild(this._menuScreen);
					this._menuScreen	= null;
					break;
				case QUIT_GAME_EVENT:
					Starling.current.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {from : Constant.CREATE_GAME_SCREEN, to :Constant.NAVIGATION_SCREEN}, true));
					break;
				case RESET_GAME_CREATION_EVENT:
					resetGameCreation();
					break;
			}
		}
		
		private function resetGameCreation():void
		{
			this._componentPanel.reset();
			this._gridPanel.reset();
			this._scoreBoard.reset();
		}
	}
}