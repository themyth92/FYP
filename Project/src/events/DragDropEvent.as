package events
{
	import starling.events.Event;
	
	public class DragDropEvent extends Event
	{
		public static const UPDATE 				= "updated";
		public static const OBJECT_PICKED_UP 	= "objectPickedUp";
		public static const OBJECT_DROPPED		= "objectDropped";
		
		public var _object	:	Object;
		
		public function DragDropEvent(type:String, bubbles:Boolean=false, object:Object=null)
		{
			super(type, bubbles, object;
			this._object = object;
		}
	}
}