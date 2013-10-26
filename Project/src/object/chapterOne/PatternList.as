package object.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.controls.Scroller;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PatternList extends Sprite
	{
		private static const PATTERN_PREFIX: String = 'pattern/pattern_';
		private static const PATTERN_LIST:Array     = ['00','01','02','03'];
		private static const PATTERN_NAME:Array     = ['brick','fire','xbox','coin'];
		private static const PATTERN_POS :Array     = [100, 455];
		
		private var _patternList : List;
		
		public function PatternList()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddedToStage(e:Event):void{
			
			_patternList = new List();
			var patternCollection : ListCollection = new ListCollection();
			var object 			   : Object        = new Object();
			
			for(var i:uint = 0 ; i < PATTERN_LIST.length ; i++){
				
				if(PATTERN_NAME[i]){
					object = {label:PATTERN_NAME[i], thumbnail:Assets.getAtlas(Constant.SPRITE_ONE).getTexture(PATTERN_PREFIX + PATTERN_LIST[i])};
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
	}
}