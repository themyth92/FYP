/*
	father class of 3 types classes inside the screen package
	This class will be used to access all the common function that 
	all the subclass use without using the child class
*/
package screen
{
	import starling.display.Sprite;
	
	public class Screen extends Sprite implements IScreen
	{
		public function Screen()
		{
			super();
		}
		
		public function quitCurrentActiveScreen():void
		{
			
		}
		
		public function resetCurrentActiveScreen():void
		{
			
		}
		
		public function pauseGame():void
		{
			
		}
	}
}