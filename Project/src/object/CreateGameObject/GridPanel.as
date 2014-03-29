package object.CreateGameObject
{
	import assets.Assets;
	
	import constant.Constant;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDropTarget;
	import feathers.events.DragDropEvent;
	
	import flash.utils.ByteArray;
	
	import object.CreateGameObject.GridObj;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GridPanel extends LayoutGroup implements IDropTarget
	{
		private var _dragFormat    	: String;
		private var _background    	: Image;
		private var _indexBg       	: Image;
		private var _gridObjects   	: Vector.<Vector.<GridObj>>;
		private var _questionList  	: Vector.<Object>;
		private var _gridOptionPanel	: GridOptionPanel;
		private var _curGridObjSelect 	: GridObj;
		
		//check whether the option panel box has been opene or not
		private var _state            	: Number;
		
		public function GridPanel(dragFormat : String)
		{
			this._dragFormat  		= dragFormat;

			//test questiin added for user
			this._questionList		= new Vector.<Object>();
			for(var i:uint = 0 ; i < 10 ; i++){
				
				var question:Object   	= new Object();
				question.title = 'question' + i;
				this._questionList.push(question);
			}			
			
			//register event handler
			this.addEventListener(DragDropEvent.DRAG_ENTER, onDragEnter);
			this.addEventListener(DragDropEvent.DRAG_EXIT,  onDragExit);
			this.addEventListener(DragDropEvent.DRAG_DROP,  onDragDrop);
			
			//custom event handler
			this.addEventListener('GridOptionDeleteBtnClicked', onDeleteBtnClick);
			this.addEventListener('GridOptionCloseBtnClicked', onCloseBtnClick);
			this.addEventListener('GridOptionChangeBtnClicked', onGridChangeClick);
			
			//keep track of the click from user on touch event
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function getGridList():Vector.<Vector.<GridObj>>{
			return this._gridObjects;
		}
		
		override protected function initialize():void{
			
			//create a new quad background
			this._background       = new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture('WaterScreen'));
			this._indexBg          = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.GRID_IMG));
			this.initGridObjects();
			this._gridOptionPanel  = new GridOptionPanel(this._questionList);
			this._state				= 0;
			
			
			//add child to display
			this.addChildAt(this._background, 0);
			this.addChildAt(this._indexBg, 1);
			this.addChild(this._gridOptionPanel);
		}
		
		override protected function draw():void{
			
			super.draw();
			
			this._background.width  = this.actualWidth;
			this._background.height = this.actualHeight;
			this._indexBg.width     = this.actualWidth;
			this._indexBg.height    = this.actualHeight;
		}
		
		private function onDragEnter(event:DragDropEvent, dragData:DragData):void
		{
			if(!dragData.hasDataForFormat(this._dragFormat))
			{
				return;
			}
			
			DragDropManager.acceptDrag(this);
		}
		
		private function onDragExit(event:DragDropEvent, dragData:DragData):void
		{
		}
		
		//event happen when the object is dropped inside the drop range
		private function onDragDrop(event:DragDropEvent, dragData:DragData):void
		{

			var dataReturn:ObstacleObj 			= dragData.getDataForFormat(this._dragFormat);
			var xPos:Number 					= event.localX;
			var yPos:Number 					= event.localY;

			var squareSize	:int 				= 40;
			var xIndex	   	:int 	 			= int(xPos/40);
			var yIndex		:int   				= int(yPos/40);
			
			var droppedObject:ObstacleObj  		= new ObstacleObj(dataReturn.texture, dataReturn.isUserDefText, dataReturn.textureIndex);
			droppedObject.obstacleType          = dataReturn.obstacleType;
			
			//check out of index
			if(xIndex < 11 && yIndex < 9){
				
				//if not then add child to the grid object
				this._gridObjects[xIndex][yIndex].changeStateToObstacle(droppedObject);
			}
		}
		
		//arrange the object into grids that can be used
		//to addin the texture from drag and drop event
		private function initGridObjects():void{
			
			var x:Number = 0;
			var y:Number = 0;
			
			this._gridObjects = new Vector.<Vector.<GridObj>>();
			
			for(var i:Number=0; i<11; i++)
			{
				this._gridObjects[i] = new Vector.<GridObj>();
				
				y = 0;
				for(var j:Number=0; j<9;j++)
				{
					
					//create a new gridObject 
					//and assign the position to each grid
					this._gridObjects[i][j]    	   	= new GridObj();
					this._gridObjects[i][j].x      	= x;
					this._gridObjects[i][j].y 	   	= y;
					
					//add child to stage
					this.addChild(this._gridObjects[i][j]);
					
					//increase the column to 40 for the next grid
					y += 40;
				}
				
				//increase row position by 40
				x += 40;
			}
		}
		
		
		private function onTouch(event:TouchEvent):void{
			
			var touch:Touch = event.getTouch(this);
			
			if(touch){
				
				if(touch.phase == TouchPhase.ENDED){
					
					//return if a grid option panel is opened
					if(this._state == 1)
						return;
					
					//fix the bug when option panel on other object
					if(event.target is Button)
						return;
						
					//dont know why like this
					var xPos:Number 					= touch.globalX - 40;
					var yPos:Number 					= touch.globalY - 57;

					var xIndex	   	:int 	 			= int(xPos/40);
					var yIndex		:int   				= int(yPos/40);
					
					//check in range
					if(xIndex < 11 && yIndex < 9){
						this._curGridObjSelect			= this._gridObjects[xIndex][yIndex];
	
						if(this._curGridObjSelect.state == 1){
							
							this._state = 1;
							
							var optionPanelX: Number      	= (xIndex+1)*40;
							var optionPanelY: Number 		= yIndex*40;
							var obstacleType: Number		= this._curGridObjSelect.getObstacle().obstacleType;

							this._gridOptionPanel.changeStateGrid(2, optionPanelX, optionPanelY, this._curGridObjSelect.selectedIndex);
						}
					}
				}
			}
		}
		
		private function onCloseBtnClick(event:Event):void
		{
			
			//change the state of gridoptionpanel to 0
			//alow user to click on other grid
			this._state = 0;
		}
		
		
		private function onDeleteBtnClick(event:Event):void
		{	
			//change the state of the current grid to normal
			//reset the state of the  whole panel 
			//so user can select another grid
			this._curGridObjSelect.changeStateToNormal();
			this._state = 0;
		}
		
		private function onGridChangeClick(event:Event):void
		{
			//set the current selected grid with the selected index
			//question from user
			this._curGridObjSelect.selectedIndex = event.data.index;
		}
		
		private function setPatrolEnemyPoints():void
		{
			//Check if there is any 'patrol' enemy
			//If not return
			//else take in the position (x,y)
			//Check if x==enemy.x or y==enemy.y
			//if not return
			//else check if any object in between (check walkable)
		}
	}
}