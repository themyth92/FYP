package constant
{
	public class Constant
	{
<<<<<<< HEAD
		public static const GAME_LOADING : String       ='Game is loading ...';
		
		//custom event
		public static const TEXTURES_LOADED:String 	  = 'textureLoaded';
		
		//game windows
		public static const LOADING_SCREEN:String  	  = 'loadingScreen';
		
		//sprite sheet dictionary name
		public static const SPRITE_ONE:String      	  = 'spriteOne';
		public static const SPRITE_TWO:String           = 'spriteTwo';
		public static const SPRITE_THREE:String           = 'spriteThree';
		public static const SPRITE_FOUR:String           = 'spriteFour';
		
		//sprite sheet address
		public static const SPRITE_ONE_PNG_ADDR:String  = '../media/sprite/spriteSheet/sprite1.png';
		public static const SPRITE_ONE_XML_ADDR:String  = '../media/sprite/spriteSheet/sprite1.xml';
		public static const SPRITE_TWO_PNG_ADDR:String  = '../media/sprite/spriteSheet/sprite2.png';
		public static const SPRITE_TWO_XML_ADDR:String  = '../media/sprite/spriteSheet/sprite2.xml';
		public static const SPRITE_THREE_PNG_ADDR:String  = '../media/sprite/spriteSheet/sprite3.png';
		public static const SPRITE_THREE_XML_ADDR:String  = '../media/sprite/spriteSheet/sprite3.xml';
		public static const SPRITE_FOUR_PNG_ADDR:String  = '../media/sprite/spriteSheet/sprite4.png';
		public static const SPRITE_FOUR_XML_ADDR:String  = '../media/sprite/spriteSheet/sprite4.xml';
		
		//number
		public static const NUMBER_FILE_LOAD:uint       = 1;
		public static const PNG_ADDR:uint               = 0;
		public static const XML_ADDR:uint               = 1;
=======
		//game windows
		public static const LOADING_SCREEN:String  	       = 'loadingScreen';
		public static const FIRST_CHAPTER_FUNC_SCREEN:String = 'firstChapFunScreen';
		
		//sprite sheet dictionary name
		public static const SPRITE_ONE:String      	  	   = 'spriteOne';
		
		//sprite sheet address
		public static const SPRITE_ONE_PNG_ADDR:String  	   = '../media/sprite/spriteSheet/sprite1.png';
		public static const SPRITE_ONE_XML_ADDR:String  	   = '../media/sprite/spriteSheet/sprite1.xml';
		
		//number
		public static const NUMBER_FILE_LOAD:uint       	   = 1;
		public static const PNG_ADDR:uint                    = 0;	//this is the index of PNG file on 2D array, means the PNG always on the first column
		public static const XML_ADDR:uint                    = 1;	//and the XML always on the second column
		
		//Error
		public static const LOAD_FILE_PROBLEM:String         = 'Can not load file';
>>>>>>> origin/nhat
	}
}