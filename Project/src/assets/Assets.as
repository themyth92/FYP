/*

* Store and load the graphics from dictionary object

*/
package assets
{
	import constant.Constant;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{	
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
		private static function getTexture(textureName : String):Texture{
			
			//condition if the private gameTexture for a specific name has not been initialized
			//initialize it instead of creating a new texture
			if(_gameTexture[textureName] == undefined){
				
				//get texture from class in side assets class
				var bitmap:Bitmap = new Assets[textureName]();
				_gameTexture[textureName] = Texture.fromBitmap(bitmap);
			}
			
			return _gameTexture[textureName];
		}
		
		/*========================================
			@ get bitmap from the spiresheet
			@ param name
			@ we will load the spritesheet according
			@ to the name of the object in dictionary object
			@ return a texture atlas object
		=========================================*/
		public static function getAtlas(name:String):TextureAtlas{
			
			//condition if the textureAtlas has not got the object
			//initialize it
			if(_gameTextureAtlas[name] == undefined){
				
				var texture 	  : Texture;
				var xml     	  : XML;
				var textureAtlas  : TextureAtlas; 
				
				//switch case according to the sprite sheet we want to take from
				//it depends on the name of the sprite sheet from the constant class 
				switch(name){
					case Constant.LOADING_SCREEN:
						
						//try catch if the embeded image can not be found inside the project file
						try{
							texture                   = getTexture('AtlasTextureLoadingPage');
							xml                       = XML(new AtlasXmlLoadingPage);
						}
						catch(e:Error){
							trace(e);
							
							return null;
						}
						
						if(!storeAtlas(texture, xml, name))
							return null;
					break;
					
					//all the texture loaded from the loader class already
					//if it can not be founded inside the dictionary object then \
					//means that the the file has not been loaded or the name of the object in to
					//detect the file inside the dictionary is not correct
					//return null for both cases
					default:
						return null;
				}
			}
			
			return _gameTextureAtlas[name];
		}
		
		/*================================================================
		
			@store the atlas from files to the dictionary atlas object
			@param texture, xml : the content of xml file and spritesheet 
								  to create the textureAtlas object
			@param name : name of the dictionay object
			@return false if the texture or xml does not content anything
		
		=================================================================*/
		public static function storeAtlas(texture:Texture, xml:XML , name:String):Boolean{
			
			//check if both the object is null or not
			if(texture != null && xml !=null){
				
				//create texture atlas object and assign to dictionary
				var textureAtlas:TextureAtlas        = new TextureAtlas(texture, xml);
				_gameTextureAtlas[name] 			 = textureAtlas;	
				
				return true;
			}
			
			return false;
		}
	}
}
