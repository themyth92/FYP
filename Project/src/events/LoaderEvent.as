package events
{
	import flash.events.Event;
	
	public class LoaderEvent extends Event
	{ 
		
		public static const TEXTURE_LOADING:String  =  'textureLoading';
		public static const TEXTURE_LOADED :String  =  'textureLoaded' ; 
		
		public function LoaderEvent(type:String, bubbles : Boolean = true, cancelable:Boolean = false )
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new LoaderEvent(type, bubbles, cancelable);
		}
	}
}