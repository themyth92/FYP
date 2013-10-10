package controller.chapterOne
{
	import object.chapterOne.Console;
	import object.chapterOne.Hero;
	
	public class Controller
	{
		private var _console: Console;
		private var _hero   : Hero;
		
		public function Controller(console:Console)
		{
			this._console = console;
		}
		
		public function notifyObserver():void{
						
		}
	}
}