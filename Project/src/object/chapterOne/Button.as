/*****************************************************
 * ================================================= *
 *                   BUTTON OBJECT                   *
 * ================================================= * 
 *****************************************************/

package object.chapterOne
{
	//Import library
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	
	import controller.chapterOne.Controller;
	
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Button extends Sprite
	{
		/*----------------------------
		|	    Button constant      |
		-----------------------------*/
		private static const SUBMIT_NORMAL	 :String   	 = 'submitBtn/submitBtn_01';
		private static const SUBMIT_DISABLED :String 	 = 'submitBtn/submitBtn_02';
		private static const SUBMIT_HOVER	 :String     = 'submitBtn/submitBtn_04';
		private static const SUBMIT_CLICK	 :String     = 'submitBtn/submitBtn_03';
		
		private static const PREVIEW_NORMAL	 :String     = 'submitBtn/previewBtn_01';
		private static const PREVIEW_DISABLED:String     = 'submitBtn/previewBtn_02';
		private static const PREVIEW_HOVER	 :String     = 'submitBtn/previewBtn_04';
		private static const PREVIEW_CLICK	 :String     = 'submitBtn/previewBtn_03';
		
		private static const SUBMIT_BTN_POSX :uint       = 93;
		
		/*----------------------------
		 |	    Button variable      |
		 -----------------------------*/
		private var _submitBtn 				 :feathers.controls.Button;
		private var _previewBtn 			 :feathers.controls.Button;
		private var _controller 			 :Controller;
		
		/*----------------------------
		|	    Button state         |
		-----------------------------*/
		private var _state					 :String = ChapterOneConstant.INSTRUCTING_STATE;
		
		public function Button(controller:Controller)
		{	
			this._controller  = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE		, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE	, onRemoveFromStage);	
			this.addEventListener(Event.ENTER_FRAME			, onEnterFrame);
		}
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		
		private function onEnterFrame(e:Event):void
		{
			//if(_state != ChapterOneConstant.EDITTING_STATE)
			//{
			//	_submitBtn.isEnabled = false;
			//	_previewBtn.isEnabled = false;
			//}
		}
		
		private function onAddedToStage(e:Event):void
		{
			//"Submit" button configuration			
			_submitBtn = new feathers.controls.Button();
			_submitBtn.defaultSkin  	= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(SUBMIT_NORMAL));
			_submitBtn.downSkin     	= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(SUBMIT_CLICK));
			_submitBtn.hoverSkin    	= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(SUBMIT_HOVER));
			_submitBtn.disabledSkin 	= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(SUBMIT_DISABLED));
			_submitBtn.x            	= SUBMIT_BTN_POSX;
			
			this.addChild(_submitBtn);
			
			//"Preview" button configuration
			_previewBtn = new feathers.controls.Button();
			_previewBtn.defaultSkin 	= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(PREVIEW_NORMAL));
			_previewBtn.downSkin    	= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(PREVIEW_CLICK));
			_previewBtn.hoverSkin  		= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(PREVIEW_HOVER));
			_previewBtn.disabledSkin	= new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(PREVIEW_DISABLED));
			
			this.addChild(_previewBtn);
			
			//Trigger eventListener for both buttons
			_submitBtn.addEventListener	(Event.TRIGGERED, onSubmitBtnTrigger);
			_previewBtn.addEventListener(Event.TRIGGERED, onPreviewBtnTrigger);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		private function onSubmitBtnTrigger(e:Event):void{
			if(_state == ChapterOneConstant.EDITTING_STATE)
				_controller.receiveFromButton(constant.ChapterOneConstant.BUTTON_PRESS,null,{event:ChapterOneConstant.TRIGGER, arg:'', target:ChapterOneConstant.SUBMIT_BTN});	
		}
		
		private function onPreviewBtnTrigger(e:Event):void{
			if(_state == ChapterOneConstant.EDITTING_STATE)
				_controller.receiveFromButton(constant.ChapterOneConstant.BUTTON_PRESS,null,{event:ChapterOneConstant.TRIGGER, arg:'', target:ChapterOneConstant.PREVIEW_BTN});
		}
		
		private function onRemoveFromStage(e:Event):void{
		
			this.removeChild(_submitBtn);
			this.removeChild(_previewBtn);
			_submitBtn  = null;
			_previewBtn = null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	}
}