/*****************************************************
 * ================================================= *
 *                 INDEXBOARD OBJECT                 *
 * ================================================= * 
 *****************************************************/

package object.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.chapterOne.Controller;
	
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class IndexBoard extends Sprite
	{
		//CONSTANT
		private static const PATTERN_PREFIX:String	 = 'pattern/pattern_';
		private static const MAXIMUM_COLUMN:uint 	 = 12;
		private static const MAXIMUM_ROW:uint        = 8;
		private static const PIXEL_MOVE:int 	     = 40;
		
		//TOUCH VARIABLES
		private var _touch			   :Touch;
		private var _touchArea		   :Quad = new Quad(480,320);
		private var _isTriggered	   :Boolean;
		
		//INDEXBOARD VARIABLES
		private var _patternCollection : Vector.<Image>;
		private var _patternType	   : Vector.<String>;
		private var _patternIndex      : Vector.<uint>;
		
		//HERO VARARIABLES
		private var _hero	       : Hero;
		private var _controller	   : Controller;
		private var _heroIndex	   : uint;
		private var _dragType      : String;
		private var _testImg       : Image;
		
		/** Constructor **/
		public function IndexBoard(controller:Controller)
		{
			this._controller   = controller;
			this._hero         = new Hero(_controller);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this._touchArea.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/** Get Set **/
		public function get patternCollection():Vector.<Image>
		{
			return _patternCollection;
		}

		public function get patternType():Vector.<String>
		{
			return _patternType;
		}
		
		public function get patternIndex():Vector.<uint>
		{
			return _patternIndex;
		}
		
		public function get hero():Hero
		{
			return _hero;
		}

		/** Event Function **/
		/** ADDED_TO_STAGE **/
		private function onAddedToStage(e:Event):void{
			
			this._touchArea.x 		= 0;
			this._touchArea.y 		= 0;
			this._touchArea.alpha 	= 0;
			
			this.addChild(_touchArea);
			
			_patternCollection = new Vector.<Image>();
			_patternIndex      = new Vector.<uint>();
			_patternType 	   = new Vector.<String>();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/** REMOVE_FROM_STAGE **/
		private function onRemoveFromStage	(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/** MOUSE_TOUCH **/
		private function onTouch(event:TouchEvent):void
		{
			_touch = event.getTouch(this._touchArea);
			
			//IF USER DIDNT CHOOSE ANY OBJECT => DO NOTHING
			if(_isTriggered)
				if(_touch != null)
				{
					this._testImg.x = _touch.globalX - 100;
					this._testImg.y = _touch.globalY - 80;
					this.addChild(_testImg);
					//IF MOUSE PRESSED
					if(_touch.phase == TouchPhase.ENDED) 
					{
						//ANALYZE INPUT: LOCATION OF THE MOUSE + OBJECT TYPE
						_controller.mouseInputAnalyze(_dragType, _touch.globalX, _touch.globalY);
						//READY FOR NEXT CHOICE OF OBJECT
						_isTriggered = false;
						this.removeChild(this._testImg);
					}
				}
		}
		
		/** TURN ON TOUCH LISTENTER AFTER USER CHOOSE AN OBJECT FROM PATTERN LIST **/
		public function onTouchListener(isTriggered:Boolean, type: String):void
		{
			this._isTriggered 	= isTriggered;
			this._dragType      = type;
			this._testImg       = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(PATTERN_PREFIX + type));
		}
		
		/** CREATE OBJECT BASED ON TYPE AND INDEX **/
		public function createObject(name:String, index:uint):void{
		
			this.deleteObject(index);
			
			try{
				
				var img:Image = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(PATTERN_PREFIX + name));
				_patternCollection.push(img);
				_patternType.push(name);
				positionObjectOnStage(img, index);
			}
			catch(e:Error){
				
				trace('problem with finding the pattern');
			}
			
			_patternIndex.push(index);
		}
		
		/**GET THE OBJECT'S LOCATION ON INDEXBOARD BASED ON INDEX **/
		private function positionObjectOnStage(obj:Image, index:uint):void
		{	
			if(index > 0 && index <= MAXIMUM_ROW*MAXIMUM_COLUMN){
				
				var modular      : int = index % MAXIMUM_COLUMN;
				var rowIndex 	 : uint = 0;
				var columnIndex  : uint = 0;
				
				if(modular == 0){
					
					rowIndex    = int(index/MAXIMUM_COLUMN) - 1;
					columnIndex = MAXIMUM_COLUMN - 1; 
				}
				else{
					
					rowIndex    = int(index/MAXIMUM_COLUMN);
					columnIndex = modular - 1;
				}
				
				if(columnIndex < 0 || rowIndex < 0){
					trace('problem with finding the position of the pattern. Program should be paused for debugging');
					return;
				}
				
				obj.x = columnIndex	* PIXEL_MOVE;
				obj.y = rowIndex	* PIXEL_MOVE;
				
				this.addChild(obj);
			}
		}
		
		/** DELETE OBJECT AT INDEX LOCATION **/
		public function deleteObject(index:uint):void
		{
			//IF INDEX GIVEN IS CHARACTER'S INDEX + CHARACTER CREATED 
			//=> DELETE CHARACTER
			if(index == _heroIndex && _hero.heroEnable)
			{
				this.deleteHero();						
				return;
			}
			
			//FIND THE OBJECT WITH INDEX IN THE LIST OF OBJECT
			//IF FOUND => DELETE
			for (var i:uint = 0 ; i < _patternIndex.length ; i++){
				if(_patternIndex[i] == index)
				{
					this.removeChild(_patternCollection[i]);
					_patternCollection.splice(i, 1);
					_patternType.splice(i,1);
					_patternIndex.splice(i, 1);
					
					break;
				}
			}
		}
		
		/** DELETE CHARACTERS **/ 
		public function deleteHero():void
		{
			if(_hero.heroEnable)
			{
				//REMOVE CHARACTER 
				this.removeChild(_hero);
				
				//CHARACTER CREATED = FALSE
				_hero.heroEnable = false;
				return;
			}
			else
				return;
		}
		
		/** CREATE CHARACTER **/
		public function createHero(index:Number):Boolean
		{
			var modular      : int  = index % MAXIMUM_COLUMN;
			var rowIndex 	 : uint = 0;
			var columnIndex  : uint = 0;
			
			_heroIndex = index;
			
			//IF NO CHARACTER CREATED => CREATED
			if(!_hero.heroEnable)
			{
				if(modular == 0)
				{
					rowIndex    = int(index/MAXIMUM_COLUMN) - 1;
					columnIndex = MAXIMUM_COLUMN - 1; 
				}
				else
				{
					rowIndex    = int(index/MAXIMUM_COLUMN);
					columnIndex = modular - 1;
				}
				
				_hero.x = columnIndex * PIXEL_MOVE;
				_hero.y = rowIndex	  * PIXEL_MOVE;
				
				this.addChild(_hero);
				return true;
			}
			else
			//IF CHARACTER CREATED => DO NOTHING
				return false;
		}
	}
}