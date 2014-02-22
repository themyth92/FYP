/******************************
 * ========================== *
 * CONTROLLER FOR INDEX BOARD *
 * ========================== * 
 ******************************/

package controller.chapterOne
{
	import constant.ChapterOneConstant;
	
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Rectangle;
	
	import object.chapterOne.Enemies;
	import object.chapterOne.Hero;
	import object.chapterOne.IndexBoard;
	
	import starling.display.Image;
	
	public class IndexBoardController
	{	
		//INDEX BOARD CONSTANT
		private static const LIST_COMMAND			:Array 	= [0,1];
		private static const MAXIMUM_PATTERN		:uint   = 1;
		private static const FALSE_LENGTH_ARRAY 	:uint   = 1;
		private static const DELETE_LENGTH_ARRAY 	:uint   = 2;
		private static const CREATE_LENGTH_ARRAY	:uint   = 3;
		private static const COIN_TYPE				:String = "03";
		private static const HERO_TYPE				:String = "04";
		
		private static const MAXIMUM_COLUMN			:uint 	= 12;
		private static const MAXIMUM_ROW			:uint   = 8;
		private static const PIXEL_MOVE				:uint 	= 40;
		private static const BOARD_X				:uint	= 107;
		private static const BOARD_Y				:uint	= 82;
		
		//CHARACTER CONSTANT
		private static const HERO_SPEED_FORWARD		:int 	= 3;
		private static const HERO_SPEED_BACKWARD	:int 	= -3;
		
		//INDEX BOARD VARIABLE
		private var _numberOfCoin					:Number;
		private var _indexBoard 					:IndexBoard;
		
		//CHARACTER VARIABLE
		private var _hero					 		:Hero;
		private var _enemy1							:Enemies;
		private var _enemy2							:Enemies;
		
		public function IndexBoardController(board:IndexBoard)
		{
			this._indexBoard     = board;
			this._numberOfCoin 	 = 0;
			this._hero           = _indexBoard.hero;
			this._enemy1         = _indexBoard.enemy1;
			this._enemy2		 = _indexBoard.enemy2;
		}

		/**================================================================
		 * |                    BOARD CONTROL FUNCTION                    | *
		 * ================================================================**/
		/*-----------------------------------------------------------------
		  | @Get input as an array                                        |
	      | @If array has 1 element  => incorrect array                   |
		  | @If array has 2 elements => delete command                    |
		  | @If array has 3 elements => create command                    |
		  -----------------------------------------------------------------*/	
		public function analyzeArrayInput(arr:Array):void
		{			
			//NO COMMAND             => DO NOTHING
			if(arr.length == FALSE_LENGTH_ARRAY)
				return;
			
			//DELETE COMMAND          => DELETE
			else if(arr.length == DELETE_LENGTH_ARRAY){				
				if(arr[0] == LIST_COMMAND[0]){
					var index:uint = arr[1];
					_indexBoard.deleteObject(index);
					return;
				}
			}
			
			//CREATE COMMAND 		  => CHECK WHAT TYPE
			//IF NOT "CHARACTER" TYPE => CREATE
			//IF "CHARACTER" TYPE     => CHECK WHETHER CHARACTER EXISTED 
			//IF NOT 				  => CREATE 
			//ELSE                    => DO NOTHING
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
						trace("more than one hero");	
				}
			}
			
			trace('Array from console controller is not in defined format');
			return;
		}
		
		/*---------------------------------------------------------------------
		| @notify indexboard controller                                       |
		-----------------------------------------------------------------------*/		
		public function dragDropAnalyze(type:String, x:Number, y:Number):Number
		{
			_indexBoard.createObject(type,mousePositionToBoardIndex(x,y)); 
			return 0;
		}
		
		/*----------------------------------------------------------------------
		| @Use to check mouse position ionn index board                        |
		| @Mouse position => index on index board                              |
		------------------------------------------------------------------------*/		
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
		
		/*-----------------------------------------------------------------------
		| @Check whether there is a coin                                        |		
		-------------------------------------------------------------------------*/	
		public function checkCoinAvail():Boolean
		{
			if(_numberOfCoin <= 0)
				return false;
			else 
				return true;
		}
		
		/*-----------------------------------------------------------------------
		| @Increase coin counter every time a coin is added                     |		
		-------------------------------------------------------------------------*/
		private function updateCoinAmount(type:String):void
		{	
			if(type == COIN_TYPE)
				_numberOfCoin ++;
			return;
		}
		
		/*----------------------------------------------------------------------
		| @Remove the coin once character collected it                         |
		| @Done by notify the indexboard controller                            |
		------------------------------------------------------------------------*/
		public function removeCoinOnCollision(index:uint):void
		{
			_indexBoard.deleteObject(index);
		}
		
		/**====================================================================
		 * |                    CHARACTER CONTROL FUNCTION                    | *
		 * ====================================================================**/
		
		/*----------------------------------------------------------------------
		| @To create character, enable it                                      |
		------------------------------------------------------------------------*/
		public function enableHero():void
		{
			_hero.enableHero();		
		}
		
		/*----------------------------------------------------------------------
		| @Move character corresponding to key detected                        |
		------------------------------------------------------------------------*/
		public function moveHero(key:String):void
		{
			switch(key){
				case ChapterOneConstant.KEY_LEFT:
					_hero.speedX 	 = HERO_SPEED_BACKWARD;
					_hero.speedY 	 = 0;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_LEFT;
					_hero.showHero(2, 1);
					break;
				
				case ChapterOneConstant.KEY_RIGHT:
					_hero.speedX 	 = HERO_SPEED_FORWARD;
					_hero.speedY 	 = 0;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_RIGHT;
					_hero.showHero(3, 1);
					break;
				
				case ChapterOneConstant.KEY_DOWN:
					_hero.speedX 	 = 0;
					_hero.speedY 	 = HERO_SPEED_FORWARD;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_DOWN;
					_hero.showHero(1, 1);
					break;
				
				case ChapterOneConstant.KEY_UP:
					_hero.speedX  	 = 0;
					_hero.speedY  	 = HERO_SPEED_BACKWARD;
					_hero.heroStatus = ChapterOneConstant.HERO_STATUS_UP;
					_hero.showHero(0, 1);
					break;
				
				default:
					break;
			}
		}
		
		/*----------------------------------------------------------------------
		| @Stop character once key-press released                              |
		------------------------------------------------------------------------*/
		public function stopHero(status: String):void
		{
			_hero.speedX = 0;
			_hero.speedY = 0;
			
			switch(status)
			{		
				case ChapterOneConstant.HERO_STATUS_UP:
					_hero.showHero(0,0);
					break;
				case ChapterOneConstant.HERO_STATUS_DOWN:
					_hero.showHero(1,0);
					break;
				case ChapterOneConstant.HERO_STATUS_LEFT:
					_hero.showHero(2,0);
					break;
				case ChapterOneConstant.HERO_STATUS_RIGHT:
					_hero.showHero(3,0);
					break;
			}
		}
		
		/*----------------------------------------------------------------------
		| @Check whether character created                                     |
		------------------------------------------------------------------------*/
		public function checkHeroAvail():Boolean
		{
			if(_hero.heroEnable)
				return true;
			else
				return false;
		}
		
		/*----------------------------------------------------------------------
		| @Check for collision between character and object                    |
		------------------------------------------------------------------------*/
		public function collisionDetect(x:Number, y:Number):Array
		{
			var positionArr : Array;
			
			if(_indexBoard.patternCollection.length == 0)
			{
				positionArr = new Array(false);
			}
			else
			{
				var objectToCheck : Vector.<Image> 	= _indexBoard.patternCollection;
				var objectType 	  : Vector.<String> = _indexBoard.patternType;
				var objectIndex	  : Vector.<uint> 	= _indexBoard.patternIndex;
				
				var collisionStatus : Boolean = false;
				
				var heroX : Number = _hero.x + x;
				var heroY : Number = _hero.y + y;
				
				var vx 	  : Number;
				var vy	  : Number;
				
				positionArr = new Array(false);
				
				for(var i:uint = 0; i < objectToCheck.length; i++)
				{
					vx = (heroX + (_hero.width/2)) - (objectToCheck[i].x + (objectToCheck[i].width/2));
					vy = (heroY + (_hero.height/2)) - (objectToCheck[i].y + (objectToCheck[i].height/2));
					
					if(Math.abs(vx) < _hero.width/2 + objectToCheck[i].width/2)
					{
						if(Math.abs(vy) < _hero.height/2 + objectToCheck[i].height/2)
						{	
							var overlap_X	: Number = _hero.width/2 + objectToCheck[i].width/2 - Math.abs(vx);
							var overlap_Y	: Number = _hero.height/2 + objectToCheck[i].height/2 - Math.abs(vy);
							
							if(objectType[i] == COIN_TYPE)
							{
								collisionStatus = true;
								positionArr = new Array(collisionStatus,objectIndex[i]);
								coinCollect();
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
								if(objectType[i] == "02")
								{
									takeDamage();
								}
								if(objectType[i] == "01")
								{
									win();
								}
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
								if(objectType[i] == "02")
								{
									takeDamage();
								}
								if(objectType[i] == "01")
								{
									win();
								}
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
	
		public function changeObjectState(currentState:String):void
		{
			this._indexBoard.changeState(currentState);
			this._hero.changeState(currentState);
		}	
		
		private function coinCollect():void
		{
			this._hero.changeCoin();
		}
		
		private function takeDamage():void
		{
			this._hero.changeLife(true, false);
		}
	
		private function win():void
		{
			
		}	
		
		public function updateLifeOnGameStart(value:Number):void
		{
			this._hero.updateMaxLife(value);
		}		
		/**====================================================================
		 * |                      ENEMIES CONTROL FUNCTION                    | *
		 * ====================================================================**/
		public function followPlayer(enemy:Enemies, heroX:Number, heroY:Number):Array
		{
			var positionArr: Array;
			if(!isNaN(heroX))
			{	
				var distanceX	:Number		= enemy.enemyX - (heroX + _hero.x);
				var distanceY	:Number		= enemy.enemyY - (heroY + _hero.y);
				var distance	:Number		= Math.sqrt(distanceX*distanceX + distanceY*distanceY);
				var enemyMoveX	:Number		= enemy.moveX;
				var enemyMoveY	:Number		= enemy.moveY;
				
				if(distance <= enemy.agroRange)
				{
					var moveX 	:Number		= enemy.turnRate * distanceX / distance;
					var moveY	:Number		= enemy.turnRate * distanceY / distance;
					
					enemyMoveX -= moveX;
					enemyMoveY -= moveY;
					
					var moveDistance	:Number		= Math.sqrt(enemyMoveX*enemyMoveX + enemyMoveY*enemyMoveY);
					
					enemyMoveX = enemy.speed * enemyMoveX / moveDistance;
					enemyMoveY = enemy.speed * enemyMoveY / moveDistance;
					
					positionArr = [enemyMoveX,enemyMoveY];
					return positionArr;
				}
				else
				{
					enemyMoveX = 0;
					enemyMoveY = 0;
					positionArr = [enemyMoveX,enemyMoveY];
					return positionArr;
				}
			}
			positionArr = [false];
			return positionArr;
		}
		
		private function patrolAround():void
		{
			//enemy.moveX
			//enemy.moveY
		}
		
		public function checkObstacleCollision():void
		{
			
		}
	}
}