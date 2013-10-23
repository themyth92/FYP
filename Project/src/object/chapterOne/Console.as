package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.ITextEditor;
	
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Console extends Sprite
	{
		private var _textField    : TextInput;
		private var _consoleNotes : Image;
		private var _text         : String;
		private var _errorSign    : Image;
		
		public function Console()
		{
			
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
		
		public function setConsoleEditable(isEditable:Boolean = true):void{
			
			if(isEditable)
				_textField.isEditable = true;
			else
				_textField.isEditable = false;
		}
		
		public function toggleErrorSign(isShow:Boolean = false):void{
			
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
				
				_textField.maxChars                        = 30;
				_textField.backgroundSkin                  = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.CONSOLE_FOCUS));
				
				
				_errorSign.x                               = Constant.WARNING_SIGN_POSX;
				_errorSign.y                               = Constant.WARNING_SIGN_POSY;
			}
			catch(e:Error){
				
				trace('Can not load texture');
			}
			
			if(_consoleNotes != null && _textField != null && _errorSign != null){
				
				this.addChild(_consoleNotes);
				this.addChild(_textField);
				this.addChild(_errorSign);
				
				toggleErrorSign();
				_textField.addEventListener(Event.CHANGE, onTextFieldChange);
			}
		}
		
		private function onTextFieldChange(e:Event):void{
			trace('change');
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeChild(_consoleNotes);
			this.removeChild(_textField);
			_consoleNotes = null;
			_textField    = null;
		}
	}
}