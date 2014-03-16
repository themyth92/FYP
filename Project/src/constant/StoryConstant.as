package constant
{
	import constant.Constant;
	
	import flash.geom.Point;
	
	import starling.display.Image;

	public class StoryConstant
	{
		/**====================================================================
		 * |	                     	STAGE 1 		                      | *
		 * ====================================================================**/
		public static const STAGE1_COLLECTION	:Vector.<String> = new <String>["pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00",
																					"pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","pattern_00","Goal","Goal"];
		public static const STAGE1_INDEX	  	:Vector.<uint> = new <uint>[4,8,15,19,23,24,25,26,30,31,32,33,
																				67,68,69,70,74,75,76,77,81,85,92,96,6,94];
		public static const STAGE1_TYPE		  	:Vector.<String> = new <String>["00","00","00","00","00","00","00","00",
																				"00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","goal","goal"];
		public static const STAGE1_PLAYER_POS 	:uint		= 45;
		
		public static const STAGE1_INSTRUCTION	:Array = new Array('My master is in danger. We need to hurry up and help him.',
																   'I have hacked into the game system, we should be able to freely control him now.',
																   'Use the arrow buttons to move him around. Reach the exit to escape this stage.');
		
		/**====================================================================
		 * |	                     	STAGE 2 		                      | *
		 * ====================================================================**/
		public static const STAGE2_INSTRUCTION	:Array = new Array("Great work! We reached the 'Saphiran Forest' stage.",
																   "Let's continue, our destination is the 'Lunatic Castle'.",
																   "WATCH OUT! There is a monster coming.",
																   "There is no time to run, use this 'Console' power to block the monster way",
																   "Type 'Create(brick,57)' to create a brick there and stop the monster's movement",
																   "Nice one! You did it. The monster got trapped and cannot pass through the brick.",
																   "Now let's me explain what happened.",
																   "The 'Console' power allow you to create certain objects in specific location. It works as a 'function' in programming.",
																   "Huh, you do not know about programming? Well, it is a good thing to learn, it gives you a logical mindset when solving problem.",
																   "So basically, a 'function' works like any other machine, it takes in input from users and returns output.",	
																   "Just now you gave it input of 'brick' and '56'. As defined, 'function' will understand 'brick' as the type of object and '56' is the location.",
																   "Then it will produce output for you as creating a brick at location index 56.",
																   "OK, I think that's enough information for now. Let's get out of this forest before more monster coming");
		public static const STAGE2_INSTR_CONSOLE_CHECK	:Number = 4;
		public static const STAGE2_INSTR_SHOW_CONSOLE	:Number = 3;
		public static const STAGE2_INSTR_SHOW_MONSTER	:Number = 2;
		public static const STAGE2_CORRECT_CONSOLE		:String	= "create(brick,57)";
		public static const STAGE2_ERROR_GUIDER1			:String	= "Don't mess around. We don't have time. Type in 'Create(brick,57)' quickly.";
		public static const STAGE2_ERROR_GUIDER2			:String	= "Almost there, check again. You may make a mistake.";
		public static const STAGE2_ENEMY_POS			:uint = 68;
		public static const STAGE2_INSTR_ARROW_POS		:Point = new Point();
		public static const STAGE2_SHOW_ARROW_INDEX		:Number = 3;
		
		public static const STAGE2_COLLECTION	:Vector.<String> = new <String>["green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees",
																				"green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees",
																				"green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees","green_trees",
																				"red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees",
																				"red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees",
																				"red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees",
																				"red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","red_trees","Goal"];
		public static const STAGE2_INDEX	  	:Vector.<uint> = new <uint>[1,2,3,4,5,6,7,8,9,10,11,
																			12,13,14,15,16,17,18,19,20,21,22,
																			23,24,25,26,27,28,29,30,31,32,33,
																			56,58,59,60,61,62,63,64,65,
																			67,69,70,71,72,73,74,75,76,
																			78,79,80,81,82,83,84,85,86,87,
																			89,90,91,92,93,94,95,96,97,98,99];
		public static const STAGE2_TYPE		  	:Vector.<String> = new <String>["00","00","00","00","00","00","00","00","00","00","00",
																				"00","00","00","00","00","00","00","00","00","00","00",
																				"00","00","00","00","00","00","00","00","00","00","00",
																				"00","00","00","00","00","00","00","00","00",
																				"00","00","00","00","00","00","00","00","00",
																				"00","00","00","00","00","00","00","00","00","00",
																				"00","00","00","00","00","00","00","00","00","00","goal"]; 
		
		public static const STAGE2_PLAYER_POS	:uint	= 45;
		/**====================================================================
		 * |	                     	STAGE 3 		                      | *
		 * ====================================================================**/
		public static const STAGE3_INSTRUCTION	:Array	= new Array("Great! We found the 'Cave of Greenvil' stage.",
																	"After we passed this cave, we will reach the castle in no time.",
																	"Look out! There are 'Patrolling' guards at the entrance of the Cave. Seems like it is not gonna be easy passing through them.",
																	"What did you say? We cannot block them using the 'brick'. It will block our only way into the cave too.",
																	"And that evil Gauro only gave my Master 1 life.",
																	"Huh? How do I know? Look at the top. There is a number beside the 'heart' icon, that indicates how many lives the player have. If it reaches 0, the game ends.",
																	"Can we get more? That's a good question. Let's me think.",
																	"Nice thought! I will hack into the system so that you can update my Master life to a certain number so he won't die easily. Wait!",
																	"There you go. Click on the 'heart' icon to update the life.",
																	"There is 3 guards, so 4 or 5 lives for this stage should be enough.",
																	"Great work! Since this is 'Patrolling' guards only, they wont chase after my Master. Just run pass them to enter the cave.",
																	"That takes care of them. Now remember, if you want to make a game, dont ever do like the evil Gauro. Give the player a decent number of lives, otherwise, your game would be too hard or even not winable.",
																	"Keep that in mind and let's keep moving.");
		
		/**====================================================================
		 * |	                     	STAGE 4		                      | *
		 * ====================================================================**/
		public static const STAGE4_INSTRUCTION	:Array	= new Array("It's too creepy in here. It's dark and...",
																	"WATCH OUT! We entered a stage. Monsters incoming. There's a lot of them this time.",
																	"LOOK! The exit is over there. That's a long way to go. Something fishy is going on.",
																	"WHAT! This stage gives us only 5 seconds to reach the exit. That evil Gauro.",
																	"Wait, follow my instruction. Click on the clock.",
																	"Great! Now change the time to '1:30', which means 1 minutes and 30 seconds. That should be enough for us to get to the exit.",
																	"Dont forgot to change the 'hearth' also. It will be changed to the initialized value for that stage. So you need to watch out.",
																	"Ok! Once you've done, Press 'Start' to begin the stage.",
																	"We exited the cave. Now you see the important of the time you gave the player. If it's too little, your game turns out to be too difficult or again not winable.",
																	"Give a approriate amount of time if you ever made a game. OK?");

		/**====================================================================
		 * |	                     	STAGE 5 		                      | *
		 * ====================================================================**/
		public static const STAGE5_INSTRUCTION	:Array	= new Array("Now that's evil castle is Lunatic Castle. Always shine by the light of the moon, no sun.",
																	"Let's head in");

		
		
	}
}