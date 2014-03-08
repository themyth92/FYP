/*****************
 * ============= *
 * GAME CONSTANT *
 * ============= *
 *****************/

package constant
{
	import flash.geom.Point;

	public class Constant
	{
		//game windows
		public static const LOADING_SCREEN				:String = 'loadingScreen';
		public static const FIRST_CHAPTER_SCREEN		:String = 'firstChapScreen';
		public static const MAIN_SCREEN					:String = 'mainScreen';
		public static const CREATE_GAME_SCREEN			:String	= 'createScreen';
		public static const ABOUT_SCREEN				:String = 'aboutScreen';
		
		//sprite sheet dictionary name
		public static const SPRITE_ONE:String      	  	     = 'spriteOne';
		public static const CHARACTERS_SPRITE	:String		= 'spriteCharacter';
		public static const SCREEN_SPRITE		:String		= 'spriteScreen';
		
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
		
		//Object position
		public static const FRAME_POS		:Point		= new Point(30 , 50);
		public static const CONSOLE_POS		:Point		= new Point(525, 50);
		public static const GRID_POS		:Point		= new Point(41 , 57);
		public static const INFOBOARD_POS	:Point		= new Point(500, 30);
		public static const PREVIEWB_POS	:Point		= new Point(30 , 420);
		public static const STARTB_POS		:Point		= new Point(190, 420);
		public static const PUBLISHB_POS	:Point		= new Point(350, 420);
		public static const DIALOGUE_POS	:Point		= new Point(60 , 450);
		public static const OBSBOARD_POS	:Point		= new Point(15, 85);
		//Object Image
		public static const CONSOLE_IMG		:String		= "Console";
		public static const DIALOGUE_IMG	:String		= "Dialogue";
		public static const GRID_IMG		:String		= "Grid";
		public static const INFOBOARD_IMG	:String		= "InformationBoard";
		public static const PLAYB_IMG		:String		= "Play_Button";
		public static const PREVIEWB_IMG	:String		= "Preview_Button";
		public static const PUBLISHB_IMG	:String		= "Publish_Button";
		public static const RADIOYES_IMG	:String		= "Radio (tick)";
		public static const RADIONO_IMG		:String		= "Radio (untick)";
		public static const FRAME_IMG		:String		= "mainFrame";
		public static const INPUTBOX_IMG	:String		= "InputBox";
		
		//Object Information
		public static const CONSOLE_WIDTH	:uint 		= 190;
		public static const CONSOLE_HEIGTH	:uint		= 33;
		
		public static const FOLLOW_TYPE	:String = "followEnemy";
		public static const PATROL_TYPE	:String = "patrolEnemy";
	}
}