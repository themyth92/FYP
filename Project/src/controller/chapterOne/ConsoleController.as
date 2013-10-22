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
			var commandArray : Array = text.split('\\');
			trace(commandArray[0]);
		}
	}
}