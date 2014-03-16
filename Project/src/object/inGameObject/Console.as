/*****************************************************
 * ================================================= *
 *                   CONSOLE OBJECT                  *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	//import library
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	
	
	public class Console extends Sprite
	{
		/*----------------------------
		|	    Console constant     |
		-----------------------------*/
		private static const WARNING_SIGN_POSX	:uint       	= 130;
		private static const WARNING_SIGN_POSY	:uint       	= 73;
		
		/*----------------------------
		|	    Console variable     |
		-----------------------------*/
		private var _console    				: TextInput;
		private var _errorSign    				: Image;
		private var _text         				: String;
		private var _enteredText 				: TextArea 		= new TextArea();
		private var _isExecuted					: Boolean 		= false;
		private var _controller 				: Controller;
		
		/*----------------------------
		|	    Console state        |
		-----------------------------*/
		private var _state					 	:String 		= ChapterOneConstant.INSTRUCTING_STATE;
		
		public function Console(controller:Controller)
		{
			this._controller = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, 	onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME,		onEnterFrame);
		}
		
		
		/**====================================================================
		 * |                      GET - SET FUNCTIONS	                      | *
		 * ====================================================================**/
		public function get text():String
		{
			_text = _console.text;
			
			_text = StringUtil.trim(_text);
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS 		                  | *
		 * ====================================================================**/
		private function onEnterFrame(e:Event):void
		{
			if(_state != ChapterOneConstant.EDITTING_STATE && _state != ChapterOneConstant.INSTRUCTING_STATE)
				_console.isEnabled = false;
			else
				_console.isEnabled = true;
		}
		
		private function onAddedToStage(e:Event):void{
			_errorSign  = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.WARNING_SIGN));
			
			_console 	= new TextInput();
			_console.width   = ChapterOneConstant.TEXTFIELD_WIDTH;
			_console.height  = ChapterOneConstant.TEXTFIELD_HEIGTH;
			
			
			_console.textEditorFactory               = function():ITextEditor{
				var format:TextFieldTextEditor = new TextFieldTextEditor();
				format.textFormat = new TextFormat(ChapterOneConstant.GROBOLD_FONT, 15);
				format.embedFonts = true;
				return format;
			};
			_console.maxChars         = 50;
			_console.backgroundSkin   = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.CONSOLE_IMG));
			
			_errorSign.x              = WARNING_SIGN_POSX;
			_errorSign.y              = WARNING_SIGN_POSY;
	
			this.addChild(_console);
			this.addChild(_errorSign);
			
			toggleErrorSign();
			
			this._console.addEventListener(FeathersEventType.ENTER, onTextInputEnter);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onTextInputEnter(event:Event):void{
			_controller.receiveFromConsole(ChapterOneConstant.CONSOLE_ENTER, null);
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			this.removeChild(_console);
		}
		
		/**====================================================================
		 * |	                     ACTION FUNCTIONS 		                  | *
		 * ====================================================================**/
		public function setConsoleEditable(isEditable:Boolean = true):void
		{
			if(isEditable)
				_console.isEditable = true;
			else
				_console.isEditable = false;
		}
		
		public function toggleErrorSign(isShow:Boolean = false):void
		{	
			if(isShow)
				_errorSign.visible = true;
			else
				_errorSign.visible = false;
		}
		
		public function displayError(gotError:Boolean):Boolean
		{
			if(gotError)
				toggleErrorSign(true);
			else
				toggleErrorSign(false);
			
			return true;
		}
		
		public function clearConsole(done:Boolean = true):Boolean
		{
			if(done)
			{	
				toggleErrorSign(false);	
				_console.text = "";
			}
			return true;
		}
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
	}
}