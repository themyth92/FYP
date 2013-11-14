package controller.chapterOne
{
	import constant.chapterOne.Constant;
	
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Rectangle;
	
	import object.chapterOne.Hero;
	import object.chapterOne.IndexBoard;
	
	import starling.display.Image;
	
	public class IndexBoardController
	{
		//index board var
		private var _numberOfCoin					:Number;
		private static const MAXIMUM_PATTERN		:uint   = 1;
		private static const LIST_COMMAND			:Array 	= [0,1];
		private static const CREATE_LENGTH_ARRAY	:uint   = 3;
		private static const DELETE_LENGTH_ARRAY 	:uint   = 2;
		private static const FALSE_LENGTH_ARRAY 	:uint   = 1;
		private static const COIN_TYPE				:String = "03";
		private static const HERO_TYPE				:String = "04";
		
		private static const MAXIMUM_COLUMN:uint 	 = 12;
		private static const MAXIMUM_ROW:uint        = 8;
		private static const PIXEL_MOVE:int 	     = 40;
		private static const BOARD_X:uint			 = 107;
		private static const BOARD_Y:uint			 = 82;
		
		private var _indexBoard 	: IndexBoard;
		
		//hero var
		private static const HERO_SPEED_FORWARD		:int = 3;
		private static const HERO_SPEED_BACKWARD	:int = -3;
		private var _hero 		  : Hero;
		
		public function IndexBoardController(board:IndexBoard)
		{
			this._indexBoard     = board;
			this._numberOfCoin 	 = 0;
			this._hero           = _indexBoard.hero;
		}
		
		/*-------------------------------------------------------------
		--------------------BOARD CONTROL FUNCTION---------------------
		---------------------------------------------------------------*/
		public function analyzeArrayInput(arr:Array):void
		{			
			if(arr.length == FALSE_LENGTH_ARRAY)
				return ;
			else if(arr.length == DELETE_LENGTH_ARRAY){				
				if(arr[0] == LIST_COMMAND[0]){
					var index:uint = arr[1];
					_indexBoard.deleteObject(index);
					return;
				}
			}
			else if(arr.length == CREATE_LENGTH_ARRAY){
				if(arr[0] == LIST_COMMAND[1]){
					
					index            = arr[2];
					var name :String = arr[1];
					updateCoinAmount(name);
					if(name != HERO_TYPE)
					{
						_indexBoard.createObject(name, index);
						return;
					}
					else if(_indexBoard.createHero(index))
						return;
					else
						trace("more hero");	
				}
			}
			
			trace('Array from console controller is not in defined format');
			return;
		}
		
		public function dragDropAnalyze(type:String, x:Number, y:Number):Number
		{
			_indexBoard.createObject(type,mousePositionToBoardIndex(x,y)); 
			return 0;
		}
		
		private function mousePositionToBoardIndex(x:Number, y:Number):Number
		{
			var modular		:int;
			var rowIndex	:uint = 0;
			var columnIndex	:uint = 0;
			var index		:uint;
			
			for(index=1;index<= MAXIMUM_ROW*MAXIMUM_COLUMN;index++)
			{
				modular = index % MAXIMUM_COLUMN;
				if(modular == 0){
					rowIndex    = int(index/MAXIMUM_COLUMN) - 1;
					columnIndex = MAXIMUM_COLUMN - 1; 
				}
				else{
					rowIndex    = int(index/MAXIMUM_COLUMN);
					columnIndex = modular - 1;
				}
				
				//if(columnIndex < 0 || rowIndex < 0){
					//trace('problem with finding the position of the pattern. Program should be paused for debugging');
					//return 0;
				//}
				
				if((((x - BOARD_X)- columnIndex*PIXEL_MOVE) <= PIXEL_MOVE) && (((y - BOARD_Y) - rowIndex*PIXEL_MOVE) <= PIXEL_MOVE))
					break;
			}
			return index;
		}
		
		public function checkCoinAvail():Boolean
		{
			if(_numberOfCoin <= 0)
				return false;
			else 
				return true;
		}
		
		private function updateCoinAmount(type:String):void
		{	
			if(type == COIN_TYPE)
				_numberOfCoin ++;
			return;
		}
		
		public function removeCoinOnCollision(index:uint):void
		{
			_indexBoard.deleteObject(index);
		}
		
		/*-------------------------------------------------------------
		--------------------HERO CONTROL FUNCTION----------------------
		---------------------------------------------------------------*/
		
		public function enableHero():void
		{
			_hero.enableHero();		
		}
		
		public function moveHero(key:String):void
		{
			switch(key){
				case Constant.KEY_LEFT:
					_hero.speedX = HERO_SPEED_BACKWARD;
					_hero.speedY = 0;
					_hero.heroStatus = Constant.HERO_STATUS_LEFT;
					_hero.showHero(2, 1);
					break;
				
				case Constant.KEY_RIGHT:
					_hero.speedX = HERO_SPEED_FORWARD;
					_hero.speedY = 0;
					_hero.heroStatus = Constant.HERO_STATUS_RIGHT;
					_hero.showHero(3, 1);
					break;
				
				case Constant.KEY_DOWN:
					_hero.speedX = 0;
					_hero.speedY = HERO_SPEED_FORWARD;
					_hero.heroStatus = Constant.HERO_STATUS_DOWN;
					_hero.showHero(1, 1);
					break;
				
				case Constant.KEY_UP:
					_hero.speedX = 0;
					_hero.speedY = HERO_SPEED_BACKWARD;
					_hero.heroStatus = Constant.HERO_STATUS_UP;
					_hero.showHero(0, 1);
					break;
				
				default:
					break;
			}
		}
		
		public function stopHero(status: String):void
		{
			_hero.speedX = 0;
			_hero.speedY = 0;
			
			switch(status)
			{		
				case Constant.HERO_STATUS_UP:
					_hero.showHero(0,0);
					break;
				case Constant.HERO_STATUS_DOWN:
					_hero.showHero(1,0);
					break;
				case Constant.HERO_STATUS_LEFT:
					_hero.showHero(2,0);
					break;
				case Constant.HERO_STATUS_RIGHT:
					_hero.showHero(3,0);
					break;
			}
		}
		
		public function checkHeroAvail():Boolean
		{
			if(_hero.heroEnable)
				return true;
			else
				return false;
		}
		
		public function collisionDetect(x:Number, y:Number):Array
		{
			var positionArr : Array;
			
			if(_indexBoard.patternCollection.length == 0)
			{
				positionArr = new Array(false);
			}
			else
			{
				var thingChecking : Vector.<Image> 	= _indexBoard.patternCollection;
				var thingType 	  : Vector.<String> = _indexBoard.patternType;
				var thingIndex	  : Vector.<uint> 	= _indexBoard.patternIndex;
				
				var collisionStatus : Boolean = false;
				
				var heroX : Number = _hero.x + x;
				var heroY : Number = _hero.y + y;
				
				var vx 	  : Number;
				var vy	  : Number;
				
				positionArr = new Array(false);
				
				for(var i:uint = 0; i < thingChecking.length; i++)
				{
					vx = (heroX + (_hero.width/2)) - (thingChecking[i].x + (thingChecking[i].width/2));
					vy = (heroY + (_hero.height/2)) - (thingChecking[i].y + (thingChecking[i].height/2));
					
					if(Math.abs(vx) < _hero.width/2 + thingChecking[i].width/2)
					{
						if(Math.abs(vy) < _hero.height/2 + thingChecking[i].height/2)
						{	
							var overlap_X	: Number = _hero.width/2 + thingChecking[i].width/2 - Math.abs(vx);
							var overlap_Y	: Number = _hero.height/2 + thingChecking[i].height/2 - Math.abs(vy);
							
							if(thingType[i] == COIN_TYPE)
							{
								positionArr = new Array(true,thingIndex[i]);
							}					
							else if(overlap_X >= overlap_Y)
							{			
								if(vy>0)
								{
									heroY = heroY + overlap_Y;
									collisionStatus = true;
								}
								else
								{
									heroY = heroY - overlap_Y;
									collisionStatus = true;
								}
								positionArr = new Array(collisionStatus,heroX-_hero.x, heroY-_hero.y);
							}
							else
							{
								if(vx>0)
								{
									heroX = heroX + overlap_X;
									collisionStatus = true;
								}
								else
								{
									heroX = heroX - overlap_X;
									collisionStatus = true;
								}
								positionArr = new Array(collisionStatus,heroX-_hero.x, heroY-_hero.y);
							}					
						}
						else
							positionArr = new Array (false);
					}
					else 
						positionArr = new Array (false);
					if(collisionStatus == true)
						return positionArr;
				}
			}
			return positionArr;
		}
	}
}