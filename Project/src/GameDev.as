package
{
	import feathers.system.DeviceCapabilities;
	
	import flash.display.Sprite;
	
	import main.Game;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(frameRate='60', width='800', height='600', backgroundColor='0x3333333')]
	
	public class GameDev extends Sprite
	{
		//the attributes for display game FPS
		//useful for optimization the project
		private var _stats:Stats;
		
		//create main starling attributes
		private var _myGame:Starling;
		
		public function GameDev()
		{
			DeviceCapabilities.dpi = 326;
			_stats  			 = new Stats();
			
			_myGame 			 = new Starling(Game, stage);
			_myGame.antiAliasing = 1;
			_myGame.start();

			this.addChild(_stats);			
		}
	}
}