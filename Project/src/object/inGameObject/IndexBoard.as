/*****************************************************
 * ================================================= *
 *                 INDEXBOARD OBJECT                 *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	import constant.StoryConstant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.NumericStepper;
	import feathers.controls.Radio;
	import feathers.core.ToggleGroup;
	import feathers.display.Scale9Image;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.errors.AbstractClassError;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class IndexBoard extends Sprite
	{
		//STATES VARIABLE
		private var _state 	:String = constant.ChapterOneConstant.INSTRUCTING_STATE;
		
		//CONSTANT
		private static const PATTERN_PREFIX:String	 = 'pattern_';
		private static const MAXIMUM_COLUMN:uint 	 = 11;
		private static const MAXIMUM_ROW:uint        = 9;
		private static const PIXEL_MOVE:int 	     = 40;
		private static const COIN_TYPE:String		 = "03";
		
		//TOUCH VARIABLES
		private var _touch			   :Touch;
		private var _touchArea		   :Quad = new Quad(480,320);
		private var _isTriggered	   :Boolean;
		
		//INDEXBOARD VARIABLES
		private var _patternCollection : Vector.<Image>;
		private var _patternType	   : Vector.<String>;
		private var _patternIndex      : Vector.<uint>;
		private var _maxCoin		   : Number = 0;
		private var _screen				:String;
		
		//HERO VARARIABLES
		private var _enemy1		   : Enemies;
		private var _enemy2		   : Enemies;
		private var _gotFollow		:Boolean = false;
		private var _gotPatrol		:Boolean = false;
		private var _hero	       : Hero;
		private var _controller	   : Controller;
		private var _heroIndex	   : uint;
		private var _dragType      : String;
		private var _testImg       : Image;
		private var _playerPos	   : Point;
		
		//AI PATH FINDING VARIABLES
		private var _tileVector : Vector.<Object>;
		private var _path	: Vector.<Point>;
		private var _startPoint1 : Point;
		private var _startPoint2 : Point;
		private var _endPoint	: Point;
		private var _endPoint2	: Vector.<Point>;
		private var _currPoint1	: Point;
		private var _currPoint2	: Point;
		private var _timer		: Number = 0;
		private var _enemyGo	: Boolean = false;
		private var _enemy1Found : Boolean = false;
		private var _currEnd : Number = 0;
		private var _distanceToEnd : Number;
		
		/** Constructor **/
		public function IndexBoard(controller:Controller)
		{
			this._controller   = controller;
			this._hero         = new Hero(_controller);
	
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this._touchArea.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/** Get Set **/
		public function get maxCoin():Number
		{
			return _maxCoin;
		}

		public function get patternCollection():Vector.<Image>
		{
			return _patternCollection;
		}

		public function get patternType():Vector.<String>
		{
			return _patternType;
		}
		
		public function get patternIndex():Vector.<uint>
		{
			return _patternIndex;
		}
		
		public function get hero():Hero
		{
			return _hero;
		}
		
		public function get enemy1():Enemies
		{
			return _enemy1;
		}
		
		public function get enemy2():Enemies
		{
			return _enemy2;
		}

		
		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		/** ADDED_TO_STAGE **/
		private function onAddedToStage(e:Event):void{
			
			this._touchArea.x 		= 0;
			this._touchArea.y 		= 0;
			this._touchArea.alpha 	= 0;
			
			this.addChild(_touchArea);
			
			_patternCollection = new Vector.<Image>();
			_patternIndex      = new Vector.<uint>();
			_patternType 	   = new Vector.<String>();
			
			this._tileVector = new Vector.<Object>();
			makeTiles();
			
			_screen = _controller.screen;
			if(_screen != Constant.CREATE_GAME_SCREEN)
				setupPattern();
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/** ENTER_FRAME **/
		private function onEnterFrame(event:Event):void
		{
			if(_screen == Constant.STORY_SCREEN_2)
			{
				if(_controller.stage2Info()[0])
				{
					var enemyIMG :Image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture('Enemy/Enemy_4'));
					var enemyPos :Point	= indexToPoint(StoryConstant.STAGE2_ENEMY_POS);
					enemyIMG.x = enemyPos.x;
					enemyIMG.y = enemyPos.y;
					this.addChild(enemyIMG);
				}
			}
			
			if(_state == constant.ChapterOneConstant.PLAYING_STATE)
			{
				_timer ++;
				updateHeroPosition();
				if(_gotFollow)
				{
					if(_enemy1.type == Constant.FOLLOW_TYPE)
						enemyGo(_enemy1);
					if(_enemy2.type == Constant.FOLLOW_TYPE)
						enemyGo(_enemy2);
				}
				if(_gotPatrol)
				{
					if(_enemy2.type == Constant.PATROL_TYPE)
						enemyPatrol(_enemy2);
					if(_enemy2.type == Constant.PATROL_TYPE)
						enemyPatrol(_enemy2);
				}
			}
		}
		
		private function setupPattern():void
		{
			var collection 	:Vector.<String>;
			var index		:Vector.<uint>;
			var type		:Vector.<String>;
			var pos			:uint;
			
			switch(_screen){
				case Constant.STORY_SCREEN_1:
					collection 	= StoryConstant.STAGE1_COLLECTION;
					index		= StoryConstant.STAGE1_INDEX;
					type		= StoryConstant.STAGE1_TYPE;
					pos			= StoryConstant.STAGE1_PLAYER_POS;
					patternToStage(collection,index,type,pos);
					break;
				case Constant.STORY_SCREEN_2:
					collection 	= StoryConstant.STAGE2_COLLECTION;
					index		= StoryConstant.STAGE2_INDEX;
					type		= StoryConstant.STAGE2_TYPE;
					pos			= StoryConstant.STAGE2_PLAYER_POS;
					patternToStage(collection,index,type,pos);
					break;
			}
		}
		
		private function patternToStage(collection:Vector.<String>,index:Vector.<uint>,type:Vector.<String>,pos:uint):void
		{
			var obstacles :Image;
			var walkable :Boolean = false;
			for(var i:uint=0; i<collection.length; i++)
			{
				obstacles = new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(collection[i]));
				_patternCollection.push(obstacles);
			}
			
			_patternIndex      = index;
			_patternType 	   = type;
			for(var j:uint=0; j<_patternType.length; j++)
			{
				if(_patternType[j] == COIN_TYPE)
				{
					_maxCoin ++;
					_controller.getGameStat("max coin", _maxCoin);
					walkable = true;						
				}
				positionObjectOnStage(_patternCollection[j], _patternIndex[j], walkable);				
			}
			
			createHero(pos);
		}
		
		private function updateHeroPosition():void
		{
			clearVisitedTiles();
			
			_endPoint.x = int(_hero.playerX / 40) * 40;
			_endPoint.y = int(_hero.playerY / 40) * 40;
		}
		
		private function clearVisitedTiles():void
		{
			var x :Number = int(_hero.playerX / 40);
			var y :Number = int(_hero.playerY / 40);
			for(var j:Number=0; j<9 ; j++)
			{
				_tileVector[x][j].visited = false;
			}
			
			for(var i:Number=0; i<11 ; i++)
			{
				_tileVector[i][y].visited = false;
			}
		}
		
		/** REMOVE_FROM_STAGE **/
		private function onRemoveFromStage	(e:Event):void
		{
			this._touchArea.removeEventListener(TouchEvent.TOUCH, onTouch);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/** MOUSE_TOUCH **/
		private function onTouch(event:TouchEvent):void
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE)
			{
				_touch = event.getTouch(this._touchArea);
				
				//IF USER DIDNT CHOOSE ANY OBJECT => DO NOTHING
				if(_isTriggered)
					if(_touch != null)
					{
						this._testImg.x = _touch.globalX - 41;
						this._testImg.y = _touch.globalY - 57;
						_testImg.touchable = false;
						this.addChild(_testImg);
						//IF MOUSE PRESSED
						if(_touch.phase == TouchPhase.ENDED) 
						{
							//ANALYZE INPUT: LOCATION OF THE MOUSE + OBJECT TYPE
							_controller.mouseInputAnalyze(_dragType, _touch.globalX, _touch.globalY);
							//READY FOR NEXT CHOICE OF OBJECT
							_isTriggered = false;
							this.removeChild(this._testImg);
						}
					}
			}
		}
		
		/** TURN ON TOUCH LISTENTER AFTER USER CHOOSE AN OBJECT FROM PATTERN LIST **/
		public function onTouchListener(isTriggered:Boolean, type: String):void
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE)
			{
				this._isTriggered 	= isTriggered;
				this._dragType      = type;
			}
		}
		
		
		/**====================================================================
		 * |	                 OBJECT CREATION   			                  | *
		 * ====================================================================**/
		/** CREATE OBJECT BASED ON TYPE AND INDEX **/
		public function createObject(name:String, index:uint):void
		{
			if((_state == constant.ChapterOneConstant.EDITTING_STATE && _screen == Constant.CREATE_GAME_SCREEN) || (_screen != Constant.CREATE_GAME_SCREEN))
			{
				this.deleteObject(index);
				
				var walkable:Boolean = false;
				try{
					
					var img:Image = new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(PATTERN_PREFIX + name));
					
					if(name == COIN_TYPE)
					{
						_maxCoin ++;
						_controller.getGameStat("max coin", _maxCoin);
						walkable = true;						
					}
					_patternCollection.push(img);
					_patternType.push(name);
					positionObjectOnStage(img, index, walkable);
				}
				catch(e:Error){
					
					trace('problem with finding the pattern');
				}
				
				_patternIndex.push(index);
			}
		}
		
		/**GET THE OBJECT'S LOCATION ON INDEXBOARD BASED ON INDEX **/
		private function positionObjectOnStage(obj:Image, index:uint, isWalkable:Boolean):void
		{	
				if(index > 0 && index <= MAXIMUM_ROW*MAXIMUM_COLUMN){
					
					var modular      : int = index % MAXIMUM_COLUMN;
					var rowIndex 	 : uint = 0;
					var columnIndex  : uint = 0;
					
					if(modular == 0){
						
						rowIndex    = int(index/MAXIMUM_COLUMN) - 1;
						columnIndex = MAXIMUM_COLUMN - 1; 
					}
					else{
						
						rowIndex    = int(index/MAXIMUM_COLUMN);
						columnIndex = modular - 1;
					}
					
					if(columnIndex < 0 || rowIndex < 0){
						trace('problem with finding the position of the pattern. Program should be paused for debugging');
						return;
					}
					_tileVector[columnIndex][rowIndex].walkable = isWalkable;
					
					obj.x = columnIndex	* PIXEL_MOVE;
					obj.y = rowIndex	* PIXEL_MOVE;
					
					this.addChild(obj);
				}
		}
		
		/** CREATE CHARACTER **/
		public function createHero(index:Number):Boolean
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE || _screen != Constant.CREATE_GAME_SCREEN)
			{
				var modular      : int  = index % MAXIMUM_COLUMN;
				var rowIndex 	 : uint = 0;
				var columnIndex  : uint = 0;
				
				_heroIndex = index;
				
				//IF NO CHARACTER CREATED => CREATED
				if(!_hero.heroEnable)
				{
					if(modular == 0)
					{
						rowIndex    = int(index/MAXIMUM_COLUMN) - 1;
						columnIndex = MAXIMUM_COLUMN - 1; 
					}
					else
					{
						rowIndex    = int(index/MAXIMUM_COLUMN);
						columnIndex = modular - 1;
					}
					
					_hero.x = columnIndex * PIXEL_MOVE;
					_hero.y = rowIndex	  * PIXEL_MOVE;
					
					_hero.initialX = _hero.x;
					_hero.initialY = _hero.y;
					
					this.addChild(_hero);
					_controller.updateUnits(null,null,_hero);
					
					_tileVector[columnIndex][rowIndex].end = true;
					_endPoint  = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
					_playerPos = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
					
					_enemyGo = true;
					return true;
				}
				else
					//IF CHARACTER CREATED => DO NOTHING
					return false;
			}
			else
				return false;
		}
		
		/**====================================================================
		 * |	                  OBJECT DELETION   			              | *
		 * ====================================================================**/
		/** DELETE OBJECT AT INDEX LOCATION **/
		public function deleteObject(index:uint):void
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE || _state == constant.ChapterOneConstant.PLAYING_STATE)
			{
				//IF INDEX GIVEN IS CHARACTER'S INDEX + CHARACTER CREATED 
				//=> DELETE CHARACTER
				if(index == _heroIndex && _hero.heroEnable)
				{
					this.deleteHero();						
					return;
				}
				
				//FIND THE OBJECT WITH INDEX IN THE LIST OF OBJECT
				//IF FOUND => DELETE
				for (var i:uint = 0 ; i < _patternIndex.length ; i++){
					if(_patternIndex[i] == index)
					{
						this.removeChild(_patternCollection[i]);
						_patternCollection.splice(i, 1);
						if(_patternType[i] == COIN_TYPE)
							_maxCoin --;
						_patternType.splice(i,1);
						_patternIndex.splice(i, 1);
						
						break;
					}
				}
			}
		}
		
		/** DELETE CHARACTERS **/ 
		public function deleteHero():void
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE)
			{
				if(_hero.heroEnable)
				{
					this.removeChild(_hero);
					_hero.heroEnable = false;
					return;
				}
				else
					return;
			}
		}
		
		
		/**====================================================================
		 * |	                   STATE HANDLER   			                  | *
		 * ====================================================================**/
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
		/**====================================================================
		 * |	                     AI HANDLERS			                  | *
		 * ====================================================================**/		
		private function makeTiles():void
		{
			var x:Number = 0;
			var y:Number = 0;
			for(var i:Number=0; i<11; i++)
			{
				_tileVector[i] = new Vector.<Object>();
				y = 0;
				for(var j:Number=0; j<9;j++)
				{
					_tileVector[i][j] = new Object();
					_tileVector[i][j].x = x;
					_tileVector[i][j].y	= y;
					_tileVector[i][j].start1 = false;
					_tileVector[i][j].start2 = false;
					_tileVector[i][j].end = false;
					_tileVector[i][j].walkable = true;
					_tileVector[i][j].visited = false;
					y += 40;
				}
				x += 40;
			}
		}
		
		private function getG(n1:Number, n2:Number):Number
		{
			return 1;
		}
		
		private function manhattan(p:Point):Number
		{
			return (Math.abs(p.x - _endPoint.x) + Math.abs(p.y - _endPoint.y));
		}
		
		private function insideField(p:Point,n1:Number,n2:Number):Boolean 
		{
			if ((p.x + n1 > (10*40)) ||(p.x + n1 < 0)|| ((p.y + n2) > (8*40))|| ((p.y + n2) <0)) 
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		private function enemyGo(enemy:Enemies):void
		{
			if(!_enemy1Found)
			{
				if(_timer == 60)
				{
					var savedPoint: Point;
					var minF:Number = 10000;
					
					for (var i:Number=-40; i<=40; i+=40) {
						for (var j:Number=-40; j<=40; j+=40) {
							if ((i!=0 && j==0)||(i==0 && j!=0)) {
								if(insideField(_currPoint1, i, j))
								{
									var o:Number = (_currPoint1.x + i) / 40;
									var u:Number = (_currPoint1.y + j) / 40;
									
									if((_tileVector[o][u].walkable) && (_tileVector[o][u].visited == false))
									{
										var g:Number = getG(i,j);
										var h:Number = manhattan(new Point((_currPoint1.x) + i,(_currPoint1.y) + j));
										var f:Number = g + h;
										if(f < minF)
										{
											minF = f;
											savedPoint = new Point((_currPoint1.x) + i,(_currPoint1.y) + j);
										}
									}
								}
							}
						}
					}	
					
					if(savedPoint)
					{
						if((savedPoint.x != _endPoint.x) || (savedPoint.y != _endPoint.y))
						{
							_enemy1.x = savedPoint.x;
							_enemy1.y = savedPoint.y;
							var m:Number = savedPoint.x / 40;
							var n:Number = savedPoint.y / 40;
							_tileVector[m][n].visited = true;	
						}
						_currPoint1 = savedPoint;
						_path.push(_currPoint1);
						
						if((savedPoint.x == _endPoint.x) && (savedPoint.y == _endPoint.y))
						{
							_enemy1Found = true;
						}
					}
					else
					{
						if(_path.length > 1)
						{
							_currPoint1 = _path[_path.length - 2];
							_enemy1.x = _currPoint1.x;
							_enemy1.y = _currPoint1.y;
							_path.pop();
						}
						else
						{
							trace("Can't be solved");
						}
					}
					_timer = 0;
				}
			}
		}
		
		private function enemyPatrol(enemy:Enemies):void
		{
			if(_enemy2.x == _endPoint2[_currEnd].x && _enemy2.y == _endPoint2[_currEnd].y)
			{
				_currPoint2.x = _endPoint2[_currEnd].x;
				_currPoint2.y = _endPoint2[_currEnd].y;
				_currEnd ++;
				if(_currEnd == 4)
					_currEnd = 0;
			}
			
			if(_enemy2.x == _endPoint2[_currEnd].x)
			{	
				_enemy2.y += (_endPoint2[_currEnd].y - _currPoint2.y) * _enemy2.speed;
				if (_endPoint2[_currEnd].y - _currPoint2.y < 0)
				{
					if (_enemy2.y < _endPoint2[_currEnd].y)
						_enemy2.y = _endPoint2[_currEnd].y;
				}
				else
				{
					if (_enemy2.y > _endPoint2[_currEnd].y)
						_enemy2.y = _endPoint2[_currEnd].y;
				}
			}
			else if(_enemy2.y == _endPoint2[_currEnd].y)
			{
				_enemy2.x += (_endPoint2[_currEnd].x - _currPoint2.x) * _enemy2.speed;
				if (_endPoint2[_currEnd].x - _currPoint2.x < 0)
				{
					if (_enemy2.x < _endPoint2[_currEnd].x)
						_enemy2.x = _endPoint2[_currEnd].x;
				}
				else
				{
					if (_enemy2.x > _endPoint2[_currEnd].x)
						_enemy2.x = _endPoint2[_currEnd].x;
				}
			}		
		}
		
		public function displayQuestion():void
		{
			var qns: Question = new Question("MCQ");
			this.addChild(qns);
		}
		
		public function createPlayer(pos:Number, gender:String):void
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE)
			{
				var modular      : int  = pos % MAXIMUM_COLUMN;
				var rowIndex 	 : uint = 0;
				var columnIndex  : uint = 0;
				
				_heroIndex = pos;
				
				//IF NO CHARACTER CREATED => CREATED
				if(!_hero.heroEnable)
				{
					if(modular == 0)
					{
						rowIndex    = int(pos/MAXIMUM_COLUMN) - 1;
						columnIndex = MAXIMUM_COLUMN - 1; 
					}
					else
					{
						rowIndex    = int(pos/MAXIMUM_COLUMN);
						columnIndex = modular - 1;
					}
					
					_hero.x = columnIndex * PIXEL_MOVE;
					_hero.y = rowIndex	  * PIXEL_MOVE;
					
					_hero.initialX = _hero.x;
					_hero.initialY = _hero.y;
					
					this.addChild(_hero);
					_controller.updateUnits(null,null,_hero);
					
					_tileVector[columnIndex][rowIndex].end = true;					
					_endPoint = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
					_playerPos = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
					
					_enemyGo = true;
					return;
				}
			}
		}
		
		private function indexToPoint(index:Number):Point
		{
			var modular      : int  = index % MAXIMUM_COLUMN;
			var rowIndex 	 : uint = 0;
			var columnIndex  : uint = 0;
			
			if(modular == 0)
			{
				rowIndex    = int(index/MAXIMUM_COLUMN) - 1;
				columnIndex = MAXIMUM_COLUMN - 1; 
			}
			else
			{
				rowIndex    = int(index/MAXIMUM_COLUMN);
				columnIndex = modular - 1;
			}
			var resultPts	:Point = new Point(columnIndex * PIXEL_MOVE, rowIndex * PIXEL_MOVE);
			
			return resultPts;
		}
		
		private function createFollowEnemies(enemyNo:Number, pos:Number, spd:Number, img:Number):void
		{
			if(enemyNo == 1)
			{
				_enemy1 = new Enemies(_controller, indexToPoint(pos).x, indexToPoint(pos).y, Constant.FOLLOW_TYPE, spd, img, 1);
				_gotFollow = true;
				_enemy1.x = indexToPoint(pos).x;
				_enemy1.y = indexToPoint(pos).y;
				
				this.addChild(_enemy1);
				_controller.updateUnits(_enemy1, null, null);
				
				for(var i:Number=0; i<11; i++)
				{
					for(var j:Number=0; j<9; j++)
					{
						if((_tileVector[i][j].x == _enemy1.x) && (_tileVector[i][j].y == _enemy1.y))
						{
							_tileVector[i][j].start1  = true;
							_tileVector[i][j].visited1 = true;
							_startPoint1 = new Point(_tileVector[i][j].x, _tileVector[i][j].y);
							_path        = new Vector.<Point>();
							_currPoint1  = new Point(_startPoint1.x, _startPoint1.y);
							break;
						}
					}
				}
			}
		}
		private function createPatrolEnemies(enemyNo:Number):void
		{
			
		}
		
		public function createEnemies(type:Array, speed:Array, image:Array, pos:Array):void
		{
			if(type[0] != 0)
			{
				if(type[0] == 1)
					createFollowEnemies(1, pos[0], speed[0], image[0]);
//				else if(type[0] == 2)
//					createPatrolEnemies(1, pos[0], speed[0], image[0]);
			}
			
			if(type[1] != 0)
			{
				//if(type[1] == 1)
				//	createFollowEnemies(2, pos[1], speed[1], image[1]);
				_enemy2 = new Enemies(_controller, indexToPoint(pos[1]).x, indexToPoint(pos[1]).y, Constant.PATROL_TYPE, speed[1], image[1], 2);
				_gotPatrol = true;
				_enemy2.x = indexToPoint(pos[1]).x;
				_enemy2.y = indexToPoint(pos[1]).y;	
					
				this.addChild(_enemy2);
				_controller.updateUnits(null, _enemy2, null);
				
				for(var m:Number=0; m<11; m++)
				{
					for(var n:Number=0; n<9; n++)
					{
						if((_tileVector[m][n].x == _enemy2.x) && (_tileVector[m][n].y == _enemy2.y))
						{
							_tileVector[m][n].start2  = true;
							_tileVector[m][n].visited = false;
							_endPoint2 = new Vector.<Point>();
							var endPoint : Point;
							endPoint = new Point (_enemy2.x, _enemy2.y - 80);
							_endPoint2.push(endPoint);
							endPoint = new Point (_enemy2.x + 80, _enemy2.y - 80);
							_endPoint2.push(endPoint);
							endPoint = new Point (_enemy2.x + 80, _enemy2.y);
							_endPoint2.push(endPoint);
							endPoint = new Point (_enemy2.x, _enemy2.y);
							_endPoint2.push(endPoint);
							
							_startPoint2 = new Point(_tileVector[m][n].x, _tileVector[m][n].y);
							_currPoint2  = new Point(_enemy2.x, _enemy2.y);
							break;
						}
					}
				}	
			}
		}
		
		public function finishStage():void
		{
			_controller.isWon = true;
		}
	}
}