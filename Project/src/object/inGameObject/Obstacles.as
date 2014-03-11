package object.inGameObject
{
	import constant.ChapterOneConstant;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Obstacles extends Sprite
	{		
		private var _type	:String;
		private var _image	:Image;
		
		public function Obstacles()
		{
			super();
		}

		public function get image():Image
		{
			return _image;
		}

		public function set image(value:Image):void
		{
			_image = value;
		}

		public function get type():String
		{
			return _type;
		}
	}
}