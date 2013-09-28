package assets
{
	public class Assets
	{	
		[Embed(source = '../media/font/GROBOLD.ttf', embedAsCFF = 'false', fontFamily = 'Grobold')]
		private static const GroboldFont:Class;
		
		public function Assets()
		{
		}
	}
}