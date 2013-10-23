package controller.chapterOne
{
	import object.chapterOne.Console;
	
	public class ConsoleController
	{
		private var _console :Console;
		
		public function ConsoleController(console:Console)
		{
			this._console = console;
		}
		
		public function consoleControllerActivate():void{
			analyzeTextInput(_console.text);
		}
		
		private function analyzeTextInput(text:String):void{
			
			//if(checkWhiteSpace(text));
			//continue process the command here
		}
		
		private function checkWhiteSpace(text:String):Boolean{
			
			if(text != null){
				
				for(var i:uint = 0 ; i < text.length ; i++){
					if(text[i] == ' ')
						return false;
				}
				
				return true;
			}
			else
				return false;
		}
	}
}