package object.CreateGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import com.adobe.base64.Base64Encoder;
	import com.adobe.images.PNGEncoder;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
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
	
	public class CreateGameBoard extends Sprite
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
		public function CreateGameBoard(serverData:Object = null)	
		{
			if(serverData){
				//if got the server data then decode it into grids here		
			}		
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener('displayCharacters', onDisplayCharacter);
			this.addEventListener('startChoosingEndPt', onChoosingEndPt);
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
		
		private function onDisplayCharacter(event:Event):void{
			this._gridPanel.onShowCharacterEvent(event.data);
		}
		
		private function onChoosingEndPt(event:Event):void{
			this._gridPanel.startChoosingEndPt(event.data);
		}
		
		private function onSaveBtnTrigger(event:Event):void
		{
			//what need here
			var dataReturn:Vector.<Object> 			= new Vector.<Object>();;
			var gridObj:Vector.<Vector.<GridObj>> 	= this._gridPanel.getGridList();
			
			for(var i:uint = 0 ; i < gridObj.length ; i++){
				
				for(var j:uint = 0; j < gridObj[i].length ; j++){
					
					if(gridObj[i][j].state == 1){
						
						var obj:Object 		= {};
						obj.index 			= this.decodeGridIndex(i,j);
						obj.isUserDefText 	= gridObj[i][j].getObstacle().isUserDefText;
						obj.textureIndex 	= gridObj[i][j].getObstacle().textureIndex;
						obj.type  			= gridObj[i][j].getObstacle().obstacleType;
						
						dataReturn.push(obj);
					}
				}
			}
			
			//take a screen shot first 
			var screenShot:String = this.takeScreenShot(DisplayObject(this._gridPanel));
			
			//push the screenshot object inside the screen
			dataReturn.push({screen : screenShot});
			
			//send to server this information whenever the 
			//save game button is clicked, all the information will be stored on server
			this._com.saveUserGameCreation(dataReturn);
		}
		
		private function onPreviewBtnTrigger(event:Event):void
		{			
			PreviewGameInfo.storeObstaclesInfo(this._gridPanel.getObsList());
			PreviewGameInfo.storePlayerInfo(this._componentPanel.getPlayerInfo());
			PreviewGameInfo.storeScoreInfo(this._scoreBoard.getScoreBoardInfo());
			PreviewGameInfo.storeEnemyInfo(this._componentPanel.getEnemyInfo(), this._gridPanel.Enemy1EndPts, this._gridPanel.Enemy2EndPts);
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.PREVIEW_LOADER}, true));
		}
		
		private function onPublishBtnTrigger(event:Event):void
		{
			//store ScoreBoard
			//store Obstacles
			//store Enemies
			//store Player
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