
//this class will create individual obstacle 
//inside the obstacle list

package object.CreateGameObject
{
	import assets.Assets;
	import constant.Constant;
	
	import feathers.controls.ScrollContainer;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDragSource;
	import feathers.events.DragDropEvent;
	import feathers.layout.TiledRowsLayout;
	
	import object.CreateGameObject.ObstacleObj;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.display.Quad;
	
	public class ObstaclePanel extends ScrollContainer implements IDragSource
	{
		//the pre-defined obstacle pattern
		private static const PATTERN_PREFIX:String  = 'pattern_'; 
		
		private var _dragFormat      : String;
		private var _touchID         : int = -1;
		private var _draggedObject   : DisplayObject;
		private var _obstacleObjects : Vector.<ObstacleObj>;
		
		public function ObstaclePanel(dragFormat : String)
		{
			//add in more parameters to pass the 
			//texture object into this panel
			//for initialize the texture purpose
			this._dragFormat = dragFormat;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(DragDropEvent.DRAG_START, onDragStart);
			this.addEventListener(DragDropEvent.DRAG_COMPLETE, onDragComplete);
		}
		
		private function initPanel():void{
			
			//layout default value from feathers
			const layout:TiledRowsLayout  		= new TiledRowsLayout();
			layout.paging                		= TiledRowsLayout.PAGING_NONE;
			layout.horizontalGap            	= 2;
			layout.verticalGap              	= 2;
			layout.paddingTop               	= 0;
			layout.paddingBottom            	= 0;
			layout.paddingLeft              	= 0;
			layout.paddingRight            	 	= 0;
			layout.horizontalAlign         	 	= TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign            	= TiledRowsLayout.VERTICAL_ALIGN_TOP;
			layout.tileHorizontalAlign  	    = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign  	      	= TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			layout.manageVisibility 			= true;
			this.layout                  		= layout;
			this.snapToPages 					= true;
			this.snapScrollPositionsToPixels 	= true;
		}
		
		private function onAddedToStage(event:Event):void{
			
			this.initPanel();
			
			//initialize the vector whenever added to stage
			this._obstacleObjects = new Vector.<ObstacleObj>();
			
			for(var i:uint = 0 ; i < 4 ; i++){
				
				var obj:ObstacleObj = new ObstacleObj(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(PATTERN_PREFIX + '0' + i), false, i);
				obj.x 			 	= 0;
				obj.y 			 	= i*50;
				obj.obstacleType 	= 0; 
				
				this._obstacleObjects.push(obj);
				obj = null;
				
				this.addChild(this._obstacleObjects[i]);
			}
		}
		
		private function onTouch(event:TouchEvent):void{
			
			if(DragDropManager.isDragging){
				//one drag at a time
				return;
			}
			
			if(this._touchID >= 0){
				
				var touch:Touch = event.getTouch(this._draggedObject, null, this._touchID);
				
				if(touch.phase == TouchPhase.MOVED){

					this._touchID = -1;
					
					var obstacleAvatar:Quad     	  	= new Quad(40, 40, 0x00A7FC);
					obstacleAvatar.alpha    	  		= 0.5;
					
					var dragData:DragData	           	= new DragData();
					dragData.setDataForFormat(this._dragFormat, this._draggedObject);				
					DragDropManager.startDrag(this, touch, dragData, obstacleAvatar, - obstacleAvatar.width / 2, - obstacleAvatar.height / 2);
				}
				
				else if(touch.phase == TouchPhase.ENDED){
					this._touchID = -1;
				}
			}
			else{
				
				touch = event.getTouch(this, TouchPhase.BEGAN);
				
				if(!touch || touch.target == this){
					return;
				}
				this._touchID       = touch.id;
				this._draggedObject = touch.target;
			}
		}
		
		private function onDragStart(event:DragDropEvent, dragData:DragData):void{
			
		}
		
		private function onDragComplete(event:DragDropEvent, dragData:DragData):void{

		}
	}
}