package controller.chapterOne
{
	import controller.chapterOne.HeroController;
	
	import object.chapterOne.Console;
	import object.chapterOne.Hero;
	
	public class Controller
	{
		private var _console: Console;
		private var _hero   : Hero;
		private var _heroController : HeroController;
		
		public function Controller()
		{
		}
		
		public function notifyObserver(event:Object):void{
			_heroController.updateHeroPosition();				
		}
		
		public function assignObjectController(console:Console, hero:Hero):void{
			this._console = console;
			this._hero    = hero;
			trace(_hero);
			_heroController = new HeroController(_hero);
		}
	}
}