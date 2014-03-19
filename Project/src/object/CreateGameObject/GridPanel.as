package object.CreateGameObject
{
	import assets.Assets;
	
	import constant.Constant;
	
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
		private var _dragFormat    : String;
		private var _background    : Image;
		private var _indexBg       : Image;
		private var _gridObjects   : Vector.<Vector.<GridObj>>;
		
		public function GridPanel(dragFormat : String)
		{
			this._dragFormat  		= dragFormat;
			
			//register event handler
			this.addEventListener(DragDropEvent.DRAG_ENTER, onDragEnter);
			this.addEventListener(DragDropEvent.DRAG_EXIT,  onDragExit);
			this.addEventListener(DragDropEvent.DRAG_DROP,  onDragDrop);
		}
		
		override protected function initialize():void{
			
			//create a new quad background
			this._background       = new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture('WaterScreen'));
			this._indexBg          = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.GRID_IMG));
			this.initGridObjects();
			
			this.addChildAt(this._background, 0);
			this.addChildAt(this._indexBg, 1);
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
			//cancel the dragged state
		}
		
		
		//event happen when the object is dropped inside the drop range
		private function onDragDrop(event:DragDropEvent, dragData:DragData):void
		{

			var dataReturn:Image 				= dragData.getDataForFormat(this._dragFormat);
			var xPos:Number 					= event.localX;
			var yPos:Number 					= event.localY;
			var squareSize	:int 				= 40;
			var xIndex	   	:int 	 			= int(xPos/40);
			var yIndex		:int   				= int(yPos/40);
			
			var droppedObject:Image  				= new Image(dataReturn.texture);
			if(xIndex < 11 && yIndex < 9){ 
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
	}
}