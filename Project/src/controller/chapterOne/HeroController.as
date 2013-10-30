package controller.chapterOne
{
	import constant.chapterOne.Constant;
	
	import object.chapterOne.Hero;
	
	public class HeroController
	{
		private var _heroAvail						:Boolean;					
		private static const HERO_SPEED_FORWARD		:int = 3;
		private static const HERO_SPEED_BACKWARD	:int = -3;
		
		private var _hero 		  : Hero;
		
		public function HeroController(hero:Hero)
		{
			this._hero = hero;
			this._heroAvail = false;
		}

		public function enableHero():void
		{
			_hero.enableHero();
			_heroAvail = true;
		}

		public function moveHero(key:String):void{
			
			switch(key){
				
				case Constant.KEY_LEFT:
					_hero.speedX = HERO_SPEED_BACKWARD;
					_hero.speedY = 0;
					_hero.heroStatus = Constant.HERO_STATUS_LEFT;
					_hero.showHero(2, 1);
				break;
				
				case Constant.KEY_RIGHT:
					_hero.speedX = HERO_SPEED_FORWARD;
					_hero.speedY = 0;
					_hero.heroStatus = Constant.HERO_STATUS_RIGHT;
					_hero.showHero(3, 1);
				break;
				
				case Constant.KEY_DOWN:
					_hero.speedX = 0;
					_hero.speedY = HERO_SPEED_FORWARD;
					_hero.heroStatus = Constant.HERO_STATUS_DOWN;
					_hero.showHero(1, 1);
				break;
				
				case Constant.KEY_UP:
					_hero.speedX = 0;
					_hero.speedY = HERO_SPEED_BACKWARD;
					_hero.heroStatus = Constant.HERO_STATUS_UP;
					_hero.showHero(0, 1);
				break;
				
				default:
				break;
			}
		}
		
		public function stopHero(status: String):void{
			
			_hero.speedX = 0;
			_hero.speedY = 0;
			
			switch(status){
				
				case Constant.HERO_STATUS_UP:
					_hero.showHero(0,0);
				break;
				case Constant.HERO_STATUS_DOWN:
					_hero.showHero(1,0);
				break;
				case Constant.HERO_STATUS_LEFT:
					_hero.showHero(2,0);
				break;
				case Constant.HERO_STATUS_RIGHT:
					_hero.showHero(3,0);
				break;
			}
		}
		
		public function checkHeroAvail():Boolean
		{
			if(_heroAvail)
				return true;
			else
				return false;
		}
	}
}