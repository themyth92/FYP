/*****************
 * ============= *
 * GAME CONSTANT *
 * ============= *
 *****************/

package constant
{
	public class Constant
	{
		//game windows
		public static const LOADING_SCREEN:String  	         = 'loadingScreen';
		public static const FIRST_CHAPTER_FUNC_SCREEN:String = 'firstChapFuncScreen';
		public static const FIRST_CHAPTER_GRAP_SCREEN:String = 'firstChapGrapScreen';
		public static const FIRST_CHAPTER_PHYS_SCREEN:String = 'firstChapPhysScreen';
		
		//sprite sheet dictionary name
		public static const SPRITE_ONE:String      	  	     = 'spriteOne';
		
		//sprite sheet address
		public static const SPRITE_ONE_PNG_ADDR:String  	 = '../media/sprite/spriteSheet/sprite1.png';
		public static const SPRITE_ONE_XML_ADDR:String  	 = '../media/sprite/spriteSheet/sprite1.xml';
		
		//number
		public static const NUMBER_FILE_LOAD:uint       	 = 1;
		public static const PNG_ADDR:uint                    = 0;	//this is the index of PNG file on 2D array, means the PNG always on the first column
		public static const XML_ADDR:uint                    = 1;	//and the XML always on the second column
		
		//Error
		public static const LOAD_FILE_PROBLEM:String         = 'Can not load file';
		
		//Chapter 1 object dictionary
		public static const CHAP_ONE_TEXTURE_ARRAY:Array     = new Array('background', 'mainFrame','grassBackground',
															   				'heart','bottomSelectionFrame',
																			'pattern/pattern_03','teacher',
															   				'volumeDecBtn', 'volumeBar',
															   				'volumeIncBtn', 'volumeSlider');
		//font
		public static const GROBOLD_FONT: String              = 'Grobold';
	}
}