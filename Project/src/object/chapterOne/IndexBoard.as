package object.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class IndexBoard extends Sprite
	{
		private static const PATTERN_PREFIX:String	 = 'pattern_';
		private static const MAXIMUM_COLUMN:uint 		 = 12;
		private static const MAXIMUM_ROW:uint          = 8;
		private static const PIXEL_MOVE:int 			 = 40;
		
		private var _patternCollection : Vector.<Image>;
		private var _patternIndex      : Vector.<uint>;
		
		public function IndexBoard()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddedToStage(e:Event):void{
			
			_patternCollection = new Vector.<Image>();
			_patternIndex      = new Vector.<Image>();
			
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
				
				trace('problem with finding the patter');
			}
			
			_patternIndex.push(index);
		}
		
		private function positionObjectOnStage(obj:Image, index:uint){
			
			if(index > 0 && index <= MAXIMUM_ROW*MAXIMUM_COLUMN){
				
				var rowIndex:uint    = index % MAXIMUM_ROW; 
				var columnIndex:uint = index % MAXIMUM_COLUMN;
				
				rowIndex    = rowIndex - 1;
				columnIndex = columnIndex -1 ;
				
				obj.x = columnIndex*PIXEL_MOVE;
				obj.y = rowIndex*PIXEL_MOVE;
				this.addChild(obj);
			}
		}
		
		public function deleteObject(index:uint):void{
			
			for (var i:uint = 0 ; i < _patternIndex.length ; i++){
				
				if(_patternIndex[i] == index){
					
					this.removeChild(_patternCollection[i]);
					_patternCollection.splice(i, 1);
					_patternIndex.splice(i, 1);
					
					break;
				}
			}
		}
		
		private function onRemoveFromStage	(e:Event):void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	}
}