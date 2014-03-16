package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
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
		
		public function Enemies(controller: Controller, x:Number, y:Number, type:String, speed:Number, imageNo:Number, id:Number)
		{
			this._controller  = controller;
			this._initialX = x;
			this._initialY = y;
			this._x = x;
			this._y = y;
			this._type = type;
			this._imageNo = imageNo;
			this._id = id;
			this._moveX 	= 0;
			this._moveY 	= 0;
			
			this._speed = speed;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/**====================================================================
		 * |                       GET - SET FUNCTIONS                        | *
		 * ====================================================================**/
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
		
		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		private function onAddedToStage(event:Event):void
		{
			
			this._image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture('Enemy_' + _imageNo.toString()));
		
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
//			var moveArr:Array = _controller.checkAgro(this);
//			if(moveArr.length == 2)
//			{
//				this._moveX = moveArr[0];
//				this._moveY = moveArr[1];
//				this._image.x += this._moveX;
//				this._image.y += this._moveY;
//				
//				this._x = this._initialX + this._image.x;
//				this._y = this._initialY + this._image.y;
//			}
		}
		
		/**====================================================================**/
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
	}
}