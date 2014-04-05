package object
{
	import assets.SoundAssets;
	
	import constant.Constant;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Slider;
	import feathers.layout.AnchorLayoutData;
	import feathers.themes.MetalWorksMobileTheme;
	
	import manager.SoundManager;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class SoundObject extends Sprite
	{
		private var _slider 			: Slider;
		private var _valueLabel		: Label;
		private var _soundManager		: SoundManager;
		
		public function SoundObject()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function playBackgroundMusic(screen:String):void
		{
			switch(screen){
				case Constant.NAVIGATION_SCREEN:
					this._soundManager  = SoundAssets.getMusic(Constant.NAVIGATION_BG_SOUND);
					this._soundManager.playSound(Constant.NAVIGATION_BG_SOUND, SoundManager._soundVolume, 100);
					break;
				case Constant.CREATE_GAME_SCREEN:
					this._soundManager	= SoundAssets.getMusic(Constant.CREATE_GAME_BG_SOUND);
					this._soundManager.playSound(Constant.CREATE_GAME_BG_SOUND, SoundManager._soundVolume, 100);
				case Constant.STORY_SCREEN:
					this._soundManager	= SoundAssets.getMusic(Constant.STORY_GAME_BG_SOUND);
					this._soundManager.playSound(Constant.STORY_GAME_BG_SOUND, SoundManager._soundVolume, 100);
				default:
					break;
			}
		}
		
		public function stopBackgroundMusic():void
		{
			this._soundManager.stopAllSounds();
		}
		
		private function onAddedToStage(event:Event):void
		{	
			
			this._slider 				= new Slider();
			this._slider.minimum 		= 0;
			this._slider.maximum 		= 100;
			this._slider.value 			= 50;
			this._slider.step 			= 1;
			this._slider.page 			= 10;
			this._slider.direction		= Slider.DIRECTION_HORIZONTAL;
			this._slider.liveDragging 	= true;
			
			this._slider.minimumTrackFactory = function():Button
			{
				var button:Button 		= new Button();
				button.width			= 150;
				button.height 			= 20;
				return button;
			};
			
			this._slider.maximumTrackFactory = function():Button
			{
				var button:Button 		= new Button();
				button.width			= 150;
				button.height 			= 20;
				return button;
			};
			
			
			this._slider.thumbFactory 	= function():Button
			{
				var thumb:Button 		= new Button();
				thumb.width 			= 40;
				thumb.height 			= 40;
				return thumb;
			};
			
			this._valueLabel = new Label();
			this._valueLabel.text = this._slider.value.toString();
			
			this.addChild(this._slider);
			this.addChild(this._valueLabel);
			
			this._slider.addEventListener(Event.CHANGE, onChangeSoundVolume);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{	
			this.removeChild(this._slider);
			this.removeChild(this._valueLabel);
			this._slider		= null;
			this._valueLabel	= null;
			this._soundManager	= null;
		}
		
		private function onChangeSoundVolume(event:Event):void
		{
			SoundManager._soundVolume	= this._slider.value;
			this._valueLabel.text 		= this._slider.value.toString();
			
			//mute
			if(this._slider.value == 0){
				this._soundManager.muteAll();	
			}
			
			//set volume
			else{
				var volume:Number = this._slider.value / 100;
				this._soundManager.setGlobalVolume(volume);
			}
		}
	}
}