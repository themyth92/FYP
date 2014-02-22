/*****************************************************
 * ================================================= *
 *                   CONSOLE OBJECT                  *
 * ================================================= * 
 *****************************************************/

package object.chapterOne
{
	//import library
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	
	import controller.chapterOne.Controller;
	
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
		private var _textField    				: TextInput;
		private var _consoleNotes				: Image;
		private var _errorSign    				: Image;
		private var _text         				: String;
		private var _enteredText 				: TextArea 		= new TextArea();
		private var _executed					: Boolean 		= false;
		private var _controller 				: Controller;
		
		/*----------------------------
		|	    Console state        |
		-----------------------------*/
		private var _state					 	:String 		= ChapterOneConstant.INSTRUCTING_STATE;
		
		public function Console(controller:Controller)
		{
			this._controller = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function get text():String
		{
			_text = _textField.text;
			
			_text = StringUtil.trim(_text);
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
		}
		
		public function setConsoleEditable(isEditable:Boolean = true):void
		{
			if(isEditable)
				_textField.isEditable = true;
			else
				_textField.isEditable = false;
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
				_textField.text = "";
			}
			return true;
		}
		
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS 		                  | *
		 * ====================================================================**/
		private function onEnterFrame(e:Event):void
		{
			if(_state != ChapterOneConstant.EDITTING_STATE)
				_textField.isEnabled = false;
			else
				_textField.isEnabled = true;
		}
		
		private function onAddedToStage(e:Event):void{
			
			try{
				
				_errorSign    = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.WARNING_SIGN));
				_textField    = new TextInput();
				_consoleNotes = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.CONSOLE));
				
				_textField.x          					   = ChapterOneConstant.TEXTFIELD_POSX;
				_textField.y          					   = ChapterOneConstant.TEXTFIELD_POSY;
				_textField.width      					   = ChapterOneConstant.TEXTFIELD_WIDTH;
				_textField.height     					   = ChapterOneConstant.TEXTFIELD_HEIGTH;
				_textField.isEditable 					   = true;
				
				_textField.textEditorFactory               = function():ITextEditor{
					var format:TextFieldTextEditor = new TextFieldTextEditor();
					format.textFormat = new TextFormat(ChapterOneConstant.GROBOLD_FONT, 15);
					format.embedFonts = true;
					return format;
				};
				
				_enteredText.x = -500;
				_enteredText.y = -50;
				_enteredText.width = ChapterOneConstant.TEXTFIELD_WIDTH;
				_enteredText.height = ChapterOneConstant.TEXTFIELD_HEIGTH;
				_enteredText.isEditable = false;
				_enteredText.textEditorProperties.textFormat = new TextFormat(ChapterOneConstant.GROBOLD_FONT, 15);
				_enteredText.backgroundSkin = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.CONSOLE_FOCUS));
				
				_textField.maxChars                        = 50;
				_textField.backgroundSkin                  = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.CONSOLE_FOCUS));
				
				_errorSign.x                               = WARNING_SIGN_POSX;
				_errorSign.y                               = WARNING_SIGN_POSY;
			}
			catch(e:Error){
				
				trace('Can not load texture');
			}
			
			if(_consoleNotes != null && _textField != null && _errorSign != null){
				
				this.addChild(_consoleNotes);
				this.addChild(_textField);
				this.addChild(_errorSign);
				this.addChild(_enteredText);
				_enteredText.visible = false;
				
				toggleErrorSign();
				
				this._textField.addEventListener(FeathersEventType.ENTER, onTextInputEnter);
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		private function onTextInputEnter(e:Event):void{
			_controller.receiveFromConsole(ChapterOneConstant.CONSOLE_ENTER,null);
		}
		
		private function onRemoveFromStage(e:Event):void{
			this.removeChild(_consoleNotes);
			this.removeChild(_textField);
			_consoleNotes 	= null;
			_textField   	= null;
		}
	}
}