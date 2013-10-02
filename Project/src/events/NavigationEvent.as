/*

 *The naviation event is used to navigate the Game class to different stage of the game
 *The usage of the class is the same as other event class in flash or starling event package	

*/

package events
{
	import starling.events.Event;
	
	public class NavigationEvent extends Event
	{ 
		//static string to call when add event listener
		public static const CHANGE_SCREEN : String = 'changeScreen';
		
		//the id of the stage of the game
		//for example loading, chapter1 etc ...
		private var _screenID : Object;
		
		//constructor
		public function NavigationEvent(type:String, params:Object = null, bubbles : Boolean = false)
		{
			//inherit from the event class
			super(type, bubbles);
			
			this._screenID = params;
		}

		public function get screenID():Object
		{
			return _screenID;
		}
	}
}