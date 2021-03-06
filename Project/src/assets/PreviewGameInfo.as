package assets
{
	import constant.Constant;
	
	import flash.geom.Point;
	
	import starling.display.Image;

	public class PreviewGameInfo
	{
		public static var _isSaved		:Boolean = false;
		public static var _isPlay		:Boolean = false;
		
		public static var _gameTitle	:String = "Test Title";
		public static var _gameScreen	:Object = {isUserDef:true, textureIndex:0};
		public static var _gameID		:String;
		
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
		
		public static var _obsTexture	:Vector.<Object>	= new Vector.<Object>();
		public static var _obsCollection:Vector.<Image> 	= new Vector.<Image>();
		public static var _obsIndex		:Vector.<uint> 		= new Vector.<uint>();
		public static var _obsType		:Vector.<String> 	= new Vector.<String>();
		public static var _obsQns		:Vector.<Object> 	= new Vector.<Object>();
		public static var _obsPara		:Vector.<Number>	= new Vector.<Number>();
		
		public static var _screenIndex	:Number;
		
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
			else 
				_enemy1EndPts = Vector.<Number>(enemyObj[0].endPts);
				
			if(endPoint2 != null)
				_enemy2EndPts = endPoint2;
			else
				_enemy2EndPts = Vector.<Number>(enemyObj[1].endPts);
		}
		
		public static function storePlayerInfo(playerObj:Object):void
		{
			_playerPos 		= playerObj.pos;
			_playerGender  	= playerObj.gender;
		}
		
		public static function storeObstaclesInfo(obsObj:Array):void
		{
			var obsTexture	: Image;
			var qns			: Object;
			
			_obsCollection = new Vector.<Image>();
			_obsIndex = new Vector.<uint>();
			_obsQns = new Vector.<Object>();
			_obsTexture = new Vector.<Object>();
			_obsType = new Vector.<String>();
			_obsPara = new Vector.<Number>();
			
			for(var i:uint = 0; i < obsObj.length; i++)
			{
				//Get obstalces' image
				if(obsObj[i].isUserDef)
					obsTexture = new Image(Assets.getUserTexture()[obsObj[i].textureIndex].texture);
				else
				{
					if(obsObj[i].textureIndex != 17)
						obsTexture = new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture("pattern_" + formatLeadingZero(obsObj[i].textureIndex)));
					else
						obsTexture = new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture("Goal"));
				}
				//Store images into vector
				_obsCollection.push(obsTexture);
				_obsTexture.push({isUserDef:obsObj[i].isUserDef,textureIndex:obsObj[i].textureIndex});
				
				//Store obstacles' position on grid
				_obsIndex.push(obsObj[i].pos);
				
				//Store obstacles' type
				_obsType.push(formatLeadingZero(obsObj[i].type));
				_obsPara.push(0);
				if(formatLeadingZero(obsObj[i].type) == "02")
				{
					if(obsObj[i].prop.typ == 2)
					{
						_obsType.pop();
						_obsType.push("03");
					}
					else if(obsObj[i].prop.typ == 3)
					{
						_obsType.pop();
						_obsType.push("06");
						_obsPara.pop();
						_obsPara.push(obsObj[i].prop.para);
					}
					else if(obsObj[i].prop.typ == 4)
					{
						_obsType.pop();
						_obsType.push("04");
						_obsPara.pop();
						_obsPara.push(obsObj[i].prop.para);
					}
				}
				
				//Store obstacles' question
				if(obsObj[i].qnsIndex != 0 && obsObj[i].qnsIndex != -1)
				{
					qns 	 = new Object();
					qns.gotQns	 = true;
					qns.qnsIndex = obsObj[i].qnsIndex;
				}
				else
				{
					qns		 = new Object();
					qns.gotQns 	 = false;
					qns.qnsIndex = 0;
				}
				_obsQns.push(qns);
			}
		}
		
		private static function formatLeadingZero(value:Number):String{
			return (value < 10) ? "0" + value.toString() : value.toString();
		}
	}
}
