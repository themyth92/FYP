package controller.chapterOne
{
	import object.chapterOne.Hero;
	
	public class HeroController
	{
		private var _hero : Hero;
		
		public function HeroController(hero:Hero)
		{
			this._hero = hero;
		}
		
		public function updateHeroPosition():void{
			trace(_hero.x);
		}
	}
}