/*********************************
 * ============================= *
 * CONTROLLER FOR MAIN CHARACTER *
 * ============================= * 
 *********************************/

package controller.ObjectController
{
	import constant.ChapterOneConstant;
	
	import object.inGameObject.Hero;
	
	public class HeroController
	{					
		private static const HERO_SPEED_FORWARD		:int = 3;
		private static const HERO_SPEED_BACKWARD	:int = -3;
		
		private var _hero 		  : Hero;
		
		public function HeroController(hero:Hero)
		{
			this._hero = hero;
		}

		public function enableHero():void
		{
			_hero.enableHero();		
		}

		public function moveHero(key:String):void{
			
			switch(key){
				case ChapterOneConstant.KEY_LEFT:
					_hero.speedX = HERO_SPEED_BACKWARD;
					_hero.speedY = 0;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_LEFT;
					_hero.showHero(2, 1);
				break;
				
				case ChapterOneConstant.KEY_RIGHT:
					_hero.speedX = HERO_SPEED_FORWARD;
					_hero.speedY = 0;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_RIGHT;
					_hero.showHero(3, 1);
				break;
				
				case ChapterOneConstant.KEY_DOWN:
					_hero.speedX = 0;
					_hero.speedY = HERO_SPEED_FORWARD;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_DOWN;
					_hero.showHero(1, 1);
				break;
				
				case ChapterOneConstant.KEY_UP:
					_hero.speedX = 0;
					_hero.speedY = HERO_SPEED_BACKWARD;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_UP;
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
				
				case ChapterOneConstant.HERO_STATUS_UP:
					_hero.showHero(0,0);
				break;
				case ChapterOneConstant.HERO_STATUS_DOWN:
					_hero.showHero(1,0);
				break;
				case ChapterOneConstant.HERO_STATUS_LEFT:
					_hero.showHero(2,0);
				break;
				case ChapterOneConstant.HERO_STATUS_RIGHT:
					_hero.showHero(3,0);
				break;
			}
		}
	}
}