/*****************************************************
 * ================================================= *
 *                   CONSOLE OBJECT                  *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	//import library
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	import feathers.themes.MetalWorksMobileTheme;
	
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
		/* Constant */
		private static const WARNING_SIGN_POSX	:uint       	= 130;
		private static const WARNING_SIGN_POSY	:uint       	= 73;
		
		private static const MIN_INDEX			:Number 	= 1;
		private static const MAX_INDEX			:Number 	= 99;
		private static const OBJECT_TYPE		:Array 		= new Array("brick", "xbox", "fire", "coin", "hero");
		private static const ACTION_TYPE 		:Array 		= new Array("delete", "create");
		private static const INVALID_ACTION		:Number 	= -1; 
		private static const INVALID_LOCATION	:Number 	= -1;
		private static const INVALID_TYPE		:String 	= null;
		
		/* Display variable */
		private var _console    				: TextInput;
		private var _errorSign    				: Image;
		
		/* Control variable */
		private var _controller 				: MainController;
		private var _actionType					: Number;
		private var _locationIndex				: Number;
		private var _typeIndex					: String;
		private var _commandArray				: Array;
		
		/* State */
		private var _state					 	:String = Constant.INSTRUCTING_STATE;
		private var _screen						:String;
		
		public function Console(controller:MainController)
		{
			this._controller = controller;
			
			this.addEventListener(Event.ADDED_TO_STAGE, 	onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}	
		
		/**====================================================================
		 * |                      GET - SET FUNCTIONS	                      | *
		 * ====================================================================**/
		public function set state(value:String):void{
			this._state = value;
		}
		
		public function enableConsole():void{
			this._console.isEnabled = true;
			this._console.isEditable = true;
		}
		
		public function get commandArray():Array{
			return this._commandArray;
		}
		
		public function showConsole():void{
			this._console.visible = true;
		}
		
		public function set screen(value:String):void{
			this._screen = value;
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS 		                  | *
		 * ====================================================================**/		
		private function onAddedToStage(e:Event):void{	
			new MetalWorksMobileTheme();
			
			this._console 	= new TextInput();
			if(this._screen == Constant.STORY_SCREEN_2)
				this._console.visible = false;
			this._console.width   = Constant.TEXTFIELD_WIDTH;
			this._console.height  = Constant.TEXTFIELD_HEIGTH + 30;
			this._console.textEditorFactory               = function():ITextEditor{
				var format:TextFieldTextEditor = new TextFieldTextEditor();
				format.textFormat = new TextFormat(Constant.GROBOLD_FONT, 15, 0xffff);
				format.embedFonts = true;
				return format;
			};
			this._console.maxChars         = 50;
			
			this._errorSign  = new Image(Assets.getAtlas(Constant.COMMON_ASSET_SPRITE).getTexture(Constant.WARNING_SIGN));
			this._errorSign.x              = WARNING_SIGN_POSX;
			this._errorSign.y              = WARNING_SIGN_POSY;
			this._errorSign.visible 		= false;
	
			this.addChild(_console);
			this.addChild(_errorSign);

			this._console.addEventListener(FeathersEventType.ENTER, onTextInputEnter);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onTextInputEnter(event:Event):void{
			analyzeConsoleInput(_console.text);
			this._controller.receiveFromConsole(Constant.CONSOLE_ENTER, null);
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			this.removeChildren();
			this._console = null;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/**====================================================================
		 * |	                     ACTION FUNCTIONS 		                  | *
		 * ====================================================================**/
		private function showErrorSign(isDisplay:Boolean):void
		{
			if(isDisplay)
				_errorSign.visible = true;
			else
				_errorSign.visible = false;		
		}
		
		private function clearConsole():void
		{
			showErrorSign(false);
			_console.text = "";
		}
		
		private function analyzeConsoleInput(text:String):void{
			var str				: String;
			var resultArray		: Array;
			
			//remove all whitespace from string
			str = toNonWhiteSpaceString(text);
			
			//didn't check for error => no error => turn off error display
			if(checkSyntax(str)) //check syntax error 
			{
				_actionType 	= getAction(str);
				_locationIndex 	= getLocation(str);
				_typeIndex 		= getObjectType(str);
				
				if(_actionType != INVALID_ACTION && _locationIndex != INVALID_LOCATION && _typeIndex != INVALID_TYPE)
				{
					clearConsole();
					showErrorSign(false);
					this._commandArray = new Array(_actionType, _typeIndex, _locationIndex);
				}
				else if(_actionType == 0 && _locationIndex != INVALID_LOCATION && _typeIndex == INVALID_TYPE)
				{
					clearConsole();
					showErrorSign(false);
					this._commandArray = new Array(_actionType, _locationIndex);
				}
				else
				{
					showErrorSign(true);
					this._commandArray = new Array(false);
				}
			}	
			else
			{
				showErrorSign(true);
				this._commandArray = new Array(false);
			}
		}
		
		/**====================================================================
		 * |	                     	  API		 		                  | *
		 * ====================================================================**/
		//function to remove all the whitespace in the string
		private function toNonWhiteSpaceString(text:String):String
		{
			var spaces		:RegExp = / /gi; // match "spaces" in a string
			var str			:String;
			
			str = text.replace(spaces, ""); // find and replace "spaces"
			return str;	
		}
		
		//check if after ), is there any other characters
		private function checkSyntax(s:String):Boolean 
		{
			var closeBracketIndex	:Number;
			
			//get index of )
			closeBracketIndex = s.lastIndexOf(")");
			
			if(s.indexOf("(") == -1) //if there is no "(" => error
				return false;
			else if (s.indexOf(")") == -1) //if there is no ")" => error
				return false;
			else if(isLetter(s.charAt(closeBracketIndex + 1))) //if 1 characters after ")" is null => error
				return false;
			else if(s.indexOf(",") == -1 && _actionType == 1) //if there is no "," => error 
				return false;
			else 
				return true;
		}
		
		//Get action of the function
		private function getAction(s:String):Number
		{
			var openBracketIndex	:Number;
			var actionString		:String;
			
			openBracketIndex	= s.indexOf("(");
			actionString		= s.substr(0, openBracketIndex);
			
			for(var i:uint = 0; i < ACTION_TYPE.length; i++)
			{
				if(actionString.toLowerCase() == ACTION_TYPE[i])
					return i;
			}
			return INVALID_ACTION;
		}
		
		//Get location of the object => x,y coordinate
		private function getLocation(s:String):Number
		{
			var commaIndex				:Number;
			var openBracketIndex		:Number;
			var closeBracketIndex		:Number;
			var objectLocationString	:String;
			var index					:Number;
			
			//get "(", "," and ")" location in the string
			openBracketIndex 	= s.indexOf("(");
			closeBracketIndex 	= s.indexOf(")");
			if(_actionType == 1)
			{
				commaIndex 		= s.indexOf(",");
				
				if(commaIndex == closeBracketIndex - 1) //if nothing in between them => invalid => error
					return INVALID_LOCATION;
				else
				{
					objectLocationString = s.substr(commaIndex + 1, closeBracketIndex - commaIndex - 1);
					index = Number(objectLocationString);
					
					if(!isNaN(index))	// if the string is not a number => invalid => error
					{
						if(MIN_INDEX <= index && index <= MAX_INDEX)	//if the index is not in range of the board => invalid => error
							return index;
						else
							return INVALID_LOCATION;
					}
					else
						return INVALID_LOCATION;
				}
			}
			else if(_actionType == 0)
			{
				if(openBracketIndex == closeBracketIndex - 1) //if nothing in between them => invalid => error
					return INVALID_LOCATION;
				else
				{
					objectLocationString = s.substr(openBracketIndex + 1, closeBracketIndex - openBracketIndex - 1);
					index = Number(objectLocationString);
					
					if(!isNaN(index))	// if the string is not a number => invalid => error
					{
						if(MIN_INDEX <= index && index <= MAX_INDEX)	//if the index is not in range of the board => invalid => error
							return index;
						else
							return INVALID_LOCATION;
					}
					else
						return INVALID_LOCATION;
				}
			}
			return INVALID_LOCATION;
		}
		
		//Get type of the object: brick, tree, hero, start, goal
		private function getObjectType(s:String):String
		{
			var openBracketIndex	:Number;
			var commaIndex			:Number;
			var type				:String;
			
			//get "(" and "," location in the string
			openBracketIndex = s.indexOf("(");
			commaIndex = s.indexOf(",");
			if(_actionType == 0)
				return INVALID_TYPE;
			else if(openBracketIndex == commaIndex - 1) //if nothing is between them => invalid => error
				return INVALID_TYPE;
			else
			{
				type = s.substr(openBracketIndex + 1, commaIndex - openBracketIndex - 1);
				return convertTypeToIndex(type);
			}
		}
		
		private function convertTypeToIndex(type:String):String
		{
			for(var i:uint = 0; i < OBJECT_TYPE.length; i++)
			{
				if(type.toLowerCase() == OBJECT_TYPE[i])
					return i > 9 ? "" + i : "0" + i;
			}
			return INVALID_TYPE;
		}
		
		//Determines if a string is upper case
		private function isUpperCase(value : String) : Boolean {
			return isValidCode(value, 65, 90);
			
		}
		
		// Determines if a string is lower case 
		private function isLowerCase(value : String) : Boolean {
			return isValidCode(value, 97, 122);
		}
		
		// Determines if a string is digit 
		private function isDigit(value : String) : Boolean {
			return isValidCode(value, 48, 57);
		}
		
		// Determines if a string is letter
		private function isLetter(value : String) : Boolean {
			return (isLowerCase(value) || isUpperCase(value));
		}
		
		// The meat of the functions which checks the values 
		private function isValidCode(value : String, minCode : Number, maxCode : Number) : Boolean {
			if ((value == null) || (StringUtil.trim(value).length < 1))
				return false;
			
			for (var i : int=value.length-1;i >= 0; i--) {
				var code : Number = value.charCodeAt(i);
				if ((code < minCode) || (code > maxCode))
					return false;
			}
			return true;
		}
	}
}