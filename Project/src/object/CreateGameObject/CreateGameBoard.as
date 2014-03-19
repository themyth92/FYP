package object.CreateGameObject
{
	import assets.Assets;
	
	import constant.Constant;
	
	import feathers.controls.Button;
	import feathers.themes.MetalWorksMobileTheme;
	
	import object.CreateGameObject.GridPanel;
	import object.CreateGameObject.ObstacleObj;
	import object.CreateGameObject.ObstaclePanel;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class CreateGameBoard extends Sprite
	{	
		private static const DRAG_FORMAT:String = 'draggableQuad';
		
		private var _obstaclePanel  :ObstaclePanel;
		private var _gridPanel      :GridPanel;
		
		//button
		private var _saveBtn 		 :Button;
		private var _previewBtn     :Button;
		private var _publishBtn     :Button;
		
		//need to pass in here the user 
		//defined image and question list
		public function CreateGameBoard()	
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void{
			
			new MetalWorksMobileTheme();
			
			//obstacle panel
			this._obstaclePanel        	= new ObstaclePanel(DRAG_FORMAT);
			this._obstaclePanel.width  	= 255;
			this._obstaclePanel.height 	= 420;
			this._obstaclePanel.x      	= Constant.INFOBOARD_POS.x + Constant.OBSBOARD_POS.x; 
			this._obstaclePanel.y      	= Constant.INFOBOARD_POS.y + Constant.OBSBOARD_POS.y;
			
			//index grid panel
			this._gridPanel            	= new GridPanel(DRAG_FORMAT);
			this._gridPanel.width  	    = 440;
			this._gridPanel.height 	    = 360;
			this._gridPanel.x          	= Constant.GRID_CREATE_POS.x;
			this._gridPanel.y          	= Constant.GRID_CREATE_POS.y;
	
			//background
			var background:Image 		= new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('background'));
			var gridFrame :Image      	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.FRAME_IMG));	
			var rightBox  :Image      	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INFOBOARD_IMG));
			
			gridFrame.x                 = Constant.FRAME_CREATE_POS.x;
			gridFrame.y 				= Constant.FRAME_CREATE_POS.y;
			rightBox.x   				= Constant.INFOBOARD_POS.x;
			rightBox.y 					= Constant.INFOBOARD_POS.y;
			
			//button
			this._saveBtn   		    = new Button();
			this._saveBtn.x		 		= Constant.STARTB_POS.x;
			this._saveBtn.y 			= Constant.STARTB_POS.y;
			this._saveBtn.height	    = 45;
			this._saveBtn.width			= 130;
			this._saveBtn.label			= 'Save';
			
			this._previewBtn			= new Button();
			this._previewBtn.x 			= Constant.PREVIEWB_POS.x;
			this._previewBtn.y 			= Constant.PREVIEWB_POS.y;
			this._previewBtn.height    	= 45;
			this._previewBtn.width    	= 130;
			this._previewBtn.label    	= 'Preview';
			
			this._publishBtn			= new Button();
			this._publishBtn.x 			= Constant.PUBLISHB_POS.x;
			this._publishBtn.y 			= Constant.PUBLISHB_POS.y; 
			this._publishBtn.height    	= 45;
			this._publishBtn.width		= 130;
			this._publishBtn.label		= 'Publish';
			
			
			this.addChild(background);
			this.addChild(gridFrame);
			this.addChild(rightBox);
			this.addChild(this._saveBtn);
			this.addChild(this._previewBtn);
			this.addChild(this._publishBtn);
			this.addChild(this._gridPanel);
			this.addChild(this._obstaclePanel);
 		}
	}
}