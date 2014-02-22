/*****************************************************
 * ================================================= *
 *                 INDEXBOARD OBJECT                 *
 * ================================================= * 
 *****************************************************/

package object.chapterOne
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.chapterOne.Controller;
	
	import feathers.controls.NumericStepper;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class IndexBoard extends Sprite
	{
		//STATES VARIABLE
		private var _state 	:String = constant.ChapterOneConstant.INSTRUCTING_STATE;
		
		//CONSTANT
		private static const PATTERN_PREFIX:String	 = 'pattern/pattern_';
		private static const MAXIMUM_COLUMN:uint 	 = 12;
		private static const MAXIMUM_ROW:uint        = 8;
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
		
		//HERO VARARIABLES
		private var _enemy1		   : Enemies;
		private var _enemy2		   : Enemies;
		private var _hero	       : Hero;
		private var _controller	   : Controller;
		private var _heroIndex	   : uint;
		private var _dragType      : String;
		private var _testImg       : Image;
		
		//AI PATH FINDING VARIABLES
		private var _tileVector    : Vector.<Object>;
		private var _path		   : Vector.<Point>;
		private var _startPoint1   : Point;
		private var _startPoint2   : Point;
		private var _endPoint	   : Point;
		private var _endPoint2	   : Vector.<Point>;
		private var _currPoint1	   : Point;
		private var _currPoint2	   : Point;
		private var _timer		   : Number = 0;
		private var _enemyGo	   : Boolean = false;
		private var _enemy1Found   : Boolean = false;
		private var _currEnd : Number = 0;
		private var _distanceToEnd : Number;
		
		/** Constructor **/
		public function IndexBoard(controller:Controller)
		{
			this._controller   = controller;
			this._hero         = new Hero(_controller);
			
			this._enemy1 = new Enemies(_controller, 0, 0, "slowEnemy");
			this._enemy2 = new Enemies(_controller, 160, 160, "fastEnemy");
			_enemy1.x = 0;
			_enemy1.y = 0;
			_enemy2.x = 160;
			_enemy2.y = 160;
			
			this._tileVector = new Vector.<Object>();
			makeTiles();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this._touchArea.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		/** Get Set **/
		public function get maxCoin():Number
		{
			return _maxCoin;
		}
		
		public function set maxCoin(value:Number):void
		{
			_maxCoin = value;
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

		/** Event Function **/
		/** ADDED_TO_STAGE **/
		private function onAddedToStage(e:Event):void{
			
			this._touchArea.x 		= 0;
			this._touchArea.y 		= 0;
			this._touchArea.alpha 	= 0;
			
			this.addChild(_touchArea);
		
			this.addChild(_enemy1);
			_controller.updateUnits(_enemy1, null, null);
			for(var i:Number=0; i<12; i++)
			{
				for(var j:Number=0; i<8; i++)
				{
					if((_tileVector[i][j].x == _enemy1.x) && (_tileVector[i][j].y == _enemy1.y))
					{
						_tileVector[i][j].start1  = true;
						_tileVector[i][j].visited = true;
						_startPoint1 = new Point(_tileVector[i][j].x, _tileVector[i][j].y);
						_path        = new Vector.<Point>();
						_currPoint1  = new Point(_startPoint1.x, _startPoint1.y);
						break;
					}
				}
			}
			
			this.addChild(_enemy2);
			_controller.updateUnits(null, _enemy2, null);
			for(var m:Number=0; m<12; m++)
			{
				for(var n:Number=0; n<8; n++)
				{
					if((_tileVector[m][n].x == _enemy2.x) && (_tileVector[m][n].y == _enemy2.y))
					{
						_tileVector[m][n].start2  = true;
						_tileVector[m][n].visited = false;
						_endPoint2 = new Vector.<Point>();
						var endPoint : Point;
						endPoint = new Point (160, 40);
						_endPoint2.push(endPoint);
						endPoint = new Point (280, 40);
						_endPoint2.push(endPoint);
						endPoint = new Point (280, 160);
						_endPoint2.push(endPoint);
						endPoint = new Point (160, 160);
						_endPoint2.push(endPoint);
						
						_startPoint2 = new Point(_tileVector[m][n].x, _tileVector[m][n].y);
						_currPoint2  = new Point(_enemy2.x, _enemy2.y);
						break;
					}
				}
			}
			
			_patternCollection = new Vector.<Image>();
			_patternIndex      = new Vector.<uint>();
			_patternType 	   = new Vector.<String>();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onEnterFrame(event:Event):void
		{

			if(_state == constant.ChapterOneConstant.PLAYING_STATE)
			{
				_timer ++;
				enemyGo();
				enemyPatrol();
			}
		}
		
		/** REMOVE_FROM_STAGE **/
		private function onRemoveFromStage	(e:Event):void
		{
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
						this._testImg.x = _touch.globalX - 100;
						this._testImg.y = _touch.globalY - 80;
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
				this._testImg       = new Image(Assets.getAtlas(constant.Constant.SPRITE_ONE).getTexture(PATTERN_PREFIX + type));
			}
		}
		
		/** CREATE OBJECT BASED ON TYPE AND INDEX **/
		public function createObject(name:String, index:uint):void
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE)
			{
				this.deleteObject(index);
				
				var walkable:Boolean = false;
				try{
					
					var img:Image = new Image(Assets.getAtlas(constant.Constant.SPRITE_ONE).getTexture(PATTERN_PREFIX + name));
					
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
					//REMOVE CHARACTER 
					this.removeChild(_hero);
					
					//CHARACTER CREATED = FALSE
					_hero.heroEnable = false;
					return;
				}
				else
					return;
			}
		}
		
		/** CREATE CHARACTER **/
		public function createHero(index:Number):Boolean
		{
			if(_state == constant.ChapterOneConstant.EDITTING_STATE)
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
					_endPoint = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
					
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
	
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
		/** AI HANLDING **/		
		
		private function makeTiles():void
		{
			var x:Number = 0;
			var y:Number = 0;
			for(var i:Number=0; i<12; i++)
			{
				_tileVector[i] = new Vector.<Object>();
				y = 0;
				for(var j:Number=0; j<8;j++)
				{
					_tileVector[i][j] = new Object();
					_tileVector[i][j].x        = x;
					_tileVector[i][j].y		   = y;
					_tileVector[i][j].start1   = false;
					_tileVector[i][j].start2   = false;
					_tileVector[i][j].end      = false;
					_tileVector[i][j].walkable = true;
					_tileVector[i][j].visited  = false;
					y += 40;
				}
				x += 40;
			}
		}
		
		private function findNearestTile(enemyTarget:Enemies, heroTarget:Hero):Object
		{
			var row			: Number = 0;
			var col			: Number = 0;
			var minDistance : Number;
			var distance	: Number;
			if(enemyTarget != null)
			{
				minDistance = Math.sqrt(Math.pow((enemyTarget.enemyX - _tileVector[0][0].x),2) + Math.pow((enemyTarget.enemyY - _tileVector[0][0].y),2));
				for(var i:Number = 0; i<12; i++)
					for(var j:Number = 0; j<8; j++)
					{
						distance = Math.sqrt(Math.pow((enemyTarget.enemyX - _tileVector[i][j].x),2) + Math.pow((enemyTarget.enemyY - _tileVector[i][j].y),2));
						if(distance <= minDistance)
						{
							minDistance = distance;
							row = i;
							col = j;
						}
					}
			}
			else if(heroTarget != null)
			{
				minDistance = Math.sqrt(Math.pow((heroTarget.playerX - _tileVector[0][0].x),2) + Math.pow((heroTarget.playerY - _tileVector[0][0].y),2));
				for(var k:Number; i<12; i++)
					for(var z:Number; j<8; j++)
					{
						distance = Math.sqrt(Math.pow((heroTarget.playerX - _tileVector[i][j].x),2) + Math.pow((heroTarget.playerY - _tileVector[i][j].y),2));
						if(distance <= minDistance)
						{
							minDistance = distance;
							row = k;
							col = z;
						}
					} 
			}
			return _tileVector[row][col];
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
			if ((p.x + n1 > (11*40)) ||(p.x + n1 < 0)|| ((p.y + n2) > (7*40))|| ((p.y + n2) <0)) 
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		private function enemyGo():void
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
		
		private function enemyPatrol():void
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
	}
}