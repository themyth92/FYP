/******************************
 * ========================== *
 * CONTROLLER FOR INDEX BOARD *
 * ========================== * 
 ******************************/

package controller.ObjectController
{
	import constant.ChapterOneConstant;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.TextArea;
	
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import object.inGameObject.Enemies;
	import object.inGameObject.Hero;
	import object.inGameObject.IndexBoard;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	
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
		
		private static const MAXIMUM_COLUMN			:uint 	= 11;
		private static const MAXIMUM_ROW			:uint   = 9;
		private static const PIXEL_MOVE				:uint 	= 40;
		private static const BOARD_X				:uint	= 41;
		private static const BOARD_Y				:uint	= 57;
		
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
		private var _isDisplayedQuiz:Boolean;
		
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
			return;
		}
		
		public function createPlayer(position: Number, gender:String):void
		{
			_indexBoard.createPlayer(position, gender);
		}
		
		public function createEnemies(type:Array, speed:Array, image:Array, position:Array):void
		{
			_indexBoard.createEnemies(type, speed, image, position);
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
								if(objectType[i] == "Question")
								{
									popUpQuestion();
								}
								if(objectType[i] == "goal")
								{
									wonTheStage();
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
								if(objectType[i] == "Question")
								{
									popUpQuestion();
								}
								if(objectType[i] == "goal")
								{
									wonTheStage();
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
	
		private function popUpQuestion():void
		{
			if(!_isDisplayedQuiz)
			{
				_indexBoard.displayQuestion();
				this._isDisplayedQuiz = true;
			}
		}	
		
		public function updateLifeOnGameStart(value:Number):void
		{
			this._hero.updateMaxLife(value);
		}		
		
		private function wonTheStage():void
		{
			_indexBoard.finishStage();
		}
		
		private function checkPlayerCollideEnemy():void
		{
			var isCollided	:Boolean;
			var collisionRe	:Array;
			
			if(_indexBoard.enemyList.length == 0)
			{
				isCollided = false;
				collisionRe = new Array(isCollided);
			}
			else
			{
				var enemyList	:Vector.<Enemies> = _indexBoard.enemyList;
				
				var playerX		:Number = this._indexBoard.hero.playerX;
				var playerY		:Number = this._indexBoard.hero.playerY;
				var vx			:Number;
				var vy			:Number;
					
				for(var i:uint = 0; i<enemyList.length; i++)
				{
					vx = (playerX + (_hero.width/2)) - (enemyList[i].enemyX + (enemyList[i].image.width/2));
					vx = (playerY + (_hero.height/2)) - (enemyList[i].enemyY + (enemyList[i].image.height/2));
					
					if(Math.abs(vx) < _hero.width/2 + enemyList[i].image.width/2)
					{
						if(Math.abs(vy) < _hero.height/2 + enemyList[i].image.height/2)
						{	
							var overlap_X	: Number = _hero.width/2 + enemyList[i].image.width/2 - Math.abs(vx);
							var overlap_Y	: Number = _hero.height/2 + enemyList[i].image.height/2 - Math.abs(vy);
							
							if(overlap_X > overlap_Y)
							{
								if(vy>0)
								{
									playerY = playerY + overlap_Y;
									isCollided = true;
								}
								else
								{
									playerY = playerY - overlap_Y;
									isCollided = true;
								}
							}
						}
					}
				}
			}
		}
		/**====================================================================
		 * |                      ENEMIES CONTROL FUNCTION                    | *
		 * ====================================================================**/
	}
}