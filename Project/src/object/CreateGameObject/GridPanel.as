package object.CreateGameObject
{
	import assets.Assets;
	
	import constant.Constant;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.data.ListCollection;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDropTarget;
	import feathers.events.DragDropEvent;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import object.CreateGameObject.GridObj;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class GridPanel extends LayoutGroup implements IDropTarget
	{
		private var _dragFormat    		: String;
		private var _background    		: Image;
		private var _indexBg       		: Image;
		private var _gridObjects   		: Vector.<Vector.<GridObj>>;
		private var _questionList  		: Vector.<Object>;
		private var _gridOptionPanel	: GridOptionPanel;
		private var _curGridObjSelect 	: GridObj;
		
		private var _occupiedList		: Vector.<Object>;
		private var _enemy1Img			: Image;
		private var _enemy2Img			: Image;
		private var _enemy				: Object;
		private var _playerImg			: Image;
		private var _chooseableList		: Vector.<Object>;
		private var _enemy1EndPts		: Vector.<Number>;
		private var _enemy2EndPts		: Vector.<Number>;
		private var _isChoosing			: Boolean = false;
		private var _endPtAmount		: Number;
		private var _currEndPt			: Object;
		private var _endPtNotifier		: TextField;
		
		//check whether the option panel box has been opene or not
		private var _state            	: Number;
		
		public function GridPanel(dragFormat : String)
		{
			this._dragFormat  		= dragFormat;

			//test questiin added for user
			this._questionList		= new Vector.<Object>();
			this._occupiedList		= new Vector.<Object>();
			this._chooseableList	= new Vector.<Object>();
			this._enemy1EndPts		= new Vector.<Number>();
			this._enemy2EndPts		= new Vector.<Number>();
			
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
		
		public function getObsList():Array{
			var list		:Array = new Array();
			for(var i:Number =0; i<11;i++)
			{
				for(var j:Number=0; j<9; j++)
				{
					if(this._gridObjects[i][j].getObstacle()!= null)
					{
						var obj			:Object = new Object();
						obj.textureIndex = this._gridObjects[i][j].getObstacle().textureIndex;
						obj.isUserDef = this._gridObjects[i][j].getObstacle().isUserDefText;
						obj.pos = (i+1)+(j*11);
						obj.type = this._gridObjects[i][j].getObstacle().obstacleType;
						list.push(obj);
					}
				}
			}
			return list;
		}
		
		public function getGridList():Vector.<Vector.<GridObj>>{
			return this._gridObjects;
		}
		
		public function get Enemy1EndPts():Vector.<Number>{
			return this._enemy1EndPts;
		}
		
		public function get Enemy2EndPts():Vector.<Number>{
			return this._enemy2EndPts;
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
			
			if(!checkOccupiedByCharacters(yIndex, xIndex))
			{
				//alert something
				return;
			}
			
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
					this._gridObjects[i][j]    	   		= new GridObj();
					this._gridObjects[i][j].x      		= x;
					this._gridObjects[i][j].y 	   		= y;
					
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
			
		public function onShowCharacterEvent(data:Object):void
		{
			if(data.id != undefined)
			{
				var pos		:Object = indexToPoints(data.pos);
				var yIndex	:Number = pos.row;
				var xIndex	:Number = pos.column;
				
				if(data.id == "enemy1")
				{
					this.removeChild(this._enemy1Img);
					this._enemy1Img = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Enemy/Enemy_" + data.textureIndex));
					this._enemy1Img.x = xIndex*40;
					this._enemy1Img.y = yIndex*40;
					
					this._currEndPt = new Object();
					this._currEndPt.row = yIndex;
					this._currEndPt.column = xIndex;
					this._currEndPt.counter = 1;
					
					this._enemy = new Object();
					this._enemy.row = yIndex;
					this._enemy.column = xIndex;
					this._enemy.type = "enemy1";
					this.addChild(this._enemy1Img);
				}
				else if(data.id == "enemy2")
				{
					this.removeChild(this._enemy2Img);
					this._enemy2Img = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Enemy/Enemy_" + data.textureIndex));
					this._enemy2Img.x = xIndex*40;
					this._enemy2Img.y = yIndex*40;
					this._enemy2EndPts.push(data.pos);
					
					this._currEndPt = new Object();
					this._currEndPt.row = yIndex;
					this._currEndPt.column = xIndex;
					this._currEndPt.counter = 1;
					
					this._enemy = new Object();
					this._enemy.row = yIndex;
					this._enemy.column = xIndex;
					this._enemy.type = "enemy2";
					this.addChild(this._enemy2Img);
				}
				else
				{
					this.removeChild(this._playerImg);
					if(data.gender)
						this._playerImg = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Player - Male/male_down_01"));
					else
						this._playerImg = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Player - Female/female_down_01"));
					
					this._playerImg.x = xIndex*40;
					this._playerImg.y = yIndex*40;
					this.addChild(this._playerImg);
				}
				
				var occupiedPt :Object = new Object();
				occupiedPt.row = yIndex;
				occupiedPt.column = xIndex;
				this._occupiedList.push(occupiedPt);
			}
		}
		
		public function startChoosingEndPt(data:Object):void
		{
			this._endPtNotifier = new TextField(500, 100, null, "Grobold", 20, 0x111111, false);
			this._endPtNotifier.y = 450;
			this.addChild(this._endPtNotifier);
			
			var index :Number = data.pos;
			setupForEndPtChoosing(index);
			this._endPtAmount = data.option;
			this._endPtNotifier.text = "Please choose end point No." + this._currEndPt;
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(TouchEvent.TOUCH, onChoosingEndTouch);
		}
		
		private function onChoosingEndTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			if(touch)
			{	
				if(touch.phase == TouchPhase.ENDED)
				{
					var xPos:Number 					= touch.globalX - 40;
					var yPos:Number 					= touch.globalY - 57;
					
					var xIndex	   	:int 	 			= int(xPos/40);
					var yIndex		:int   				= int(yPos/40);
					
					for(var i:uint = 0; i< this._chooseableList.length; i++)
					{
						//Check from the chooseable List
						//If the touched tiles is in the list, save the tile
						//Else error
						if(xIndex == this._chooseableList[i].column && yIndex == this._chooseableList[i].row)
						{
							//Found the tiles in the list
							//Convert to Point for IndexBoard processing in game
							var savedPt	:Number = xIndex + (yIndex*11)+1;
							trace(savedPt);
							if(this._enemy.type == "enemy1")
								this._enemy1EndPts.push(savedPt);
							else
								this._enemy2EndPts.push(savedPt);
							
							//Add this point the the occupied list so that user cannot add object into these tiles
							setOccupiedList(xIndex, yIndex);
							
							//Setup for next points choosing
							clearQuad();
							highlightOccupiedTiles();
							
							if(xIndex == this._currEndPt.column)
								setupNextEndPt("row", (xIndex+(yIndex*11))+1);
							else
								setupNextEndPt("column", (xIndex+(yIndex*11))+1);
							
							//Process to next points
							this._currEndPt.column = xIndex;
							this._currEndPt.row = yIndex;
							this._currEndPt.counter ++;
							
							//If reached number of Points required, end
							if(this._currEndPt.counter <= this._endPtAmount)
								this._endPtNotifier.text = "Please choose end point No." + this._currEndPt.counter;
							else
							{
								trace(this._enemy1EndPts);
								clearQuad();
								setOccupiedList(this._enemy.column, this._enemy.row);
								highlightOccupiedTiles();
								this.removeChild(this._endPtNotifier);
								Alert.show("You've done choosing end points for enemy.", "Notification", new ListCollection(
									[
										{ label: "OK" }
									]));
								this.removeEventListener(TouchEvent.TOUCH, onChoosingEndTouch);
								this.addEventListener(TouchEvent.TOUCH, onTouch);
							}
							return;
						}
					}
					Alert.show("Please choose only from the highlighted tiles.", "Error", new ListCollection(
						[
							{ label: "OK" }
						]));
					return;
				}
			}
		}
		
		private function setOccupiedList(xIndex:Number, yIndex:Number):void{
			var occupiedPt :Object;
			if(xIndex == this._currEndPt.column)
			{
				for(var i:uint=1; i<=Math.abs(this._currEndPt.row - yIndex); i++)
				{
					occupiedPt = new Object();
					occupiedPt.row = this._currEndPt.row + i*((yIndex - this._currEndPt.row)/Math.abs(this._currEndPt.row - yIndex));
					occupiedPt.column = xIndex;
					this._occupiedList.push(occupiedPt);
				}
			}
			else if(yIndex == this._currEndPt.row)
			{
				for(var j:uint=1; j<=Math.abs(this._currEndPt.column - xIndex); j++)
				{
					occupiedPt = new Object();
					occupiedPt.column = this._currEndPt.column + j*((xIndex - this._currEndPt.column)/Math.abs(this._currEndPt.column - xIndex));
					occupiedPt.row = yIndex;
					this._occupiedList.push(occupiedPt);
				}
			}
		}
		
		private function highlightOccupiedTiles():void
		{
			var column	:Number;
			var row		:Number;
			for(var i:uint=0; i<this._occupiedList.length; i++)
			{
				column = this._occupiedList[i].column;
				row = this._occupiedList[i].row;
				this._gridObjects[column][row].setQuadColor(0xf90000);
				this._gridObjects[column][row].setQuadAlpha(1);
			}
		}
		
		private function clearQuad():void{
			for(var k:Number=0; k<11; k++)
			{
				for(var j:Number=0; j<9;j++)
					this._gridObjects[k][j].setQuadAlpha(0);
			}
		}
		
		private function setupNextEndPt(type:String, index:Number):void
		{
			var points	:Object = indexToPoints(index);
			var savePt	:Object;
			var column	:Number = points.column;
			var row		:Number = points.row;
			
			this._chooseableList.length = 0;
			
			if(type == "column")
			{
				for(var m:Number = row-1; m >= 0; m--)
				{
					if(this._gridObjects[column][m].getObstacle() == null)
					{
						savePt = new Object();
						savePt.row = m;
						savePt.column = column;
						this._chooseableList.push(savePt);
						this._gridObjects[column][m].setQuadAlpha(0.5);
					}
					else
						break;
				}
				
				
				for(var n:uint = row+1; n < 9; n++)
				{
					if(this._gridObjects[column][n].getObstacle() == null)
					{
						savePt = new Object();
						savePt.row = n;
						savePt.column = column;
						this._chooseableList.push(savePt);
						this._gridObjects[column][n].setQuadAlpha(0.5);
					}
					else
						break;
				}
			}
			else if(type == "row")
			{
				for(var i:Number = column-1; i >= 0; i--)
				{
					if(this._gridObjects[i][row].getObstacle() == null)
					{
						savePt = new Object();
						savePt.row = row;
						savePt.column = i;
						this._chooseableList.push(savePt);
						this._gridObjects[i][row].setQuadAlpha(0.5);
					}
					else
						break;
				}
				
				for(var j:uint = column+1; j < 11; j++)
				{
					if(this._gridObjects[j][row].getObstacle() == null)
					{
						savePt = new Object();
						savePt.row = row;
						savePt.column = j;
						this._chooseableList.push(savePt);
						this._gridObjects[j][row].setQuadAlpha(0.5);
					}
					else
						break;
				}
			}
		}
		
		private function setupForEndPtChoosing(index:Number):void
		{
			var points	:Object = indexToPoints(index);
			var savePt	:Object;
			var column	:Number = points.column;
			var row		:Number = points.row;
			
			for(var i:Number = column-1; i >= 0; i--)
			{
				if(this._gridObjects[i][row].getObstacle() == null)
				{
					savePt = new Object();
					savePt.row = row;
					savePt.column = i;
					this._chooseableList.push(savePt);
					this._gridObjects[i][row].setQuadAlpha(0.5);
				}
				else
					break;
			}
			
			for(var j:Number = column+1; j < 11; j++)
			{
				if(this._gridObjects[j][row].getObstacle() == null)
				{
					savePt = new Object();
					savePt.row = row;
					savePt.column = j;
					this._chooseableList.push(savePt);
					this._gridObjects[j][row].setQuadAlpha(0.5);
				}
				else
					break;
			}
			
			for(var m:Number = row-1; m >= 0; m--)
			{
				if(this._gridObjects[column][m].getObstacle() == null)
				{
					savePt = new Object();
					savePt.row = m;
					savePt.column = column;
					this._chooseableList.push(savePt);
					this._gridObjects[column][m].setQuadAlpha(0.5);
				}
				else
					break;
			}
			
			
			for(var n:Number = row+1; n < 9; n++)
			{
				if(this._gridObjects[column][n].getObstacle() == null)
				{
					savePt = new Object();
					savePt.row = n;
					savePt.column = column;
					this._chooseableList.push(savePt);
					this._gridObjects[column][n].setQuadAlpha(0.5);
				}
				else
					break;
			}
		}
		
		private function setPatrolEnemyPoints():void
		{
			//If not return
			//else take in the position (x,y)
			//Check if x==enemy.x or y==enemy.y
			//if not return
			//else check if any object in between (check walkable)
			
		}
	
		private function indexToPoints(index:Number):Object
		{
			var yIndex	:Number = Math.ceil(index/11)-1;
			var xIndex	:Number = (index - yIndex*11)-1;
			var point	:Object = new Object();
			point.row 		= yIndex;
			point.column 	= xIndex;
			return point;
		}
		
		private function checkOccupiedByCharacters(row:Number, column:Number):Boolean
		{
			for(var i:uint = 0; i < this._occupiedList.length; i++)
			{
				if(row == this._occupiedList[i].row && column == this._occupiedList[i].column)
					return false;
			}
			return true;
		}
	}
}