package object.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.chapterOne.Controller;
	
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class IndexBoard extends Sprite
	{
		//constant
		private static const PATTERN_PREFIX:String	 = 'pattern/pattern_';
		private static const MAXIMUM_COLUMN:uint 	 = 12;
		private static const MAXIMUM_ROW:uint        = 8;
		private static const PIXEL_MOVE:int 	     = 40;
		
		//indexBoard var
		private var _patternCollection : Vector.<Image>;
		private var _patternIndex      : Vector.<uint>;
		
		//Hero var
		private var _hero	       : Hero;
		private var _controller	   : Controller;
		
		public function IndexBoard(controller:Controller)
		{
			this._controller = controller;
			this._hero         = new Hero(_controller);	
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		public function get patternCollection():Vector.<Image>
		{
			return _patternCollection;
		}

		public function get hero():Hero
		{
			return _hero;
		}

		private function onAddedToStage(e:Event):void{
			
			_patternCollection = new Vector.<Image>();
			_patternIndex      = new Vector.<uint>();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function createObject(name:String, index:uint):void{
		
			this.deleteObject(index);
			
			try{
				
				var img:Image = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(PATTERN_PREFIX + name));
				_patternCollection.push(img);
				positionObjectOnStage(img, index);
			}
			catch(e:Error){
				
				trace('problem with finding the pattern');
			}
			
			_patternIndex.push(index);
		}
		
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
		
		public function deleteObject(index:uint):void
		{
			for (var i:uint = 0 ; i < _patternIndex.length ; i++){
				
				if(_patternIndex[i] == index){
					
					this.removeChild(_patternCollection[i]);
					_patternCollection.splice(i, 1);
					_patternIndex.splice(i, 1);
					
					break;
				}
			}
		}
		
		public function deleteHero():Boolean
		{
			if(_hero.heroEnable)
			{
				this.removeChild(_hero);
				return true;
			}
			else
				return false;
		}
		
		public function createHero(index:Number):Boolean
		{
			var modular      : int  = index % MAXIMUM_COLUMN;
			var rowIndex 	 : uint = 0;
			var columnIndex  : uint = 0;
			
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
				return false;
		}
		
		private function onRemoveFromStage	(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	}
}