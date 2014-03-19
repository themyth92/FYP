/*****************************************************
 * ================================================= *
 *                   PATTERN OBJECT                  *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ObstaclesBoard extends Sprite
	{
		//PATTERN CONST
		private static const PATTERN_PREFIX		:String  = 'pattern_';
		private static const PATTERN_LIST		:Array   = ['00','01','02','03'];
		private static const PATTERN_NAME		:Array   = ['brick','fire','xbox','coin'];
		private static const PATTERN_POS 		:Array   = [100, 455];
		
		//PATTERN VARIABLE
		private var _controller					:Controller;
		private var _patternList 				:List;
		private var _touch						:Touch;
		private var _touchX 					:Number;
		private var _touchY 					:Number;
		private var _isDragged					:Boolean;
		private var _notified 					:Boolean;
		private var _obstaclesIMG				:Vector.<Object>;
		//STATES VARIABLE
		private var _state					 :String = constant.ChapterOneConstant.INSTRUCTING_STATE;
		
		public function ObstaclesBoard(controller:Controller)
		{
			this._isDragged	= false;
			this._notified 	= false;
			this._controller = controller;
			this._obstaclesIMG = new Vector.<Object>();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function get isDragged():Boolean
		{
			return _isDragged;
		}

		public function set isDragged(value:Boolean):void
		{
			_isDragged = value;
		}

		/**CHECK FOR MOUSE LOCATION 
		 * CHECK MOUSE DOUBLE CLICK **/
		private function onTouch(event:TouchEvent):void
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE)
			{
				_touch = event.getTouch(this);
				if(_touch != null)
				{
					//get the location of mouse within the PatternList
					_touchX = _touch.globalX - 515;
					_touchY = _touch.globalY - 115; 
					
					//check mouse within object's image and double click
					if(checkWithinImage() && _touch.tapCount == 1)
					{
						if(!_notified)
						{
							selectPatternToDrop();
							_notified = true;
						}
						else
							_notified = false;
					}
				}
			}
		}
		
		/**CHECK WHETHER THE MOUSE WITHIN THE OBJECT'S IMAGE**/
		private function checkWithinImage():Boolean
		{
			for(var i:uint = 0 ; i < PATTERN_LIST.length; i++)
			{
				if(_obstaclesIMG[i].x <= _touchX && _touchX <= _obstaclesIMG[i].x + 40)
					if(_obstaclesIMG[i].y <= _touchY && _touchY <= _obstaclesIMG[i].y + 40)
						return true;
			}
			
			return false;
		}
		
		/**SELECT THE PATTERN THAT WILL BE DRAG-AND-DROP  
		 * BASED ON THE MOUSE LOCATION**/
		private function selectPatternToDrop():void
		{
			for(var i:uint = 0 ; i < PATTERN_LIST.length; i++)
			{
				if(_obstaclesIMG[i].x <= _touchX && _touchX <= _obstaclesIMG[i].x + 40)
					if(_obstaclesIMG[i].y <= _touchY && _touchY <= _obstaclesIMG[i].y + 40)
					{
						var Digit1 : Number = Math.floor(i/10);
						var Digit2 : Number = i%10;
						var objectType :String = Digit1.toString() + Digit2.toString();
						_controller.notifyIndexBoard(objectType);
						return;
					}
			}
		}
		
		private function onAddedToStage(e:Event):void{
			
			_patternList = new List();
			var patternCollection 	:ListCollection = new ListCollection();
			var object 			   	:Object         = new Object();
			
			for(var i:uint = 0 ; i < PATTERN_LIST.length ; i++)
			{
				if(PATTERN_NAME[i]){
					object = {label:PATTERN_NAME[i], thumbnail:Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(PATTERN_PREFIX + PATTERN_LIST[i])};
					patternCollection.push(object);
					object = null;
				}			
			}
 
			_patternList.dataProvider 						    = patternCollection;
			_patternList.itemRendererProperties.labelField      = "label";
			_patternList.itemRendererProperties.iconSourceField = "thumbnail";
			
			_patternList.width  = 226;
			_patternList.height = 166;
			
			var layout: TiledRowsLayout	= new TiledRowsLayout();

			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			layout.gap = 20;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = 15;
			_patternList.layout = layout;
			
			_patternList.scrollerProperties.horizontalScrollPolicy 	= Scroller.SCROLL_POLICY_AUTO;
			_patternList.scrollerProperties.verticalScrollPolicy 	= Scroller.SCROLL_POLICY_OFF;
			
			this.addChild(_patternList);
			getImagePos();
			 	 
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeChild(_patternList);
			_patternList = null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	
		private function getImagePos():void
		{
			for(var i:uint = 0 ; i < PATTERN_LIST.length; i++)
			{
				if((i+1)%3 == 1)
				{
					_obstaclesIMG[i] = new Object();
					_obstaclesIMG[i].x = 30;
					_obstaclesIMG[i].y = 15 + 40*Math.floor(i/3) + 20*Math.floor(i/3);
				}
				else if((i+1)%3 == 2)
				{
					_obstaclesIMG[i] = new Object();
					_obstaclesIMG[i].x = 30 + 40 + 20;
					_obstaclesIMG[i].y = 15 + 40*Math.floor(i/3) + 20*Math.floor(i/3);
				}
				else if((i+1)%3 == 0)
				{
					_obstaclesIMG[i] = new Object();
					_obstaclesIMG[i].x = 30 + 40*2 + 20*2;
					_obstaclesIMG[i].y = 15 + 40*Math.floor(i/3) + 20*Math.floor(i/3);	
				}
			}
		}
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
	}
}