package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Enemies extends Sprite
	{
		private var _controller		:Controller;
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
		
		//For Follow Enemy
		private var _currPt			:Point;
		private var _targetPt		:Point;
		private var _isReachedTarget:Boolean = true;
		
		// For Partrol Enemy
		private var _endPoints		:Vector.<Point>;
		private var _currEndPt		:Number = 1;
		private var _currStartPt	:Number = 0;
		
		public function Enemies(controller: Controller, x:Number, y:Number, type:String, speed:Number, imageNo:Number, id:Number)
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
				this._currPt = new Point(x,y);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
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
			_currEndPt ++;
			_currStartPt ++;
			if(_endPoints != null)
			{
				if(_currEndPt == _endPoints.length)
					_currEndPt = 0;
				if(_currStartPt == _endPoints.length)
					_currStartPt = 0;
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
						this._moveX = distance * this._speed;						
				}
				else if (distance < 0)
				{
					if(this._x < this._targetPt.x)
						this._moveX = -(this._x - this._targetPt.x);
					else
						this._moveX = distance * this._speed;	
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
						this._moveY = distance * this._speed;						
				}
				else if (distance < 0)
				{
					if(this._y < this._targetPt.y)
						this._moveY = -(this._y - this._targetPt.y);
					else
						this._moveY = distance * this._speed;	
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