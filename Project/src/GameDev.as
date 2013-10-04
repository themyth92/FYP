package
{
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	import main.Game;
	
	[SWF(frameRate='60', width='1100', height='800', backgroundColor='0x3333333')]
	public class GameDev extends Sprite
	{
		//the attributes for display game FPS
		//useful for optimization the project
		private var _stats:Stats;
		
		//create main starling attributes
		private var _myGame:Starling;
		
		public function GameDev()
		{
			_stats  			 = new Stats();
			
			_myGame 			 = new Starling(Game, stage);
			_myGame.antiAliasing = 1;
			_myGame.start();

			this.addChild(_stats);			
		}
	}
}