package assets
{
	public class EmbededAssets
	{
		//embed the font
		[Embed(source = '../media/font/GROBOLD.ttf', embedAsCFF = 'false', fontFamily = 'Grobold')]
		private static const GroboldFont:Class;
		
		//embed the loading page sprite sheet
		[Embed(source = '../media/sprite/spriteSheet/sprite1.png')]
		private static const AtlasTextureLoadingPage:Class;
		
		//embed the xml for the loading page sprite sheet
		[Embed(source = '../media/sprite/spriteSheet/sprite1.xml', mimeType = 'application/octet-stream')]
		private static const AtlasXmlLoadingPage    :Class;
		
		public function EmbededAssets()
		{
		}
	}
}