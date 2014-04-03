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
		private var _data			:Array;
		
		private var _progress:ProgressBar;
		private var _progressTween:Tween;
		
		public function PreviewLoader()
		{
			super();
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
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: Constant.PLAY_SCREEN}, true));
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
			
		private function retrieveData():void{
			//this._data = TEST_DATA;
		}
		
		private function setupDataForScreen():void{
			//PreviewGameInfo.storeScreenInfo(this._data[0], this._data[1], this._data[2], this._data[3]);
		}
	}
}