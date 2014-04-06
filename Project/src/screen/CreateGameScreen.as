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
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	
	public class CreateGameScreen extends Sprite
	{	
		private static const DRAG_FORMAT:String = 'draggableQuad';
		
		private var _obstaclePanel  	:ObstaclePanel;
		private var _gridPanel      	:GridPanel;
		private var _componentPanel 	:ComponentPanel;
		private var _scoreBoard		:CreateGameScoreBoard;
		private var _com				:ServerClientManager;
		
		private var _data				:Object;
		
		//button
		private var _saveBtn 			:Button;
		private var _previewBtn     	:Button;
		private var _publishBtn     	:Button;
		
		//sound
		private var _soundObject		: SoundObject;
		
		//need to pass in here the user 
		//defined image and question list
		public function CreateGameScreen(serverData:Object = null)	
		{
			if(serverData){
				//if got the server data then decode it into grids here		
			}		
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener('displayCharacters', onDisplayCharacter);
			this.addEventListener('startChoosingEndPt', onChoosingEndPt);
			this.addEventListener('GameFieldChanged', onGameFieldChange);
		}
		
		private function onAddedToStage(event:Event):void{
			
			new MetalWorksMobileTheme();
			
			this._com					= new ServerClientManager();
			
			this._scoreBoard			= new CreateGameScoreBoard();
			
			//obstacle panel
			this._obstaclePanel        	= new ObstaclePanel(DRAG_FORMAT);
			this._obstaclePanel.width  	= 216;
			this._obstaclePanel.height 	= 190;
			this._obstaclePanel.x      	= Constant.INFOBOARD_POS.x + Constant.OBSBOARD_POS.x + 10; 
			this._obstaclePanel.y      	= Constant.INFOBOARD_POS.y + Constant.OBSBOARD_POS.y;
			
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
			
			//background
			var background:Image 		= new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('background'));
			var gridFrame :Image      	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.FRAME_IMG));	
			var rightBox  :Image      	= new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.INFO_BOARD));
			
			gridFrame.x                 = Constant.FRAME_CREATE_POS.x;
			gridFrame.y 				= Constant.FRAME_CREATE_POS.y;
			rightBox.x   				= Constant.INFOBOARD_POS.x;
			rightBox.y 					= 0;
			
			//button
			this._saveBtn   		    = new Button();
			this._saveBtn.useHandCursor	= true;
			this._saveBtn.x		 		= Constant.STARTB_POS.x;
			this._saveBtn.y 			= Constant.STARTB_POS.y;
			this._saveBtn.height	    = 45;
			this._saveBtn.width			= 130;
			this._saveBtn.label			= 'Save';
			
			this._previewBtn			= new Button();
			this._previewBtn.useHandCursor	= true;
			this._previewBtn.x 			= Constant.PREVIEWB_POS.x;
			this._previewBtn.y 			= Constant.PREVIEWB_POS.y;
			this._previewBtn.height    	= 45;
			this._previewBtn.width    	= 130;
			this._previewBtn.label    	= 'Preview';
			
			this._publishBtn			= new Button();
			this._publishBtn.useHandCursor	= true;
			this._publishBtn.x 			= Constant.PUBLISHB_POS.x;
			this._publishBtn.y 			= Constant.PUBLISHB_POS.y; 
			this._publishBtn.height    	= 45;
			this._publishBtn.width		= 130;
			this._publishBtn.label		= 'Publish';
			
			this._soundObject			= new SoundObject();
			this._soundObject.playBackgroundMusic(Constant.CREATE_GAME_SCREEN);
			
			this.addChild(background);
			this.addChild(gridFrame);
			this.addChild(rightBox);
			this.addChild(this._saveBtn);
			this.addChild(this._previewBtn);
			this.addChild(this._publishBtn);
			this.addChild(this._componentPanel);
			this.addChild(this._obstaclePanel);
			this.addChild(this._gridPanel);
			this.addChild(this._scoreBoard);
			this.addChild(this._soundObject);
			
			this._saveBtn.addEventListener(Event.TRIGGERED, onSaveBtnTrigger);
			this._previewBtn.addEventListener(Event.TRIGGERED, onPreviewBtnTrigger);
			this._publishBtn.addEventListener(Event.TRIGGERED, onPublishBtnTrigger);
		}
		
		private function onGameFieldChange(event:Event):void{
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
			data.id 		= null;
			data.title 		= this._componentPanel.getTitle();
			data.player		= this._componentPanel.getPlayerInfo();
			data.enemy		= this._componentPanel.getEnemyInfo();
			data.obstacles	= this._gridPanel.getObsList();
			data.screen		= this._scoreBoard.getScreen();
			data.scoreboard	= this._scoreBoard.getScoreBoardInfo();
			data.screenShot = this.takeScreenShot(DisplayObject(this._gridPanel));
			
			//send to server this information whenever the 
			//save game button is clicked, all the information will be stored on server
			this._com.saveUserGameCreation(data);
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
			
			var data:Object = new Object();
			data.id 		= null;
			data.title 		= this._componentPanel.getTitle();
			data.player		= this._componentPanel.getPlayerInfo();
			data.enemy		= this._componentPanel.getEnemyInfo();
			data.obstacles	= this._gridPanel.getObsList();
			data.screen		= this._scoreBoard.getScreen();
			data.scoreboard	= this._scoreBoard.getScoreBoardInfo();
			data.screenShot = this.takeScreenShot(DisplayObject(this._gridPanel));
			this._com.publishGame(data);
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
	}
}