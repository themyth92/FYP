package object.CreateGameObject 	
{
	import assets.Assets;
	
	import constant.Constant;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ObstacleObj extends Image
	{
		//keep track of the obstacle type 
		// 0 : obstacle
		// 1 : prize
		// 3 : ...
		private var _obstacleType 	: Number;
		
		//boolean varaible to check whethere this
		//texture is user defined or available in the system
		private var _isUserDefText	: Boolean;
		
		//variable to store the texture index in both user defined
		//obstacle and texture available in the system
		private var _textureIndex 	: Number;
		
		//useful for publishing the game 
		private var _textureAddress:String;
		
		public function ObstacleObj(texture: Texture, 
									  isUserDef: Boolean, 
									  index:Number, 
									  textureAddres:String = null,
									  obstacleType:Number = 0):void
		{
			super(texture);
			
			//assign the texture to new class
			this.texture  			= texture;
			
			//assign to dectect user defined or available texture
			this._isUserDefText 	= isUserDef;
			
			this._textureIndex		= index;
			
			//the address of texture
			//will be used for user defined texture
			this._textureAddress	= textureAddres;
		}	
		
		public function get textureAddress():String
		{
			return _textureAddress;
		}

		public function set textureAddress(value:String):void
		{
			_textureAddress = value;
		}

		public function get textureIndex():Number
		{
			return _textureIndex;
		}

		public function set textureIndex(value:Number):void
		{
			_textureIndex = value;
		}

		public function get isUserDefText():Boolean
		{
			return _isUserDefText;
		}

		public function set isUserDefText(value:Boolean):void
		{
			_isUserDefText = value;
		}

		public function get obstacleType():Number
		{
			return _obstacleType;
		}

		public function set obstacleType(value:Number):void
		{
			_obstacleType = value;
		}
	}
}