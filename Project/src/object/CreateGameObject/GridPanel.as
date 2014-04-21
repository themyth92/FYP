package object.CreateGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
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
	import starling.events.KeyboardEvent;
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
		private var _playerImg			: Image;
		
		//Use to keep track of the index of the characters in the occupied list
		private var _playerIndex		: Object;
		private var _enemy1Index		: Object;
		private var _enemy2Index		: Object;
		
		//Use to keep the enemy info: type, position
		private var _enemy				: Object;
		
		//This is the list of tiles that user can choose from
		private var _chooseableList		: Vector.<Object>;
		
		//Use to store the enemy end points
		private var _enemy1EndPts		: Vector.<Number>;
		private var _enemy2EndPts		: Vector.<Number>;
		
		private var _isChoosing			: Boolean = false;
		private var _endPtType			: String;
		private var _currEndPt			: Object;
		private var _endPtNotifier		: TextField;
		private var _hasGoal			: Boolean = false;
		private var _numOfGoal			: Number = 0;
		
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
			this._enemy1Index = new Object();
			this._enemy1Index.pos = null;
			this._enemy2Index = new Object();
			this._enemy2Index.pos = null;
			this._playerIndex = new Object();
			
			for(var i:uint = 0 ; i < Assets.getUserQuestion().length ; i++){
				var question:Object   	= new Object();
				question.title = Assets.getUserQuestion()[i].title;
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
		
		public function get hasGoal():Boolean{
			return this._hasGoal;
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
						obj.qnsIndex = this._gridObjects[i][j].selectedIndex;
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
			this._indexBg          = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.GRID_IMG));
			this._gridOptionPanel  = new GridOptionPanel(this._questionList);
			this._state				= 0;
			this.initGridObjects();
			this._currEndPt = new Object();
			this._enemy = new Object();
			
			if(!PreviewGameInfo._isSaved)
			{
				this._background       = new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture('Stage1Screen'));
			}
			else
			{
				if(PreviewGameInfo._gameScreen.isUserDef)
					this._background = new Image(Assets.getUserScreenTexture()[PreviewGameInfo._gameScreen.textureIndex].texture);
				else
					this._background = new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture('Stage'+PreviewGameInfo._gameScreen.textureIndex+'Screen'));
				this.loadGridObjects();
				this.loadPlayer();
				this.loadEnemy();
				this.loadOccupiedList();
				this.highlightOccupiedTiles();
			}
			
			//add child to display
			this.addChildAt(this._background, 0);
			this.addChildAt(this._indexBg, 1);
			this.addChild(this._gridOptionPanel);
		}
		
		public function changeBackground(image:Image):void{
			this.removeChildAt(0);
			this._background = image;
			this.addChildAt(this._background, 0);
		}
		
		public function removeEndPts(id:Number):void{
			if(id == 1)
			{
				this._enemy1EndPts.length=0;
				resetOccupiedList(1);
			}
			else if(id == 2)
			{
				this._enemy2EndPts.length=0;
				resetOccupiedList(2);
			}
			clearQuad();
			highlightOccupiedTiles();
			this.dispatchEventWith("popUpClose", true);
		}
		
		public function removeEnemy(id:Number):void{
			var pos: Number;
			if(id == 1)
			{
				if(this._enemy1Index.pos != null)
				{
					this._occupiedList.splice(this._enemy1Index.pos, 1);
					pos = this._enemy1Index.pos;
					this._enemy1Index.pos = null;
					moveIndexTracker(pos, 1);
				}
				this.removeChild(this._enemy1Img);
			
				resetOccupiedList(1);
			}
			else if(id == 2)
			{
				if(this._enemy2Index.pos != null)
				{
					this._occupiedList.splice(this._enemy2Index.pos, 1);
					pos = this._enemy2Index.pos;
					this._enemy2Index.pos = null;
					moveIndexTracker(pos, 1);
				}
				this.removeChild(this._enemy2Img);

				resetOccupiedList(2);
			}
			clearQuad();
			highlightOccupiedTiles();
		}
		
		private function moveIndexTracker(index:Number, amount:Number):void{
			if(this._playerIndex.pos != null && this._playerIndex.pos > index)
				this._playerIndex.pos -= amount;
			
			if(this._enemy1Index.pos != null && this._enemy1Index.pos > index)
				this._enemy1Index.pos -= amount;
			if(this._enemy1Index.start != null && this._enemy1Index.start > index)
				this._enemy1Index.start -= amount;
			if(this._enemy1Index.end != null && this._enemy1Index.end > index)
				this._enemy1Index.end -= amount;
			
			if(this._enemy2Index.pos != null && this._enemy2Index.pos > index)
				this._enemy2Index.pos -= amount;
			if(this._enemy2Index.start != null && this._enemy2Index.start > index)
				this._enemy2Index.start -= amount;
			if(this._enemy2Index.end != null && this._enemy2Index.end > index)
				this._enemy2Index.end -= amount;
		}
		
		public function reset():void
		{
			this.clearQuad();
			for(var i:uint=0; i<11; i++)
			{
				for(var j:uint=0; j<9; j++)
					this._gridObjects[i][j].changeStateToNormal();
			}
			this.removeChild(this._playerImg);
			this.removeChild(this._enemy1Img);
			this.removeChild(this._enemy2Img);
			this._occupiedList.length = 0;
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
		
		private function loadGridObjects():void{
			var obsListLength	:Number = PreviewGameInfo._obsCollection.length;
			var droppedObject	:ObstacleObj;
			var xIndex			:int;
			var yIndex			:int;
			var texture			:Texture;
			for(var i:uint=0; i<obsListLength; i++)
			{
				if(PreviewGameInfo._obsTexture[i].isUserDef)
					texture = Assets.getUserTexture()[PreviewGameInfo._obsTexture[i].textureIndex].texture;
				else
				{
					if(Number(PreviewGameInfo._obsType[i]) != 5)
						texture = Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture("pattern_"+formatLeadingZero(PreviewGameInfo._obsTexture[i].textureIndex));
					else
					{
						this._hasGoal = true;
						texture = Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture("Goal");
					}
				}
				droppedObject = new ObstacleObj(texture, PreviewGameInfo._obsTexture[i].isUserDef, PreviewGameInfo._obsTexture[i].textureIndex, null, Number(PreviewGameInfo._obsType[i]));
				yIndex = Math.ceil(PreviewGameInfo._obsIndex[i]/11)-1;
				xIndex = (PreviewGameInfo._obsIndex[i] - yIndex*11)-1;
				this._gridObjects[xIndex][yIndex].changeStateToObstacle(droppedObject);
			}
		}
		
		private function loadPlayer():void{
			var location	:uint	= PreviewGameInfo._playerPos;
			var xIndex		:Number;
			var yIndex		:Number;
			if(location != 0)
			{
				var gender 	:String = PreviewGameInfo._playerGender;
				if(gender == "Male")
					this._playerImg = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Player - Male/male_down_01"));
				else if(gender == "Female")
					this._playerImg = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Player - Female/female_down_01"));
				
				yIndex = Math.ceil(location/11)-1;
				xIndex = location - yIndex*11 -1;
				
				this._playerImg.x = xIndex*40;
				this._playerImg.y = yIndex*40;
				this.addChild(this._playerImg);
				
				var occupiedPt :Object = new Object();
				occupiedPt.row = yIndex;
				occupiedPt.column = xIndex;
				this._occupiedList.push(occupiedPt);
			}
		}
		
		private function loadEnemy():void{
			var enemyType	:Array = PreviewGameInfo._enemyType;
			var enemyAmount	:Number = enemyType.length;
			if(enemyAmount != 0)
			{
				var enemyImg	:Array = PreviewGameInfo._enemyImg;
				var enemyPos	:Array = PreviewGameInfo._enemyPos;
				var xIndex		:Number;
				var yIndex		:Number;
				for(var i:uint=0; i<enemyAmount; i++)
				{
					if(enemyType[i] != "None")
					{
						if(i==0)
						{
							this.removeChild(this._enemy1Img);
							this._enemy1Img = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Enemy/Enemy_" + enemyImg[i]));
							
							yIndex = Math.ceil(enemyPos[i]/11)-1;
							xIndex = enemyPos[i] - yIndex*11 -1;
							this._enemy1Img.x = xIndex*40;
							this._enemy1Img.y = yIndex*40;
							
							this.addChild(this._enemy1Img);
						}
						else if (i == 1)
						{
							this.removeChild(this._enemy2Img);
							this._enemy2Img = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Enemy/Enemy_" + enemyImg[i]));
							yIndex = Math.ceil(enemyPos[i]/11)-1;
							xIndex = enemyPos[i] - yIndex*11 -1;
							this._enemy2Img.x = xIndex*40;
							this._enemy2Img.y = yIndex*40;
							
							this.addChild(this._enemy2Img);
						}
						var occupiedPt :Object = new Object();
						occupiedPt.row = yIndex;
						occupiedPt.column = xIndex;
						this._occupiedList.push(occupiedPt);
					}
				}
			}
		}
		
		private function loadOccupiedList():void
		{
			var endPts1Length :Number;
			var endPts2Length :Number;
			
			if(PreviewGameInfo._enemy1EndPts != null)
				endPts1Length = PreviewGameInfo._enemy1EndPts.length;
			else
				endPts1Length = 0;
			if(PreviewGameInfo._enemy2EndPts != null)
				endPts2Length = PreviewGameInfo._enemy2EndPts.length;
			else
				endPts2Length = 0;
			var occupiedPt 		:Object;
			if(this._enemy1Img != null)
			{
				this._currEndPt.row = this._enemy1Img.y/40;
				this._currEndPt.column = this._enemy1Img.x/40;
				for(var i:uint=0; i<endPts1Length-1; i++)
				{
					setOccupiedList(indexToPoints(PreviewGameInfo._enemy1EndPts[i]).column, indexToPoints(PreviewGameInfo._enemy1EndPts[i]).row);
					occupiedPt = new Object();
					occupiedPt.row = indexToPoints(PreviewGameInfo._enemy1EndPts[i]).row;
					occupiedPt.column = indexToPoints(PreviewGameInfo._enemy1EndPts[i]).column;
					this._occupiedList.push(occupiedPt);
					
					this._currEndPt.row = occupiedPt.row;
					this._currEndPt.column = occupiedPt.column;
				}
			}
			
			this._enemy1EndPts = PreviewGameInfo._enemy1EndPts;
			this._currEndPt = new Object();
			
			if(this._enemy2Img != null)
			{
				this._currEndPt.row = this._enemy2Img.y/40;
				this._currEndPt.column = this._enemy2Img.x/40;
				for(var j:uint=0; j<endPts2Length-1; j++)
				{
					setOccupiedList(indexToPoints(PreviewGameInfo._enemy2EndPts[j]).column, indexToPoints(PreviewGameInfo._enemy2EndPts[j]).row);
					occupiedPt = new Object();
					occupiedPt.row = indexToPoints(PreviewGameInfo._enemy2EndPts[j]).row;
					occupiedPt.column = indexToPoints(PreviewGameInfo._enemy2EndPts[j]).column;
					this._occupiedList.push(occupiedPt);
					
					this._currEndPt.row = occupiedPt.row;
					this._currEndPt.column = occupiedPt.column;
				}
			}
			this._enemy2EndPts = PreviewGameInfo._enemy2EndPts;
			this._currEndPt = new Object();
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
			
			var droppedObject:ObstacleObj  		= new ObstacleObj(dataReturn.texture, dataReturn.isUserDefText, dataReturn.textureIndex, null, dataReturn.obstacleType);
			
			//check out of index
			if(xIndex < 11 && yIndex < 9){
				
				//if not then add child to the grid object
				this._gridObjects[xIndex][yIndex].changeStateToObstacle(droppedObject);
				if(droppedObject.obstacleType == Number(Constant.GOAL_OBS))
				{
					this._hasGoal = true;
					this._numOfGoal ++;
				}
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
					var xPos:Number 					= touch.globalX - 41;
					var yPos:Number 					= touch.globalY - 97;

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

							this._gridOptionPanel.changeStateGrid(obstacleType, optionPanelX, optionPanelY, this._curGridObjSelect.selectedIndex);
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
			if(this._curGridObjSelect.getObstacle().obstacleType == Number(Constant.GOAL_OBS))
			{	
				this._numOfGoal --;
				if(this._numOfGoal == 0)
					this._hasGoal = false;
			}
			
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
					if(this._gridObjects[xIndex][yIndex].getObstacle() == null)
					{
						if(this._enemy1Index.pos != null)
						{
							this._occupiedList.splice(this._enemy1Index.pos, 1);
							this._enemy1Index.pos = null;
							this._enemy1Index.start --;
							this._enemy1Index.end --;
						}
						this.removeChild(this._enemy1Img);
						this._enemy1Img = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Enemy/Enemy_" + data.textureIndex));
						this._enemy1Img.x = xIndex*40;
						this._enemy1Img.y = yIndex*40;
						this._enemy1Index.pos = this._occupiedList.length;
						this.addChild(this._enemy1Img);
					}
					else
					{
						Alert.show("Tile is occupied.", "Error", new ListCollection(
							[
								{ label: "OK" }
							]));
						return;
					}
				}
				else if(data.id == "enemy2")
				{
					if(this._gridObjects[xIndex][yIndex].getObstacle() == null)
					{
						if(this._enemy2Index.pos != null)
						{
							this._occupiedList.splice(this._enemy2Index.pos, 1);
							this._enemy2Index.pos = null;
						}
						this.removeChild(this._enemy2Img);
						this._enemy2Img = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Enemy/Enemy_" + data.textureIndex));
						this._enemy2Img.x = xIndex*40;
						this._enemy2Img.y = yIndex*40;
						this._enemy2EndPts.push(data.pos);
						this._enemy2Index.pos = this._occupiedList.length;
						this.addChild(this._enemy2Img);
					}
					else
					{
						Alert.show("Tile is occupied.", "Error", new ListCollection(
							[
								{ label: "OK" }
							]));
						return;
					}
				}
				else
				{
					if(this._gridObjects[xIndex][yIndex].getObstacle() == null)
					{
						this.removeChild(this._playerImg);
						if(this._playerIndex.pos != undefined)
							this._occupiedList.splice(this._playerIndex.pos, 1);
						if(data.gender)
							this._playerImg = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Player - Male/male_down_01"));
						else
							this._playerImg = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture("Player - Female/female_down_01"));
						
						this._playerImg.x = xIndex*40;
						this._playerImg.y = yIndex*40;
						this._playerIndex.pos = this._occupiedList.length;
						this.addChild(this._playerImg);
					}
					else
					{
						Alert.show("Tile is occupied.", "Error", new ListCollection(
							[
								{ label: "OK" }
							]));
						return;
					}
				}
				
				var occupiedPt :Object = new Object();
				occupiedPt.row = yIndex;
				occupiedPt.column = xIndex;
				this._occupiedList.push(occupiedPt);
				
				clearQuad();
				highlightOccupiedTiles();
			}
		}
		
		public function startChoosingEndPt(data:Object):void
		{
			this._endPtNotifier = new TextField(440, 25, null, "Grobold", 13, 0xffffff, false);
			this._endPtNotifier.y = 450;
			if(data.option == "Circle")
				this._endPtNotifier.text = "Please choose next end. Click on the enemy's position to end choosing.\n Press Esc to stop.";
			else if(data.option == "Reverse")
				this._endPtNotifier.text = "Please choose next end. Click on the last point to end choosing.\n Press Esc to stop.";
			this.addChild(this._endPtNotifier);
			
			if(data.id == "enemy1")
			{
				this._currEndPt.row 	= this._enemy1Img.y / 40;
				this._currEndPt.column 	= this._enemy1Img.x / 40;
				resetOccupiedList(1);
				this._enemy1Index.start = this._occupiedList.length;
				this._enemy.row 		= this._enemy1Img.y / 40;
				this._enemy.column 		= this._enemy1Img.x / 40;
				this._enemy.type 		= "enemy1";
				
			}
			else if(data.id == "enemy2")
			{
				this._currEndPt.row 	= this._enemy2Img.y / 40;
				this._currEndPt.column 	= this._enemy2Img.x / 40;
				resetOccupiedList(2);
				this._enemy2Index.start = this._occupiedList.length;
				this._enemy.row 		= this._enemy2Img.y / 40;
				this._enemy.column 		= this._enemy2Img.x / 40;
				this._enemy.type 		= "enemy2";
			}
			this._currEndPt.counter = 1;
			
			var index :Number = data.pos;
			setupForEndPtChoosing(index);
			this._endPtType = data.option;
			
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onEscPressed);
			this.addEventListener(TouchEvent.TOUCH, onChoosingEndTouch);
		}
		
		private function resetOccupiedList(id:Number):void{
			var start:Number;
			var end	:Number;
			if(id == 1)
			{
				this._enemy1EndPts.length = 0;
				this._occupiedList.splice(this._enemy1Index.start, this._enemy1Index.end - this._enemy1Index.start);
				start = this._enemy1Index.start;
				end = this._enemy1Index.end;
				
				this._enemy1Index.start = null;
				this._enemy1Index.end = null;
				moveIndexTracker(start, end-start);
			}
			else if (id == 2)
			{
				this._enemy2EndPts.length = 0;
				this._occupiedList.splice(this._enemy2Index.start, this._enemy2Index.end - this._enemy2Index.start);
				start = this._enemy2Index.start;
				end = this._enemy2Index.end;
				this._enemy2Index.start = null;
				this._enemy2Index.end = null;
				moveIndexTracker(start, end-start);
			}
			clearQuad();
			highlightOccupiedTiles();
		}
		
		private function onEscPressed(e:KeyboardEvent):void{
			var key:uint = e.keyCode;
			if(key == 27)
			{
				if(this._enemy.type == "enemy1")
				{
					this._enemy1Index.end = this._occupiedList.length;
					resetOccupiedList(1);
				}
				else if(this._enemy.type == "enemy2")
				{
					this._enemy2Index.end = this._occupiedList.length;
					resetOccupiedList(2);
				}
				
				this.removeChild(this._endPtNotifier);
				Alert.show("You've stopped choosing end points.", "Notification", new ListCollection(
					[
						{ label: "OK" }
					]));
				this.removeEventListener(TouchEvent.TOUCH, onChoosingEndTouch);
				this.addEventListener(TouchEvent.TOUCH, onTouch);
				this.dispatchEventWith("popUpClose", true, {id:"changeType", enemy:this._enemy.type});
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onEscPressed);
			}
			else
				return;
		}
		
		private function onChoosingEndTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			if(touch)
			{	
				if(touch.phase == TouchPhase.ENDED)
				{
					var xPos:Number 					= touch.globalX - 41;
					var yPos:Number 					= touch.globalY - 97;
					
					var xIndex	   	:int 	 			= int(xPos/40);
					var yIndex		:int   				= int(yPos/40);
					
					for(var i:uint = 0; i< this._chooseableList.length; i++)
					{
						var savedPt	:Number;
						
						//Check from the chooseable List
						//If the touched tiles is in the list, save the tile
						//Else error
						if(xIndex == this._chooseableList[i].column && yIndex == this._chooseableList[i].row)
						{
							if(isEndChoosing(xIndex, yIndex))
							{
								savedPt	= xIndex + (yIndex*11)+1;
								
								if(this._enemy.type == "enemy1")
									this._enemy1EndPts.push(savedPt);
								else if(this._enemy.type == "enemy2")
									this._enemy2EndPts.push(savedPt);
								
								clearQuad();
								setOccupiedList(xIndex, yIndex);
								
								if(this._enemy.type == "enemy1")
									this._enemy1Index.end = this._occupiedList.length;
								else if(this._enemy.type == "enemy2")
									this._enemy2Index.end = this._occupiedList.length;
								
								highlightOccupiedTiles();
								this.removeChild(this._endPtNotifier);
								Alert.show("You've done choosing end points for enemy.", "Notification", new ListCollection(
									[
										{ label: "OK" }
									]));
								this.removeEventListener(TouchEvent.TOUCH, onChoosingEndTouch);
								this.addEventListener(TouchEvent.TOUCH, onTouch);
								this.dispatchEventWith("popUpClose", true);
								this.removeEventListener(KeyboardEvent.KEY_DOWN, onEscPressed);
								return;
							}
							
							//Found the tiles in the list
							//Convert to Point for IndexBoard processing in game
							savedPt = xIndex + (yIndex*11)+1;

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
		
		private function isEndChoosing(xIndex:Number, yIndex:Number):Boolean{
			if(this._endPtType == "Circle" && xIndex == this._enemy.column && yIndex == this._enemy.row)
				return true;
			else if(this._endPtType == "Reverse" && xIndex == this._currEndPt.column && yIndex == this._currEndPt.row)
				return true;
			else
				return false;
				
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
				{
					this._gridObjects[k][j].setQuadColor(0xffffff);
					this._gridObjects[k][j].setQuadAlpha(0);
				}
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
					if(this._gridObjects[column][m].getObstacle() == null || this._gridObjects[column][m].getObstacle().obstacleType == 1)
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
					if(this._gridObjects[column][n].getObstacle() == null || this._gridObjects[column][n].getObstacle().obstacleType == 1)
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
					if(this._gridObjects[i][row].getObstacle() == null || this._gridObjects[i][row].getObstacle().obstacleType == 1)
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
					if(this._gridObjects[j][row].getObstacle() == null || this._gridObjects[j][row].getObstacle().obstacleType == 1)
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
			
			if(this._endPtType == "Reverse")
			{
				savePt = new Object();
				savePt.row = row;
				savePt.column = column;
				this._chooseableList.push(savePt);
				this._gridObjects[column][row].setQuadAlpha(0.5);
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
				if(this._gridObjects[i][row].getObstacle() == null || this._gridObjects[i][row].getObstacle().obstacleType == 1)
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
				if(this._gridObjects[j][row].getObstacle() == null || this._gridObjects[j][row].getObstacle().obstacleType == 1)
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
				if(this._gridObjects[column][m].getObstacle() == null || this._gridObjects[column][m].getObstacle().obstacleType == 1)
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
				if(this._gridObjects[column][n].getObstacle() == null || this._gridObjects[column][n].getObstacle().obstacleType == 1)
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
		
		private static function formatLeadingZero(value:Number):String{
			return (value < 10) ? "0" + value.toString() : value.toString();
		}
	}
}