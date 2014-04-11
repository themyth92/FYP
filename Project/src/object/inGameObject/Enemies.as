package object.inGameObject
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Enemies extends Sprite
	{
		private var _controller		:MainController;
		private var _enemy			:Sprite;
		private var _id				:Number;
		private var _image			:Image;
		private var _imageNo		:Number;
		private var _initialX		:Number;
		private var _initialY		:Number;
		private var _x				:Number;
		private var _y				:Number;
		private var _moveX			:Number;
		private var _moveY			:Number;
		private var _speed			:Number;
		private var _type			:String;
		private var _state			:String;
		private var _patrolType		:String;
		private var _isReversed		:Boolean = false;
		private var _playerFound	:Boolean = false;
		private var _counter		:Number = 0;
		private var _path			:Vector.<Point>;
		private var _currPoint		:Point;
		
		//For Follow Enemy
		private var _currPt			:Point;
		private var _targetPt		:Point;
		private var _isReachedTarget:Boolean = true;
		
		// For Partrol Enemy
		private var _endPoints		:Vector.<Point>;
		private var _currEndPt		:Number = 1;
		private var _currStartPt	:Number = 0;
		
		public function Enemies(controller: MainController, x:Number, y:Number, type:String, speed:Number, imageNo:Number, id:Number)
		{
			this._controller  	= controller;
			this._initialX 		= x;
			this._initialY 		= y;
			this._x 			= x;
			this._y 			= y;
			this._type 			= type;
			this._imageNo 		= imageNo;
			this._id 			= id;
			this._moveX 		= 0;
			this._moveY 		= 0;
			this._speed 		= speed;
			if(this._type == Constant.PATROL_TYPE)
				this._endPoints = new Vector.<Point>();
			if(this._type == Constant.FOLLOW_TYPE)
			{
				this._currPt = new Point(x,y);
				this._currPoint = new Point(x,y);
				this._path = new Vector.<Point>();
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		public function get path():Vector.<Point>{
			return this._path;
		}
		
		public function get counter():Number{
			return this._counter;
		}
		
		public function set counter(value:Number):void{
			this._counter = value;
		}
		
		public function increaseCounter():void{
			this._counter += this._speed;
		}
		
		public function get currPoint():Point{
			return this._currPoint;
		}
		
		public function set currPoint(value:Point):void{
			this._currPoint = value;
		}
		
		public function get playerFound():Boolean{
			return this._playerFound;
		}
		
		public function set playerFound(value:Boolean):void{
			this._playerFound = value;
		}
		
		public function get isReachedTarget():Boolean
		{
			return _isReachedTarget;
		}

		public function set isReachedTarget(value:Boolean):void
		{
			_isReachedTarget = value;
		}

		public function get endPoints():Vector.<Point>
		{
			return _endPoints;
		}

		public function setEndPoints(value:Point):void
		{
			_endPoints.push(value);
		}
		
		public function set targetPt(value:Point):void
		{
			_targetPt = value;
		}

		public function setNextEnd():void
		{
			this._currEndPt ++;
			this._currStartPt ++;
			if(this._endPoints != null)
			{
				if(this._patrolType == "Circle")
				{
					if(this._currEndPt == this._endPoints.length)
						this._currEndPt = 0;
					
					if(this._currStartPt == this._endPoints.length)
						this._currStartPt = 0;
				}
				else if(this._patrolType == "Reverse")
				{
					if(this._currEndPt == this._endPoints.length)
						this._isReversed = true;
					else if(this._currEndPt == 1 && this._isReversed)
					{
						this._isReversed = false;
						this._currEndPt = 1;
						this._currStartPt = 0;
					}
					
					if(this._isReversed)
					{
						this._currEndPt -= 2;
						this._currStartPt = this._currEndPt + 1;
					}
				}
			}
		}
		
		public function get currEndPt():Number
		{
			return _currEndPt;
		}
		
		public function get currStartPt():Number
		{
			return _currStartPt;
		}
		/**====================================================================
		 * |                       GET - SET FUNCTIONS                        | *
		 * ====================================================================**/
		public function get image():Image
		{
			return _image;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function get id():Number
		{
			return _id;
		}
		
		public function get type():String
		{
			return _type;
		}

		public function get moveY():Number
		{
			return _moveY;
		}
		
		public function set moveY(value:Number):void
		{
			_moveY = value;
		}
		
		public function set moveX(value:Number):void
		{
			_moveX = value;
		}
	
		public function get moveX():Number
		{
			return _moveX;
		}
		
		public function get enemyX():Number
		{
			return _x;
		}
		
		public function get enemyY():Number
		{
			return _y;
		}
		
		public function set enemyX(value:Number):void
		{
			_x = value;
		}
		
		public function set enemyY(value:Number):void
		{
			_y = value;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		private function onAddedToStage(event:Event):void
		{
			
			this._image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture('Enemy/Enemy_' + _imageNo.toString()));
			if(this._type == "Patrol Enemy")
			{
				if(this._endPoints[this._endPoints.length-1].equals(this._endPoints[0]))
					this._patrolType = "Circle";
				else
					this._patrolType = "Reverse";
				
				this._endPoints.pop();
			}
				
			this.addChild(this._image);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onRemoveFromStage);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(this._type == Constant.FOLLOW_TYPE && this._targetPt != null) 
				moveToTarget();
			
			this._image.x += this._moveX;
			this._image.y += this._moveY;
			this._x = this._initialX + this._image.x;
			this._y = this._initialY + this._image.y;
		}
		
		private function moveToTarget():void
		{
			var distance	:Number;
			if(this._x == this._targetPt.x && this._y == this._targetPt.y)
			{
				this._moveX = 0;
				this._moveY = 0;
				this._isReachedTarget = true;
				this._currPt = this._targetPt;
				return;
			}
			
			if(this._x != this._targetPt.x && this._y == this._targetPt.y)
			{
				this._moveY = 0;
				distance = this._currPt.x - this._targetPt.x;
				if(distance > 0)
				{
					if(this._x > this._targetPt.x)
						this._moveX = -(this._x - this._targetPt.x);
					else
						this._moveX = distance * (this._speed/100);						
				}
				else if (distance < 0)
				{
					if(this._x < this._targetPt.x)
						this._moveX = -(this._x - this._targetPt.x);
					else
						this._moveX = distance * (this._speed/100);	
				}
				return;
			}
			
			if(this._x == this._targetPt.x && this._y != this._targetPt.y)
			{
				this._moveX = 0;
				distance = this._currPt.y - this._targetPt.y;
				if(distance > 0)
				{
					if(this._y > this._targetPt.y)
						this._moveY = -(this._y - this._targetPt.y);
					else
						this._moveY = distance * (this._speed/100);						
				}
				else if (distance < 0)
				{
					if(this._y < this._targetPt.y)
						this._moveY = -(this._y - this._targetPt.y);
					else
						this._moveY = distance * (this._speed/100);	
				}
				return;
			}
		}
		
		/**====================================================================**/
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
	}
}