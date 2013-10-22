package constant.chapterOne
{
	public class Constant
	{
		public static const CONSOLE:String     	 	   = 'consoleNote';
		public static const SPRITE_ONE:String      	   = 'spriteOne';
		public static const BUBBLE_DIALOG:String         = 'dialogBubble';
		public static const NEXT_ARROW:String            = 'nextArrow';
		
		//function
		public static const GROBOLD_FONT: String   	   = 'Grobold';
		public static const TEXTFIELD_WIDTH:uint   	   = 216;
		public static const TEXTFIELD_HEIGTH:uint  	   = 235;
		
		public static const CONSOLE_NORMAL:String        = 'Console/ConsoleNormal';
		public static const CONSOLE_FOCUS:String         = 'Console/ConsoleFocus';
		
		public static const NOTE_POSX:uint         	   = 0;
		public static const NOTE_POSY:uint         	   = 0;
		public static const TEXTFIELD_POSX:uint    	   = 17;
		public static const TEXTFIELD_POSY:uint    	   = 87;
		
		public static const SUBMIT_NORMAL:String   	   = 'submitBtn/submitBtn_01';
		public static const SUBMIT_DISABLED:String 	   = 'submitBtn/submitBtn_02';
		public static const SUBMIT_HOVER:String    	   = 'submitBtn/submitBtn_04';
		public static const SUBMIT_CLICK:String    	   = 'submitBtn/submitBtn_03';
		
		public static const HERO_MALE_STAND:Array        = new Array('Male/male_up_01', 'Male/male_down_01','Male/male_left_01', 'Male/male_right_01');
		public static const HERO_MALE_RUN:Array          = new Array('Male/male_up_', 'Male/male_down_', 'Male/male_left_', 'Male/male_right_');
		
		public static const HERO_STATUS_LEFT:String      = 'left';
		public static const HERO_STATUS_RIGHT:String     = 'right';
		public static const HERO_STATUS_UP:String        = 'up';
		public static const HERO_STATUS_DOWN:String      = 'down';
		
		/* Dialog bubble */
		public static const DIALOG_NEXT_ARROW:String     = 'dialogNextArrow';
		public static const DIALOG_TEXTFIELD_WIDTH:uint  = 200;
		public static const DIALOG_TEXTFIELD_HEIGHT:uint = 200;
		public static const DIALOG_POSX:uint             = 30;
		public static const DIALOG_POSY:int              = -10;
		public static const DIALOG_ARROW_POSX:uint       = 0;
		public static const DIALOG_ARROW_POSY:uint       = 0;
		
		public static const WELCOME_DIALOG:String	       = 'Welcome to our class. Please click the arrow below to continue the conversation.';
		public static const DIALOG:Array                 = new Array('In this class, we assume that you do not know anything about programming.',
																		'We will teach you about the fundamental concept of creating a game.',
																		'Let us start with what is a function ???.',
																		'A function is like a command that you use to control everything inside a game',
																		'Do you see the box on the left which the blue arrow is pointing to.',
																		'Let us create a brick on the screen. ',
																		'You should follow the exact instruction. If not a red sign will appear to show you if your texts are false.',
																		'Type in the box "createBrick()" and press the submit button.');
		/* Arrow instruction */
		public static const INSTRUC_ARROW_LEFT:String   = 'arrowInsLeft';
		public static const INSTRUC_ARROW_RIGHT:String  = 'arrowInsRight';
		
		/* Submit Button */
		public static const SUBMIT_BTN:String           = 'submitBtn';
		/* Event */
		public static const TRIGGER : String  			= 'trigger';
 	}
}