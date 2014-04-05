package assets
{
	import constant.Constant;
	
	import flash.geom.Point;
	
	import starling.display.Image;

	public class PreviewGameInfo
	{
		public static var _gameTitle	:String = "Test Title";
		public static var _gameScreen	:Object = {isUserDef:true, textureIndex:0};
		
		public static var _playerPos	:uint;
		public static var _playerGender	:String;
		
		public static var _enemyType	:Array;
		public static var _enemyPos		:Array;
		public static var _enemySpd		:Array;
		public static var _enemyImg		:Array;
		public static var _enemy1EndPts	:Vector.<Number>;
		public static var _enemy2EndPts	:Vector.<Number>;
		
		public static var _maxCoin		:uint;
		public static var _maxLife		:uint;
		public static var _minStart		:uint;
		public static var _secStart		:uint;
		
		public static var _obsCollection:Vector.<Image> 	= new Vector.<Image>();
		public static var _obsIndex		:Vector.<uint> 		= new Vector.<uint>();
		public static var _obsType		:Vector.<String> 	= new Vector.<String>();
		public static var _obsQns		:Vector.<Object> 	= new Vector.<Object>();
		
		public static var _screenIndex	:Number;
		
		public static function storeScreenInfo(playerObj:Object, enemyObj:Array, scoreObj:Object, obstaclesObj:Array):void
		{
			storeScoreInfo(scoreObj);
			//storeEnemyInfo(enemyObj);
			storePlayerInfo(playerObj);
			storeObstaclesInfo(obstaclesObj);
		}
		
		public static function storeScoreInfo(scoreObj:Object):void
		{
			_maxCoin 	= scoreObj.maxCoin;
			_maxLife 	= scoreObj.maxLife;
			_minStart 	= scoreObj.minStart;
			_secStart 	= scoreObj.secStart;
		}
		
		public static function storeEnemyInfo(enemyObj:Array, endPoint1:Vector.<Number>, endPoint2:Vector.<Number>):void
		{
			_enemyType 		= new Array(enemyObj[0].type, enemyObj[1].type);
			_enemyPos 		= new Array(enemyObj[0].pos, enemyObj[1].pos);
			_enemyImg 		= new Array(enemyObj[0].textureIndex, enemyObj[1].textureIndex);
			_enemySpd 		= new Array(enemyObj[0].speed, enemyObj[1].speed);
			if(endPoint1 != null)
				_enemy1EndPts = endPoint1;
			if(endPoint2 != null)
				_enemy2EndPts = endPoint2;
		}
		
		public static function storePlayerInfo(playerObj:Object):void
		{
			_playerPos 		= playerObj.pos;
			_playerGender  	= playerObj.gender;
		}
		
		public static function storeObstaclesInfo(obsObj:Array):void
		{
			var obsTexture	: Image;
			for(var i:uint = 0; i < obsObj.length; i++)
			{
				//Get obstalces' image
				if(obsObj[i].isUserDef)
					obsTexture = new Image(Assets.getUserTexture()[obsObj[i].textureIndex].texture);
				else
					obsTexture = new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture("pattern_" + formatLeadingZero(obsObj[i].textureIndex)));
				//Store images into vector
				_obsCollection.push(obsTexture);
				
				//Store obstacles' position on grid
				_obsIndex.push(obsObj[i].pos);
				
				//Store obstacles' type
				_obsType.push(formatLeadingZero(obsObj[i].type));
				
				//Store obstacles' question
				if(obsObj[i].qnsIndex != null)
				{
					var qns 	 = new Object();
					qns.gotQns	 = true;
					qns.qnsIndex = obsObj[i].qnsIndex;
				}
				else
				{
					var qns		 = new Object();
					qns.gotQns 	 = false;
					qns.qnsIndex = -1;
				}
				_obsQns.push(qns);
			}
		}
		
		private static function formatLeadingZero(value:Number):String{
			return (value < 10) ? "0" + value.toString() : value.toString();
		}
	}
}
