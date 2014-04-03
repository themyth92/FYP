package screen
{
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	
	import events.NavigationEvent;
	
	import feathers.controls.ProgressBar;
	import feathers.layout.AnchorLayoutData;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PreviewLoader extends Sprite
	{
		//Test data
	/*	private var testData	 :Object = {
			hero :{pos : 12, gender : 1},
			enemy : [],
			obstacles : [],
			screen :{},
		};
		private static const TEST_PLAYER :Object = {pos: 99, gender: "Male"};
		private static const TEST_ENEMY	 :Object = {amount:2, enemy1:["Patrol Enemy",30,0.03,3], enemy2:["Patrol Enemy",20, 0.01,1]};
		private static const TEST_SCORE  :Object = {maxCoin:0, maxLife:5, minStart:3, secStart:45};
		
		private static const STAGE1_COLLECTION	:Vector.<String> = new <String>["pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00",
			"pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","Goal","Goal"];
		private static const STAGE1_INDEX	  	:Vector.<uint> = new <uint>[4,8,15,19,23,24,25,26,30,31,32,33,
			67,68,69,70,74,75,76,77,81,85,92,96,6,94];
		private static const STAGE1_TYPE		  	:Vector.<String> = new <String>["00","00","00","00","00","00","00","00",
			"00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","goal","goal"];
		
		private var testObj	:Object; 
		
		private var _data			:Array;
		
		private var _progress:ProgressBar;
		private var _progressTween:Tween;
		
		public function PreviewLoader()
		{
			super();
			setupTestData();
			retrieveData();
			setupDataForScreen();
			
			var enemy: Array = new Array();
			enemy.push({pos : 9, textureIndex : 3, type : 1, speed : 0.5});
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if( 1 - this._progress.value < 0.02)
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.PREVIEW_SCREEN}, true));
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._progress = new ProgressBar();
			this._progress.minimum = 0;
			this._progress.maximum = 1;
			this._progress.value = 0;
			const progressLayoutData:AnchorLayoutData = new AnchorLayoutData();
			progressLayoutData.horizontalCenter = 0;
			progressLayoutData.verticalCenter = 0;
			this._progress.layoutData = progressLayoutData;
			this._progress.x = 265;
			this._progress.y = 600/2;
			this.addChild(this._progress);
			
			this._progressTween = new Tween(this._progress, 5);
			this._progressTween.animate("value", 1);
			this._progressTween.repeatCount = int.MAX_VALUE;
			Starling.juggler.add(this._progressTween);
		}
		
		private function setupTestData():void
		{
			testObj = new Object();
			testObj.collection = STAGE1_COLLECTION;
			testObj.index = STAGE1_INDEX;
			testObj.type = STAGE1_TYPE;
			TEST_DATA.push(TEST_PLAYER);
			TEST_DATA.push(TEST_ENEMY);
			TEST_DATA.push(TEST_SCORE);
			TEST_DATA.push(testObj);
		}
		
		private function retrieveData():void{
			this._data = TEST_DATA;
		}
		
		private function setupDataForScreen():void{
			PreviewGameInfo.storeScreenInfo(this._data[0], this._data[1], this._data[2], this._data[3]);
		}*/
	}
}