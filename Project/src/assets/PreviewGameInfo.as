package assets
{
	public class PreviewGameInfo
	{
		public static var _playerPos	:uint;
		public static var _playerGender	:String;
		
		public static var _enemyAmount	:uint;
		public static var _enemyType	:Array;
		public static var _enemyPos		:Array;
		public static var _enemySpd		:Array;
		public static var _enemyImg		:Array;
		
		public static var _maxCoin		:uint;
		public static var _maxLife		:uint;
		public static var _minStart		:uint;
		public static var _secStart		:uint;
		
		public static var _obsCollection:Vector.<String>;
		public static var _obsIndex		:Vector.<uint>;
		public static var _obsType		:Vector.<String>;
		
		public static function storeScreenInfo(playerObj:Object, enemyObj:Object, scoreObj:Object, obstaclesObj:Object):void
		{
			storeScoreInfo(scoreObj);
			storeEnemyInfo(enemyObj);
			storePlayerInfo(playerObj);
			storeObstaclesInfo(obstaclesObj);
		}
		
		private static function storeScoreInfo(scoreObj:Object):void
		{
			_maxCoin 	= scoreObj.maxCoin;
			_maxLife 	= scoreObj.maxLife;
			_minStart 	= scoreObj.minStart;
			_secStart 	= scoreObj.secStart;
		}
		
		private static function storeEnemyInfo(enemyObj:Object):void
		{
			_enemyAmount 	= enemyObj.amount;
			_enemyType 		= new Array(enemyObj.enemy1[0], enemyObj.enemy2[0]);
			_enemyPos 		= new Array(enemyObj.enemy1[1], enemyObj.enemy2[1]);
			_enemySpd 		= new Array(enemyObj.enemy1[2], enemyObj.enemy2[2]);
			_enemyImg 		= new Array(enemyObj.enemy1[3], enemyObj.enemy2[3]);
		}
		
		private static function storePlayerInfo(playerObj:Object):void
		{
			_playerPos 		= playerObj.pos;
			_playerGender  	= playerObj.gender;
		}
		
		private static function storeObstaclesInfo(obsObj:Object):void
		{
			_obsCollection 	= obsObj.collection;
			_obsIndex 		= obsObj.index;
			_obsType		= obsObj.type;
		}
	}
}