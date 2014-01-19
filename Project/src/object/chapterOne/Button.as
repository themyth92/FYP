/*****************************************************
 * ================================================= *
 *                   BUTTON OBJECT                  *
 * ================================================= * 
 *****************************************************/

package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.Controller;
	
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Button extends Sprite
	{
		//BUTTON OBJECT CONSTANT
		private static const SUBMIT_NORMAL	 :String   	 = 'submitBtn/submitBtn_01';
		private static const SUBMIT_DISABLED :String 	 = 'submitBtn/submitBtn_02';
		private static const SUBMIT_HOVER	 :String     = 'submitBtn/submitBtn_04';
		private static const SUBMIT_CLICK	 :String     = 'submitBtn/submitBtn_03';
		
		private static const PREVIEW_NORMAL	 :String     = 'submitBtn/previewBtn_01';
		private static const PREVIEW_DISABLED:String     = 'submitBtn/previewBtn_02';
		private static const PREVIEW_HOVER	 :String     = 'submitBtn/previewBtn_04';
		private static const PREVIEW_CLICK	 :String     = 'submitBtn/previewBtn_03';
		
		private static const SUBMIT_BTN_POSX :uint       = 93;
		
		//BUTTON OBJECT VARIABLE
		private var _submitBtn 				 :feathers.controls.Button;
		private var _previewBtn 			 :feathers.controls.Button;
		private var _controller 			 :Controller;
		
		//STATES VARIABLE
		private var _state					 :String = Constant.INSTRUCTING_STATE;
		
		public function Button(controller:Controller)
		{	
			this._controller  = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);	
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
//			if(_state != Constant.EDITTING_STATE)
//			{
//				_submitBtn.isEnabled = false;
//				_previewBtn.isEnabled = false;
//			}
		}
		
		private function onAddedToStage(e:Event):void{
			
			_submitBtn = new feathers.controls.Button();
			_submitBtn.defaultSkin  = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(SUBMIT_NORMAL));
			_submitBtn.downSkin     = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(SUBMIT_CLICK));
			_submitBtn.hoverSkin    = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(SUBMIT_HOVER));
			_submitBtn.x            = SUBMIT_BTN_POSX;
			
			_previewBtn = new feathers.controls.Button();
			_previewBtn.defaultSkin = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(PREVIEW_NORMAL));
			_previewBtn.downSkin    = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(PREVIEW_CLICK));
			_previewBtn.hoverSkin   = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(PREVIEW_HOVER));
			
			this.addChild(_submitBtn);
			this.addChild(_previewBtn);
			
			_submitBtn.addEventListener(Event.TRIGGERED, onSubmitBtnTrigger);
			_previewBtn.addEventListener(Event.TRIGGERED, onPreviewBtnTrigger);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		private function onSubmitBtnTrigger(e:Event):void{
			if(_state == Constant.EDITTING_STATE)
				_controller.notifyObserver({event:Constant.TRIGGER, arg:'', target:Constant.SUBMIT_BTN});	
		}
		
		private function onPreviewBtnTrigger(e:Event):void{
			if(_state == Constant.EDITTING_STATE)
				_controller.notifyObserver({event:Constant.TRIGGER, arg:'', target:Constant.PREVIEW_BTN});
		}
		
		private function onRemoveFromStage(e:Event):void{
		
			this.removeChild(_submitBtn);
			this.removeChild(_previewBtn);
			_submitBtn  = null;
			_previewBtn = null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}

		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
	}
}