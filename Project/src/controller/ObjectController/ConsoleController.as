/*****************************************************
 * ================================================= *
 *            CONSOLE OBJECT'S CONTROLLER            *
 * ================================================= * 
 *****************************************************/

package controller.ObjectController
{
	//import library
	import flashx.textLayout.formats.BackgroundColor;
	import mx.utils.StringUtil;
	import object.inGameObject.Console;
	import starling.errors.AbstractClassError;

	public class ConsoleController
	{		
		/*----------------------------
		|	  Controller variable    |
		-----------------------------*/
		private var _console 					:Console;
		private var _gotError					:Boolean;
		private var _actionType					:Number;
		private var _locationIndex				:Number;
		private var _typeIndex					:String;
		
		/*----------------------------
		|	  Controller constant    |
		-----------------------------*/
		private static const MIN_INDEX			:Number 	= 1;
		private static const MAX_INDEX			:Number 	= 96;
		private static const OBJECT_TYPE		:Array 		= new Array("brick", "xbox", "fire", "coin", "hero");
		private static const ACTION_TYPE 		:Array 		= new Array("delete", "create");
		private static const INVALID_ACTION		:Number 	= -1; 
		private static const INVALID_LOCATION	:Number 	= -1;
		private static const INVALID_TYPE		:String 	= null;
		
		public function ConsoleController(console:Console)
		{
			this._console 		= console;
			this._gotError		= false;
			this._actionType 	= -1;
			this._locationIndex = -1;
			this._typeIndex		= null;
		}
		
		/** receive text input then call another function to analyze it **/
		public function consoleControllerActivate():Array
		{
			return analyzeTextInput(_console.text);
		}
		
		private function analyzeTextInput(text:String):Array
		{	
			var str				: String;
			var resultArray		: Array;
			
			//remove all whitespace from string
			str = toNonWhiteSpaceString(text);
			
			_gotError = false;
			_console.displayError(true);
			//didn't check for error => no error => turn off error display
			if(_console.displayError(_gotError))
			{
				_actionType 	= getAction(str);
				if(checkSyntax(str)) //check syntax error 
				{
					_locationIndex 	= getLocation(str);
					_typeIndex 		= getObjectType(str);
					
					if(_actionType == INVALID_ACTION)
					{
						_gotError 	= true;
						resultArray = new Array(false);
					}
					else if(_locationIndex == INVALID_LOCATION)
					{
						_gotError 	= true;
						resultArray = new Array(false);
					}
					else if(_typeIndex == INVALID_TYPE)
					{
						if(_actionType == 1)
						{
							_gotError 	= true;
							resultArray = new Array(false);
						}
						else if(_actionType == 0)
						{
							_gotError = false;
							resultArray = new Array(_actionType, _locationIndex);
						}
					}
					else
					{
						_gotError 	= false;
						resultArray = new Array(_actionType,_typeIndex, _locationIndex);
					}
				}	
				else
					resultArray = new Array(false);
			}				
		 	//got error => turn on error display
			if(_gotError)
			{
				if(_console.displayError(_gotError))
					return resultArray;
			}
			else //no error => clear console for next function and return the result
			{
				if(_console.clearConsole())
					return resultArray;	
			}
			return resultArray;
		}
		
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
				_gotError = true;
			else if (s.indexOf(")") == -1) //if there is no ")" => error
				_gotError = true;
			else if(isLetter(s.charAt(closeBracketIndex + 1))) //if 1 characters after ")" is null => error
				_gotError = true;
			else if(s.indexOf(",") == -1 && _actionType == 1) //if there is no "," => error 
				_gotError = true;
			
			if(_gotError)
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
		
		public function changeObjectState(currentState:String):void
		{
			_console.changeState(currentState);
		}
		
		/**------------------------------
		   |            API             |
		  *------------------------------**/
		
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