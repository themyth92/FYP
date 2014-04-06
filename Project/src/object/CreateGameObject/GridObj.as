package object.CreateGameObject
{
	import object.CreateGameObject.ObstacleObj;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GridObj extends Sprite
	{
		private static const HOVER_COLOR   :uint    = 0x9AD8FF;
		
		private var _start1        	:Boolean;
		private var _start2        	:Boolean;
		private var _end           	:Boolean;
		private var _walkable      	:Boolean;
		private var _visited      		:Boolean;
		
		//check whether the grid has object or not
		private var _state         	:Number;
		private var _quad     		:Quad;
		private var _obstacleObj   	:ObstacleObj;
		
		//used for obstacle panel to know the index of question
		//that have been selected by user
		private var _selectedIndex    	:Number;
		
		public function GridObj()
		{
			this._start1  		= false;
			this._start2    	= false;
			this._end    	 	= false;
			this._walkable  	= true;
			this._visited  		= false;
			this._selectedIndex = -1;
	
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function get selectedIndex():Number
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:Number):void
		{
			_selectedIndex = value;
		}

		public function get state():Number
		{
			return _state;
		}

		public function set state(value:Number):void
		{
			_state = value;
		}

		public function get visited():Boolean
		{
			return _visited;
		}

		public function set visited(value:Boolean):void
		{
			_visited = value;
		}

		public function get walkable():Boolean
		{
			return _walkable;
		}

		public function set walkable(value:Boolean):void
		{
			_walkable = value;
		}

		public function get end():Boolean
		{
			return _end;
		}

		public function set end(value:Boolean):void
		{
			_end = value;
		}

		public function get start2():Boolean
		{
			return _start2;
		}

		public function set start2(value:Boolean):void
		{
			_start2 = value;
		}

		public function get start1():Boolean
		{
			return _start1;
		}

		public function set start1(value:Boolean):void
		{
			_start1 = value;
		}
		
		public function setQuadAlpha(value:Number):void{
			this._quad.alpha = value;
		}
		
		public function setQuadColor(value:uint):void{
			this._quad.color = value;
		}

		public function setPosition(xPos:Number, yPos:Number):void
		{
			this.x = xPos;
			this.y = yPos;
		}
		
		public function changeStateToObstacle(obstacleObj:ObstacleObj):void
		{
			//remove first then add again
			//prevent overlapping obstacle
			if(this._obstacleObj != null)
				this.removeChild(this._obstacleObj);
			
			//save all the information in grid
			this._obstacleObj 		= 	obstacleObj;
			this._state       		= 	1;
			
			this.addChild(this._obstacleObj);
			this.removeChild(this._quad);
		}
		
		public function changeStateToNormal():void{
			
			if(this._state == 0){
				
				this._quad.alpha = 0;
			}
			else
				if(this._state == 1){
					
					this._state      = 0;
					this._quad.alpha = 0;
					
					this.removeChild(this._obstacleObj);
					this.addChild(this._quad);
				}
		}
		
		//change state of the image whenever user perform
		//a touch to choose selection from the grid
		public function changeStateToHover():void{
			
			if(this._state == 1){
				
				this.alpha = 0.5;
			}
			else
				return;
		}
		
		public function getObstacle():ObstacleObj{
			return this._obstacleObj;
		}
		
		private function onAddedToStage(event:Event):void{
			
			this._state     		= 0;
			this._quad       		= new Quad(40, 40, 0xffffff);
			this._quad.alpha		= 0;
			this._selectedIndex   	= -1;
	
			this.addChild(_quad);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	}
}