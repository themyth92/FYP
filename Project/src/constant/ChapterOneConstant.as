/**********************
 * ================== *
 * CHAPTER 1 CONSTANT *
 * ================== *
 **********************/

package constant
{
	public class ChapterOneConstant
	{
		public static const CONSOLE					:String     	 	    = 'consoleNote';
		public static const SPRITE_ONE				:String      	     	= 'spriteOne';
		public static const BUBBLE_DIALOG			:String         		= 'dialogBubble';
		
		//function
		public static const GROBOLD_FONT			:String			   	    = 'Grobold';
		
		
		/* Console */
		public static const TEXTFIELD_WIDTH			:uint   	     		= 151;
		public static const TEXTFIELD_HEIGTH		:uint  	    			= 32;
		
		public static const CONSOLE_NORMAL			:String        			= 'Console/ConsoleNormal';
		public static const CONSOLE_FOCUS			:String        			= 'Console/ConsoleFocus';
		
		public static const NOTE_POSX				:uint         	    	= 0;
		public static const NOTE_POSY				:uint         	   		= 0;
		
		public static const TEXTFIELD_POSX			:uint    	    		= 10;
		public static const TEXTFIELD_POSY			:uint    	     		= 67;
		
		public static const WARNING_SIGN  			:String       			= 'warningSign';
		
		public static const HERO_MALE_STAND			:Array        			= new Array('Player - Male/male_up_01', 'Player - Male/male_down_01','Player - Male/male_left_01', 'Player - Male/male_right_01');
		public static const HERO_MALE_RUN			:Array         			= new Array('Player - Male/male_up_', 'Player - Male/male_down_', 'Player - Male/male_left_', 'Player - Male/male_right_');
		
		/* Dialog bubble */
		public static const DIALOG_TEXTFIELD_WIDTH	:uint  					= 200;
		public static const DIALOG_TEXTFIELD_HEIGHT	:uint					= 200;
		public static const DIALOG_POSX				:uint             		= 10;
		public static const DIALOG_POSY				:int              		= -20;
		public static const DIALOG_ARROW_POSX		:uint       			= 0;
		public static const DIALOG_ARROW_POSY		:uint       			= 0;
		
		public static const WELCOME_DIALOG			:String	     			= 'Welcome to our class. Please click the arrow below to continue the conversation.';
		public static const DIALOG					:Array                	= new Array('In this class, we assume that you do not know anything about programming.',
																						'We will teach you about the fundamental concept of creating a game.',
																						'Let us start with what is a function ???.',
																						'A function is like a command that you use to control everything inside a game',
																						'Do you see the box on the left which the blue arrow is pointing to.',
																						'Let us create a brick on the screen. ',
																						'You should follow the exact instruction. If not a red sign will appear to show you if your texts are false.',
																						'Type in the box "create(brick,12)" and press the submit button.');
		/* Arrow instruction */
		public static const INSTRUC_ARROW_LEFT		:String   				= 'arrowInsLeft';
		public static const INSTRUC_ARROW_RIGHT		:String  				= 'arrowInsRight';
		
		/* Event */
		public static const TRIGGER 				:String  		    	= 'trigger';
		public static const KEY_PRESSED				:String    	   			= 'keyPressed';
		public static const KEY_RELEASED			:String   	    		= 'keyReleased';
		
		/* Argumemt */
		public static const KEY_LEFT				:String       	    	= 'keyLeft';
		public static const KEY_RIGHT				:String      	    	= 'keyRight';
		public static const KEY_DOWN				:String       	    	= 'keyDown';
		public static const KEY_UP					:String         	    = 'keyUp'; 
		
		public static const HERO_STATUS_LEFT		:String     			= 'left';
		public static const HERO_STATUS_RIGHT		:String    				= 'right';
		public static const HERO_STATUS_UP			:String       			= 'up';
		public static const HERO_STATUS_DOWN		:String     			= 'down';
		
		/* Target */
		public static const HERO					:String           	    = 'hero';
		public static const NEXT_ARROW				:String           		= 'nextArrow';
		public static const DIALOG_NEXT_ARROW		:String    				= 'dialogNextArrow';
		public static const SUBMIT_BTN				:String           		= 'submitBtn';
		public static const PREVIEW_BTN				:String          		= 'previewBtn';
		
		/* Stages */
		public static const INSTRUCTING_STATE		:String					= 'INSTRUCTING';
		public static const EDITTING_STATE  		:String					= 'EDITTING';
		public static const PLAYING_STATE			:String					= 'PLAYING';
		public static const ENDING_STATE			:String					= 'ENDING';
		
		/* Object types */
		public static const BRICK					:String					= "00";
		public static const XBOX					:String					= "01";
		public static const FIRE					:String					= "02";
		public static const COIN					:String 				= "03";
		public static const MALE_HERO				:String					= "04";
		public static const FEMALE_HERO				:String					= "05";
		
		/* Signal */
		public static const DIALOG_CHANGE	: String = "nextDialog";
		public static const BUTTON_PRESS	: String = "buttonPressed";
		public static const CONSOLE_ENTER	: String = "consoleEnterPressed";
		public static const STATE_CHANGE	: String = "stateChange";
		public static const	ERROR_NOTIFY1	: String = "errorNotify1";
		public static const	ERROR_NOTIFY2	: String = "errorNotify2";
		
		/* Obstacles type */
		public static const BLOCK_TYPE		:String	= "blockType";
		public static const DAMAGE_TYPE		:String = "damageType";
		public static const COLLECT_TYPE	:String	= "collectType";
		public static const QUESTION_TYPE	:String = "questionType";
		public static const GOAL_TYPE		:String = "goalType";
		
 	}
}