package object.CreateGameObject 	
{
	import assets.Assets;
	
	import constant.Constant;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ObstacleObj
	{
		private static const PATTERN_PREFIX:String  = 'pattern_'; 
		
		private var _obstacleImage : Image;
		
		public function ObstacleObj()
		{

		}	

		public function getObstacleTexture():Image
		{
			return this._obstacleImage;
		}
		
		public function setObstacleTexture(texture:Texture, name:String):void
		{
			if(name != null){	
				this._obstacleImage = new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(PATTERN_PREFIX + name));
			}
			else
				if(texture != null){
					this._obstacleImage = new Image(texture);
				}
				else
					return;
		}
		
		public function setObstaclePos(x:Number, y:Number):void{
			
			this._obstacleImage.x = x;
			this._obstacleImage.y = y;
		}
	}
}