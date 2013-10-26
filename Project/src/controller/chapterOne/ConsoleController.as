package controller.chapterOne
{
	import flashx.textLayout.formats.BackgroundColor;
	
	import object.chapterOne.Console;
	
	import starling.errors.AbstractClassError;
	
	public class ConsoleController
	{
		private var _console 					:Console;
		private var _gotError					:Boolean;
		private static const MIN_INDEX		:Number = 1;
		private static const MAX_INDEX		:Number = 96;
		private static const OBJECT_TYPE		:Array = new Array("brick", "tree", "bush");
		private static const ACTION_TYPE 		:Array = new Array("create", "delete");
		private static const INVALID_ACTION	:Number = -1; 
		private static const INVALID_LOCATION	:Number = -1;
		private static const INVALID_TYPE		:String = null;
		
		public function ConsoleController(console:Console)
		{
			this._console 	= console;
			this._gotError	= false;
		}
		
		public function consoleControllerActivate():Array
		{
			return analyzeTextInput(_console.text);
		}
		
		private function analyzeTextInput(text:String):Array
		{	
			var str				: String;
			var locationIndex	: Number;
			var typeIndex		: String;
			var actionType		: Number;
			var resultArray		: Array;
			
			//remove all whitespace from string
			str = toNonWhiteSpaceString(text);
			
			_gotError = false;
			//didn't check for error => no error => turn off error display
			if(_console.displayError(_gotError))
			{
				if(checkSyntax(str)) //check syntax error 
				{
					actionType 		= getAction(str);
					locationIndex 	= getLocation(str);
					typeIndex 		= getObjectType(str);
					
					if(actionType == INVALID_ACTION)
					{
						_gotError 	= true;
						resultArray = new Array(false);
					}
					else if(locationIndex == INVALID_LOCATION)
					{
						_gotError 	= true;
						resultArray = new Array(false);
					}
					else if(typeIndex == INVALID_TYPE)
					{
						_gotError 	= true;
						resultArray = new Array(false);
					}
					else
					{
						_gotError 	= false;
						resultArray = new Array(actionType, locationIndex, typeIndex);
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
			else if(s.charAt(closeBracketIndex + 1) != null) //if 1 characters after ")" is null => error 
				_gotError = true;
			else if(s.indexOf(",") == -1) //if there is no "," => error 
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
			var closeBracketIndex		:Number;
			var objectLocationString	:String;
			var index					:Number;
			
			//get "," and ")" location in the string
			commaIndex 	= s.indexOf(",");
			closeBracketIndex 	= s.indexOf(")");
			
			if(commaIndex == closeBracketIndex - 1) //if nothing in between them => invalid => error
				return INVALID_LOCATION;
			else
			{
				objectLocationString = s.substr(commaIndex + 1, closeBracketIndex - commaIndex - 1);
				index = Number(objectLocationString);
				
				if(isNaN(index))	// if the string is not a number => invalid => error
				{
					if(MIN_INDEX <= index && index >= MAX_INDEX)	//if the index is not in range of the board => invalid => error 
						return index;
					else
						return INVALID_LOCATION;
				}
				else
					return INVALID_LOCATION;
			}
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
			
			if(openBracketIndex == commaIndex - 1) //if nothing is between them => invalid => error
				return INVALID_TYPE
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
	}
}