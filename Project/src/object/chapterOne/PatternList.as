/*****************************************************
 * ================================================= *
 *                   PATTERN OBJECT                  *
 * ================================================= * 
 *****************************************************/

package object.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.Controller;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class PatternList extends Sprite
	{
		//PATTERN CONST
		private static const PATTERN_PREFIX		:String  = 'pattern/pattern_';
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
		
		//STATES VARIABLE
		private var _state					 :String = constant.chapterOne.Constant.INSTRUCTING_STATE;
		
		public function PatternList(controller:Controller)
		{
			this._isDragged	= false;
			this._notified 	= false;
			this._controller = controller;
			
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
			if(_state == constant.chapterOne.Constant.EDITTING_STATE)
			{
				_touch = event.getTouch(this);
				if(_touch != null)
				{
					//get the location of mouse within the PatternList
					_touchX = _touch.globalX;
					_touchY = _touch.globalY;
					
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
			if(115 <= _touchX && _touchX <= 155)
				if(470 <= _touchY && _touchY <= 510)
					return true;
			
			if(165 <= _touchX && _touchX <= 205)
				if(470 <= _touchY && _touchY <= 510)
					return true;
			
			if(215 <= _touchX && _touchX <= 255)
				if(470 <= _touchY && _touchY <= 510)
					return true;
			
			if(265 <= _touchX && _touchX <= 305)
				if(470 <= _touchY && _touchY <= 510)
					return true;
			
			return false;
		}
		
		/**SELECT THE PATTERN THAT WILL BE DRAG-AND-DROP  
		 * BASED ON THE MOUSE LOCATION**/
		private function selectPatternToDrop():void
		{
			if(115 <= _touchX && _touchX <= 155)
				if(470 <= _touchY && _touchY <= 510)
				{
					_controller.notifyIndexBoard("00");
					return;
				}
			
			if(165 <= _touchX && _touchX <= 205)
				if(470 <= _touchY && _touchY <= 510)
				{
					_controller.notifyIndexBoard("01");
					return;
				}
			
			if(215 <= _touchX && _touchX <= 255)
				if(470 <= _touchY && _touchY <= 510)
				{
					_controller.notifyIndexBoard("02");
					return;
				}
			
			if(265 <= _touchX && _touchX <= 305)
				if(470 <= _touchY && _touchY <= 510)
				{
					_controller.notifyIndexBoard("03");
					return;
				}
		}
		
		
		private function onAddedToStage(e:Event):void{
			
			_patternList = new List();
			var patternCollection 	:ListCollection = new ListCollection();
			var object 			   	:Object         = new Object();
			
			for(var i:uint = 0 ; i < PATTERN_LIST.length ; i++)
			{
				if(PATTERN_NAME[i]){
					object = {label:PATTERN_NAME[i], thumbnail:Assets.getAtlas(constant.Constant.SPRITE_ONE).getTexture(PATTERN_PREFIX + PATTERN_LIST[i])};
					patternCollection.push(object);
					object = null;
				}			
			}
 
			_patternList.dataProvider 						    = patternCollection;
			_patternList.itemRendererProperties.labelField      = "label";
			_patternList.itemRendererProperties.iconSourceField = "thumbnail";
			_patternList.x = PATTERN_POS[0];
			_patternList.y = PATTERN_POS[1];
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			layout.gap = 10;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = 15;
			_patternList.layout = layout;
			
			_patternList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			_patternList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			
			this.addChild(_patternList);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeChild(_patternList);
			_patternList = null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
	}
}