package assets
{
	import constant.Constant;
	
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{	
		//embed the font
		[Embed(source = '../media/font/GROBOLD.ttf', embedAsCFF = 'false', fontFamily = 'Grobold')]
		private static const GroboldFont:Class;
		
		//embed the loading page sprite sheet
		[Embed(source = '../media/sprite/loadingPage/preLoader.png')]
		private static const AtlasTextureLoadingPage:Class;
		
		//embed the xml for the loading page sprite sheet
		[Embed(source = '../media/sprite/loadingPage/preLoader.xml', mimeType = 'application/octet-stream')]
		private static const AtlasXmlLoadingPage    :Class;
		
		private static var _gameTexture 	   :Dictionary = new Dictionary();
		private static var _gameTextureAtlas :Dictionary = new Dictionary();
		
		/*======================================
			@ get texture from a single string
			@ param : textureName
			@ the texture name will be the name 
		 	@ of the class that embeds the file 
			@ into flash
			@ return the texture according to 
			@ the name
		======================================*/
		public static function getTexture(textureName : String){
			
			//condition if the private gameTexture for a specific name has not been initialized
			//initialize it instead of creating a new texture
			if(_gameTexture[textureName] == undefined){
				
				//get texture from class in side assets class
				var bitmap = new Assets[textureName]();
				_gameTexture[textureName] = Texture.fromBitmap(bitmap);
			}
			
			return _gameTexture[textureName];
		}
		
		/*========================================
			@ get bitmap from the spiresheet
			@ param screen
			@ we will load the spritesheet according
			@ to the screen
			@ return a texture atlas object
		=========================================*/
		public static function getAtlas(screen:String):TextureAtlas{
			
			//condition if the textureAtlas has not got the object
			//initialize it
			if(_gameTextureAtlas[screen] == undefined){
				
				var texture 	  : Texture;
				var xml     	  : XML;
				var textureAtlas : TextureAtlas; 
				
				//switch case according to the sprite sheet we want to take from
				//it depends on the screen. e.g Loading Screen, Welcome screen, etc... 
				switch(screen){
					case Constant.LOADING_SCREEN:
						texture                   = getTexture('AtlasTextureLoadingPage');
						xml                       = XML(new AtlasXmlLoadingPage);
						textureAtlas              = new TextureAtlas(texture, xml);
						_gameTextureAtlas[screen] = textureAtlas;
					break;
				}
			}
			
			return _gameTextureAtlas[screen];
		}
		
		public static function storeGameTextureAtlas(TextureAtlas textureAtlas, String arrayName){
			this._gameTextureAtlas[arrayName] = textureAtlas;
		}
	}
}