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
		/**====================================================================
		 * |	                        SCREENS     			              | *
		 * ====================================================================**/
		public static const LOADING_SCREEN				:String = 'loadingScreen';
		public static const FIRST_CHAPTER_SCREEN		:String = 'firstChapScreen';
		public static const MAIN_SCREEN					:String = 'mainScreen';
		public static const CREATE_GAME_SCREEN			:String	= 'createScreen';
		public static const ABOUT_SCREEN				:String = 'aboutScreen';
		public static const STORY_SCREEN_1				:String	= 'storyStage1';
		public static const STORY_SCREEN_2				:String	= 'storyStage2';
		public static const STORY_SCREEN_3				:String	= 'storyStage3';
		public static const STORY_SCREEN_4				:String	= 'storyStage4';
		public static const STORY_SCREEN_5				:String	= 'storyStage5';
		public static const GAME_OVER_SCREEN			:String	= 'gameOver';
		public static const PREVIEW_SCREEN				:String = 'previewScreen';
		public static const PREVIEW_LOADER				:String = 'previewLoader';
		
		/**====================================================================
		 * |	                  SPRITESHEET NAME   			              | *
		 * ====================================================================**/
		//sprite sheet dictionary name
		public static const COMMON_ASSET_SPRITE			:String = 'commonAssetSprite';
		public static const PLAYER_SPRITE				:String = 'playerSprite';
		public static const OBSTACLES_SPRITE			:String	= 'obstacleSprite';
		public static const SPRITE_ONE					:String	= 'spriteOne';
		public static const SCREEN_SPRITE				:String = 'spriteScreen';
		public static const BACKGROUND_SPRITE			:String	= 'bgSprite';
		
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
		
		public static const ENEMY_SPRITE_TEXTURE:Array			= new Array('Enemy/Enemy_1', 'Enemy/Enemy_2', 'Enemy/Enemy_3', 'Enemy/Enemy_4', 'Enemy/Enemy_5', 'Enemy/Enemy_6');
		//font
		public static const GROBOLD_FONT: String              = 'Grobold';
		
		/**====================================================================
		 * |	                    IMAGE POSITION   			              | *
		 * ====================================================================**/
		public static const FRAME_CREATE_POS	:Point		= new Point(30 , 50);
		public static const FRAME_STORY_POS		:Point		= new Point(160, 50);
		public static const CONSOLE_CREATE_POS	:Point		= new Point(525, 50);
		public static const CONSOLE_PLAY_POS	:Point		= new Point(640, 70);
		public static const GRID_CREATE_POS		:Point		= new Point(41 , 57);
		public static const GRID_STORY_POS		:Point		= new Point(171 , 57);
		public static const INFOBOARD_POS		:Point		= new Point(545, 0);
		public static const PREVIEWB_POS		:Point		= new Point(30 , 450);
		public static const STARTB_POS			:Point		= new Point(190, 450);
		public static const PUBLISHB_POS		:Point		= new Point(360, 450);
		public static const DIALOGUE_POS		:Point		= new Point(60 , 450);
		public static const OBSBOARD_POS		:Point		= new Point(15, 145);
		public static const GUIDER_POS			:Point		= new Point(10, 470);
		public static const ESCB_POS			:Point		= new Point(749,1);
		
		/**====================================================================
		 * |                  OBJECT NAME IN SPRITESHEET   			          | *
		 * ====================================================================**/
		/* Common Assets SpriteSheet */
		public static const DIALOGUE_IMG	:String		= "Dialogue";
		public static const FRAME_IMG		:String		= "mainFrame";
		public static const GUIDER_IMG		:String		= "GameGuider";
		public static const CLOCK_IMG		:String		= "Clock";
		public static const LIFE_IMG		:String		= "Life";
		public static const ESCB_IMG		:String		= "escButton";
		public static const HELPB_IMG		:String		= "helpButton";
		public static const COIN_IMG		:String		= "Coin";
		public static const INFO_BOARD		:String		= "InformationBoard";
		
		/* Create SpriteSheet */
		public static const GRID_IMG		:String		= "Grid";
		public static const INFOBOARD_IMG	:String		= "InformationBoard";
		public static const PLAYB_IMG		:String		= "Play_Button";
		public static const PREVIEWB_IMG	:String		= "Preview_Button";
		public static const PUBLISHB_IMG	:String		= "Publish_Button";
		public static const INPUTBOX_IMG	:String		= "InputBox";
		
		/* Screens SpriteSheet */
		public static const STAGE1_SCREEN	:String		= "Stage1Screen";
		public static const STAGE2_SCREEN	:String		= "Stage2Screen";
		public static const STAGE3_SCREEN	:String		= "Stage3Screen";
		public static const STAGE4_SCREEN	:String		= "Stage4Screen";
		public static const STAGE5_SCREEN	:String		= "Stage5Screen";
		public static const	CREATE1_SCREEN	:String		= "GrassScreen";
		public static const CREATE2_SCREEN	:String		= "WaterScreen";
		
		/* Background SpriteSheet */
		public static const BG_STAGE1		:String		= "Background_Stage1";
		public static const BG_STAGE2		:String		= "Background_Stage2";
		public static const BG_STAGE3		:String		= "Background_Stage3";
		public static const BG_STAGE4		:String		= "Background_Stage4";
		public static const BG_STAGE5		:String		= "Background_Stage5";
		public static const BG_CREATE		:String		= "Background_Create";
		
		/**====================================================================
		 * |	                  OBJECT INFORMATION  			              | *
		 * ====================================================================**/
		public static const CONSOLE_WIDTH	:uint 		= 190;
		public static const CONSOLE_HEIGTH	:uint		= 33;
		
		public static const FOLLOW_TYPE	:String = "Follow Enemy";
		public static const PATROL_TYPE	:String = "Patrol Enemy";
		
		/**====================================================================
		 * |  		                  QUESTION TYPE   			              | *
		 * ====================================================================**/
		public static const SHORT_QUESTION	:String	= "shortQns";
		public static const MCQ_QUESTION 	:String = "mcqQns";
		
		/**====================================================================
		 * |  		                  	STATES   			             	  | *
		 * ====================================================================**/
		public static const INSTRUCTING_STATE		:String					= 'INSTRUCTING';
		public static const EDITTING_STATE  		:String					= 'EDITTING';
		public static const PLAYING_STATE			:String					= 'PLAYING';
		public static const ENDING_STATE			:String					= 'ENDING';
		
		/**====================================================================
		 * |  		                  	SIGNALS   			             	  | *
		 * ====================================================================**/
		public static const DIALOG_CHANGE	: String = "nextDialog";
		public static const BUTTON_PRESS	: String = "buttonPressed";
		public static const CONSOLE_ENTER	: String = "consoleEnterPressed";
		public static const STATE_CHANGE	: String = "stateChange";
		public static const	ERROR_NOTIFY1	: String = "errorNotify1";
		public static const	ERROR_NOTIFY2	: String = "errorNotify2";
	}
}