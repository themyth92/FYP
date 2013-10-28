package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
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
		private static const WARNING_SIGN_POSX:uint       = 130;
		private static const WARNING_SIGN_POSY:uint       = 73;
		
		
		private var _textField    	: TextInput;
		private var _consoleNotes	: Image;
		private var _text         	: String;
		private var _errorSign    	: Image;
		private var _enteredText 	: TextArea = new TextArea();
		private var _executed		: Boolean = false;
		private var _controller 	: Controller;
		
		public function Console(controller:Controller)
		{
			this._controller = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
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

		private function onAddedToStage(e:Event):void{
					
			try{
				
				_errorSign    = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.WARNING_SIGN));
				_textField    = new TextInput();
				_consoleNotes = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.CONSOLE));
				
				_textField.x          					   = Constant.TEXTFIELD_POSX;
				_textField.y          					   = Constant.TEXTFIELD_POSY;
				_textField.width      					   = Constant.TEXTFIELD_WIDTH;
				_textField.height     					   = Constant.TEXTFIELD_HEIGTH;
				_textField.isEditable 					   = true;
				
				_textField.textEditorFactory               = function():ITextEditor{
					var format:TextFieldTextEditor = new TextFieldTextEditor();
					format.textFormat = new TextFormat(Constant.GROBOLD_FONT, 15);
					format.embedFonts = true;
					return format;
				};
				
				_enteredText.x = -500;
				_enteredText.y = -50;
				_enteredText.width = Constant.TEXTFIELD_WIDTH;
				_enteredText.height = Constant.TEXTFIELD_HEIGTH;
				_enteredText.isEditable = false;
				_enteredText.textEditorProperties.textFormat = new TextFormat(Constant.GROBOLD_FONT, 15);
				_enteredText.backgroundSkin = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.CONSOLE_FOCUS));
				
				_textField.maxChars                        = 50;
				_textField.backgroundSkin                  = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.CONSOLE_FOCUS));
				
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

				_textField.addEventListener(KeyboardEvent.KEY_DOWN, onTextInputEnter);
			}
		}
		
		private function onTextInputEnter(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.ENTER)
				_controller.debug();
		}
		
		private function onRemoveFromStage(e:Event):void{
			this.removeChild(_consoleNotes);
			this.removeChild(_textField);
			_consoleNotes 	= null;
			_textField   	= null;
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
		
		private function createObject(s:String,n:Number):void
		{
			switch(n){
				case 10:
					_enteredText.x = 10;
					_enteredText.y = 10;
					break;
				case 5:
					_enteredText.x = -500;
					_enteredText.y = -50;
					break;
			}
			_enteredText.text = s + " " + n.toString();
			_enteredText.visible = true;
		}
		
		private function deleteObject(n:Number):void
		{
			_enteredText.visible = false;
		}
	}
}