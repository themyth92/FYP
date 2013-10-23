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
	
	import flash.ui.Keyboard;
	
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	
	public class Console extends Sprite
	{
		private var _textField    : TextInput;
		private var _consoleNotes : Image;
		private var _text         : String;
		private var _errorSign    : Image;
		private var _enteredText 	:TextInput = new TextInput();
		private var _actionCounter 	:Number = 0;
		private var _nextLineIndex 	:Number = 0;
		
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
				
				_enteredText.x = -500;
				_enteredText.y = -50;
				_enteredText.width = Constant.TEXTFIELD_WIDTH;
				_enteredText.height = Constant.TEXTFIELD_HEIGTH;
				_enteredText.isEditable = false;
				_enteredText.textEditorProperties.textFormat = new TextFormat(Constant.GROBOLD_FONT, 15);
				_enteredText.backgroundSkin = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.CONSOLE_FOCUS));
				
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
				this.addChild(_enteredText);
				_enteredText.visible = false;
				
				toggleErrorSign();
				_textField.addEventListener(Event.CHANGE, onTextFieldChange);
			}
			this.addEventListener(KeyboardEvent.KEY_DOWN, captureText);
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
		
		private function captureText(e:KeyboardEvent): void
		{
			var _str			:String = _textField.text;
			var _subString		:String;
			
			if(e.keyCode == Keyboard.ENTER)
			{	
				_subString = _str.substr(_nextLineIndex,_str.length);
				
				if(_subString.indexOf("(") == -1)
				{
					//output error
					errorDisplay();
				}	
				else
				{
					if(_subString.charAt(_subString.indexOf("(") -1 ) == " ")
						functionWithSpace(_subString);
					else
						functionWithoutSpace(_subString);
				}
				
				_actionCounter ++;
				_nextLineIndex = _str.length + 1;
			}
		}
		
		private function functionWithSpace(s:String):void
		{
			var _actionString		:String;
			var _openBracketIndex 	:Number;
			var _closeBracketIndex	:Number;
			var _objectLocation		:Number;
			
			_openBracketIndex 	= s.indexOf("(");
			_closeBracketIndex 	= s.indexOf(")");
			
			_actionString = s.substr(0,_openBracketIndex - 1);
			_actionString.toLowerCase();
			
			switch(_actionString){
				case "create":
					_objectLocation = getLocation(s);
					if(_objectLocation == 0)
					{
						errorDisplay();
						break;
					}
					createObject(_objectLocation);
					break;
				case "delete":
					_objectLocation = getLocation(s);
					if(_objectLocation == 0)
					{
						errorDisplay();
						break;
					}
					deleteObject(_objectLocation);
					break;
				default:
					errorDisplay();
					break;
			}
		}
		
		private function functionWithoutSpace(s:String):void
		{
			var _actionString		:String;
			var _openBracketIndex 	:Number;
			var _closeBracketIndex	:Number;
			var _objectLocation		:Number;
			
			_openBracketIndex 	= s.indexOf("(");
			_closeBracketIndex 	= s.indexOf(")");
			
			_actionString = s.substr(0,_openBracketIndex);
			_actionString.toLowerCase();
			
			switch(_actionString){
				case "create":
					_objectLocation = getLocation(s);
					if(_objectLocation == 0)
					{
						errorDisplay();
						break;
					}
					createObject(_objectLocation);
					break;
				case "delete":
					_objectLocation = getLocation(s);
					if(_objectLocation == 0)
					{
						errorDisplay();
						break;
					}
					deleteObject(_objectLocation);
					break;
				default:
					errorDisplay();
					break;
			}
		}
		
		private function getLocation(s:String):Number
		{
			var _openBracketIndex 		:Number;
			var _closeBracketIndex		:Number;
			var _objectLocationString	:String;
			
			_openBracketIndex 	= s.indexOf("(");
			_closeBracketIndex 	= s.indexOf(")");
			
			if(_openBracketIndex == _closeBracketIndex - 1)
				return 0;
			else
			{
				_objectLocationString = s.substr(_openBracketIndex + 1, _closeBracketIndex - _openBracketIndex - 1);
				return Number(_objectLocationString);
			}
			//_enteredText.text = _objectLocationString + " " + s.indexOf("(") + " " + s.indexOf(")");
			//_enteredText.visible = true;
		}
		
		private function createObject(n:Number):void
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
			_enteredText.text = n.toString();				
			_enteredText.visible = true;
		}
		
		private function deleteObject(n:Number):void
		{
			_enteredText.visible = false;
		}
		
		private function errorDisplay():void
		{
			_enteredText.text = "error"
			_enteredText.visible = true;	
		}
	}
}