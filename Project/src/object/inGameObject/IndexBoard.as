/*****************************************************
 * ================================================= *
 *                 INDEXBOARD OBJECT                 *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	import constant.StoryConstant;
	
	import controller.ObjectController.MainController;
	
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
		private var _patternCollection  :Vector.<Image>;
		private var _patternType	    :Vector.<String>;
		private var _patternIndex       :Vector.<uint>;
		private var _maxCoin		 	:Number = 0;
		private var _screen				:String;
		private var _gameArea			:Rectangle;
		
		//HERO VARARIABLES
		private var _enemy1		   : Enemies;
		private var _enemy2		   : Enemies;
		private var _enemyList		:Vector.<Enemies>;
		private var _gotFollow		:Boolean = false;
		private var _gotPatrol		:Boolean = false;
		private var _hero	       : Player;
		private var _controller	   : MainController;
		private var _heroIndex	   : uint;
		private var _dragType      : String;
		private var _testImg       : Image;
		private var _playerPos	   : Point;
		private var _gender			: String = "Male";
		
		//AI PATH FINDING VARIABLES
		private var _tileVector : Vector.<Object>;
		private var _path	: Vector.<Point>;
		private var _startPoint1 : Point;
		private var _startPoint2 : Point;
		private var _endPoint1	: Point;
		private var _endPointPatrol1	: Vector.<Point>;
		private var _endPointPatrol2	: Vector.<Point>;
		private var _currPoint1	: Point;
		private var _currPoint2	: Point;
		private var _timer		: Number = 0;
		private var _enemyGo	: Boolean = false;
		private var _enemy1Found : Boolean = false;
		private var _currEnd1 : Number = 0;
		private var _currEnd2 : Number = 0;
		private var _distanceToEnd1 : Number;
		private var _distanceToEnd2 : Number;
		
		/** Constructor **/
		public function IndexBoard(controller:MainController)
		{
			this._controller   = controller;
			this._hero         = new Player(_controller);
	
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/** Get Set **/
		public function get enemyList():Vector.<Enemies>
		{
			return _enemyList;
		}
		
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
		
		public function get hero():Player
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
		
		public function set screen(value:String):void{
			this._screen = value;
		}

		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		/** ADDED_TO_STAGE **/
		private function onAddedToStage(e:Event):void{
			_gameArea = new Rectangle(0,0, 440, 360);

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
		
		public function stage2MonsterOn():void
		{
			var enemyIMG :Image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture('Enemy/Enemy_4'));
			var enemyPos :Point	= indexToPoint(StoryConstant.STAGE2_ENEMY_POS);
			enemyIMG.x = enemyPos.x;
			enemyIMG.y = enemyPos.y;
			this.addChild(enemyIMG);
		}
		
		/** ENTER_FRAME **/
		private function onEnterFrame(event:Event):void
		{
			if(_state == constant.ChapterOneConstant.PLAYING_STATE)
			{
				_timer ++;
				updateHeroPosition();
				if(_gotFollow)
				{
					if(_enemy1 != null &&_enemy1.type == Constant.FOLLOW_TYPE)
						enemyFollow(_enemy1);
					if(_enemy2 != null && _enemy2.type == Constant.FOLLOW_TYPE)
						enemyFollow(_enemy2);
				}
				
				if(_gotPatrol)
				{
					if(_enemy1 != null && _enemy1.type == Constant.PATROL_TYPE)
						enemyPatrol(_enemy1);
					if(_enemy2 != null && _enemy2.type == Constant.PATROL_TYPE)
						enemyPatrol(_enemy2);
				}
			}
		}
		
		public function checkPlayerOutOfArea():Array
		{
			var outOfArea	:String;
			var playerX		:uint;
			var playerY		:uint;
			var result		:Array;
			
			if(this._hero.playerX + 40 > _gameArea.right)
			{
				playerX = _gameArea.right - 40;
				playerY = this._hero.playerY;
				outOfArea = "Horizontal";
			}
			else if(this._hero.playerX < _gameArea.x)
			{
				playerX = 0;
				playerY = this._hero.playerY;
				outOfArea = "Horizontal";
			}
			else if(this._hero.playerY + 40 > _gameArea.bottom)
			{
				outOfArea = "Vertical";
				playerY = _gameArea.bottom - 40;
				playerX = this._hero.playerX;
			}
			else if(this._hero.playerY < _gameArea.y)
			{
				outOfArea = "Vertical";
				playerY = 0;
				playerX = this._hero.playerX;
			}	
			result = new Array(outOfArea, playerX, playerY);
			return result;
		}
		
		private function setupPattern():void
		{
			var collection 	:Vector.<String>;
			var imgCollection	:Vector.<Image>;
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
				case Constant.STORY_SCREEN_3:
					collection 	= StoryConstant.STAGE3_COLLECTION;
					index		= StoryConstant.STAGE3_INDEX;
					type		= StoryConstant.STAGE3_TYPE;
					pos			= StoryConstant.STAGE3_PLAYER_POS;
					patternToStage(collection,index,type,pos);
					setupStage3Enemies();
					break;
				case Constant.STORY_SCREEN_4:
					collection 	= StoryConstant.STAGE4_COLLECTION;
					index		= StoryConstant.STAGE4_INDEX;
					type		= StoryConstant.STAGE4_TYPE;
					pos			= StoryConstant.STAGE4_PLAYER_POS;
					patternToStage(collection,index,type,pos);
					setupStage4Enemies();
					break;
				case Constant.STORY_SCREEN_5:
					collection 	= StoryConstant.STAGE5_COLLECTION;
					index		= StoryConstant.STAGE5_INDEX;
					type		= StoryConstant.STAGE5_TYPE;
					pos			= StoryConstant.STAGE5_PLAYER_POS;
					patternToStage(collection,index,type,pos);
					break;
				case Constant.PLAY_SCREEN:
					imgCollection 	= PreviewGameInfo._obsCollection;
					index 			= PreviewGameInfo._obsIndex;
					type 			= PreviewGameInfo._obsType;
					pos 			= PreviewGameInfo._playerPos;
					this._gender	= PreviewGameInfo._playerGender;
					previewPatternToStage(imgCollection,index,type,pos);
					previewEnemyToStage();
					break;
					
			}
		}
		
		private function previewPatternToStage(collection:Vector.<Image>, index:Vector.<uint>,type:Vector.<String>,pos:uint):void{
			var walkable	:Boolean = false;
			for(var i:uint=0; i<collection.length; i++)
				_patternCollection.push(collection[i]);
			
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
		
		private function previewEnemyToStage():void
		{
			this._enemyList = new Vector.<Enemies>;
			var speed	:Number;
			var img		:Number;
			var pos		:Array; 
			
			if(PreviewGameInfo._enemyType[0] != "None")
			{
				pos = new Array(indexToPoint(PreviewGameInfo._enemyPos[0]).x, indexToPoint(PreviewGameInfo._enemyPos[0]).y)
				speed = PreviewGameInfo._enemySpd[0];
				img = PreviewGameInfo._enemyImg[0];
				this._enemy1 = new Enemies(this._controller, pos[0], pos[1], PreviewGameInfo._enemyType[0], speed, img, 1);
				
				this._enemy1.x = pos[0];
				this._enemy1.y = pos[1];
				
				if(PreviewGameInfo._enemyType[0] == "Patrol Enemy")
				{
					this._enemy1.setEndPoints(indexToPoint(PreviewGameInfo._enemyPos[0]));
					for(var i:uint=0; i<PreviewGameInfo._enemy1EndPts.length ;i++)
					{
						this._enemy1.setEndPoints(indexToPoint(PreviewGameInfo._enemy1EndPts[i]));
					}
					this._gotPatrol = true;
				}
				else if(PreviewGameInfo._enemyType[0] == "Follow Enemy")
				{
					_controller.updateUnits(_enemy1, null, null);
					
					for(var k:Number=0; k<11; k++)
					{
						for(var j:Number=0; j<9; j++)
						{
							if((_tileVector[k][j].x == _enemy1.x) && (_tileVector[k][j].y == _enemy1.y))
							{
								_tileVector[k][j].start1  = true;
								_tileVector[k][j].visited1 = true;
								_startPoint1 = new Point(_tileVector[k][j].x, _tileVector[k][j].y);
								_path        = new Vector.<Point>();
								_currPoint1  = new Point(_startPoint1.x, _startPoint1.y);
								break;
							}
						}
					}
					this._gotFollow = true;
				}

				
				this._enemyList.push(_enemy1);
				this.addChild(_enemy1);
			}
			
			if(PreviewGameInfo._enemyType[1] != "None")
			{
				pos = new Array(indexToPoint(PreviewGameInfo._enemyPos[1]).x, indexToPoint(PreviewGameInfo._enemyPos[1]).y)
				speed = PreviewGameInfo._enemySpd[1];
				img	= PreviewGameInfo._enemyImg[1];
				if(PreviewGameInfo._enemyType[1] == "Patrol Enemy")
				{
					this._enemy2 = new Enemies(this._controller, pos[0], pos[1], PreviewGameInfo._enemyType[1], speed, img, 2);
					this._gotPatrol = true;
				}
				else if(PreviewGameInfo._enemyType[1] == "Follow Enemy")
					this._gotFollow = true;
				
				this._enemy2.x = pos[0];
				this._enemy2.y = pos[1];
				this._enemyList.push(_enemy2);
				this.addChild(_enemy2);
			}
		}
		
		
		private function setupStage3Enemies():void
		{
			var enemy1_pos 	:Array  = new Array(indexToPoint(StoryConstant.STAGE3_ENEMY1_POS).x, indexToPoint(StoryConstant.STAGE3_ENEMY1_POS).y)
			var enemy2_pos	:Array  = new Array(indexToPoint(StoryConstant.STAGE3_ENEMY2_POS).x, indexToPoint(StoryConstant.STAGE3_ENEMY2_POS).y)
			var type		:String = StoryConstant.STAGE3_ENEMY_TYPE;
			var speed		:Number = StoryConstant.STAGE3_ENEMY_SPD;
			var img			:Number = StoryConstant.STAGE3_ENEMY_IMG;
			this._enemy1 = new Enemies(this._controller, enemy1_pos[0], enemy1_pos[1], type, speed, img, 1);
			this._enemy2 = new Enemies(this._controller, enemy2_pos[0], enemy2_pos[1], type, speed, img, 2);
			
			this._enemy1.setEndPoints(indexToPoint(StoryConstant.STAGE3_ENEMY1_POS));
			this._enemy2.setEndPoints(indexToPoint(StoryConstant.STAGE3_ENEMY2_POS));
			this._enemy1.setEndPoints(indexToPoint(StoryConstant.STAGE3_ENEMY1_END));
			this._enemy2.setEndPoints(indexToPoint(StoryConstant.STAGE3_ENEMY2_END));
			
			this._enemyList = new Vector.<Enemies>;
			this._enemy1.x = enemy1_pos[0];
			this._enemy1.y = enemy1_pos[1];
			this._enemy2.x = enemy2_pos[0];
			this._enemy2.y = enemy2_pos[1];
			this._gotPatrol = true;
			this._enemyList.push(_enemy1);
			this._enemyList.push(_enemy2);
			this.addChild(_enemy1);
			this.addChild(_enemy2);
		}
		
		private function setupStage4Enemies():void
		{
			var pos			:Array 	= new Array(indexToPoint(StoryConstant.STAGE4_ENEMY_POS).x,indexToPoint(StoryConstant.STAGE4_ENEMY_POS).y);
			var type		:String = StoryConstant.STAGE4_ENEMY_TYPE;
			var speed		:Number = StoryConstant.STAGE4_ENEMY_SPD;
			var img			:Number = StoryConstant.STAGE4_ENEMY_IMG;
			
			this._enemyList = new Vector.<Enemies>;
			this._enemy1 = new Enemies(this._controller, pos[0], pos[1], type, speed, img, 1);
			this._enemy1.x = pos[0];
			this._enemy1.y = pos[1];
			
			this._enemy1.setEndPoints(indexToPoint(StoryConstant.STAGE4_ENEMY_POS));
			for(var i:uint=0; i<StoryConstant.STAGE4_ENEMY_PATH.length ;i++)
			{
				this._enemy1.setEndPoints(indexToPoint(StoryConstant.STAGE4_ENEMY_PATH[i]));
			}
			this._gotPatrol = true;
			this._enemyList.push(_enemy1);
			this.addChild(_enemy1);
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
			_enemy1Found = false;
			_endPoint1.x = int(_hero.playerX / 40) * 40;
			_endPoint1.y = int(_hero.playerY / 40) * 40;
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
			this.dispose();
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
					_hero.gender = this._gender;
					this.addChild(_hero);
					_controller.updateUnits(null,null,_hero);
					
					_tileVector[columnIndex][rowIndex].end = true;
					_endPoint1  = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
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
					_tileVector[i][j] 	= new Object();
					_tileVector[i][j].x = x;
					_tileVector[i][j].y	= y;
					_tileVector[i][j].start1 	= false;
					_tileVector[i][j].start2 	= false;
					_tileVector[i][j].end 		= false;
					_tileVector[i][j].walkable 	= true;
					_tileVector[i][j].visited 	= false;
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
			return (Math.abs(p.x - _endPoint1.x) + Math.abs(p.y - _endPoint1.y));
		}
		
		private function insideField(p:Point,n1:Number,n2:Number):Boolean 
		{
			if ((p.x + n1 > (10*40)) ||(p.x + n1 < 0)|| ((p.y + n2) > (8*40))|| ((p.y + n2) <0)) 
				return false;
			else
				return true;
		}
		
		private function enemyFollow(enemy:Enemies):void
		{
			if(!_enemy1Found)
			{
				if(_timer == 30)
				{
					if(_enemy1.isReachedTarget)
					{
						_enemy1.isReachedTarget = false;
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
							if((savedPoint.x != _endPoint1.x) || (savedPoint.y != _endPoint1.y))
							{
								_enemy1.targetPt = savedPoint;
//								_enemy1.x = savedPoint.x;
//								_enemy1.y = savedPoint.y;
								var m:Number = savedPoint.x / 40;
								var n:Number = savedPoint.y / 40;
								_tileVector[m][n].visited = true;	
							}
							_currPoint1 = savedPoint;
							_path.push(_currPoint1);
							
							if((savedPoint.x == _endPoint1.x) && (savedPoint.y == _endPoint1.y))
							{
								_enemy1Found = true;
							}
						}
						else
						{
							if(_path.length > 1)
							{
								_currPoint1 = _path[_path.length - 2];
								_enemy1.targetPt = _currPoint1;
//								_enemy1.x = _currPoint1.x;
//								_enemy1.y = _currPoint1.y;
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
		}
		
		private function enemyPatrol(enemy:Enemies):void
		{
			var moveX:Number;
			var moveY:Number;
			var distance:Number;
			if(enemy.enemyX == enemy.endPoints[enemy.currEndPt].x && enemy.enemyY == enemy.endPoints[enemy.currEndPt].y)
			{
				enemy.moveX = 0;
				enemy.moveY = 0;
				enemy.setNextEnd();
				return;
			}
			
			if(enemy.enemyX == enemy.endPoints[enemy.currEndPt].x && enemy.enemyY != enemy.endPoints[enemy.currEndPt].y)
			{
				distance = enemy.endPoints[enemy.currEndPt].y - enemy.endPoints[enemy.currStartPt].y;
				moveX = 0;
				if(distance > 0)
				{
					if(enemy.enemyY > enemy.endPoints[enemy.currEndPt].y)
						moveY = -(enemy.enemyY - enemy.endPoints[enemy.currEndPt].y);
					else
						moveY = distance * enemy.speed;						
				}
				else if (distance < 0)
				{
					if(enemy.enemyY < enemy.endPoints[enemy.currEndPt].y)
						moveY = -(enemy.enemyY - enemy.endPoints[enemy.currEndPt].y);
					else
						moveY = distance * enemy.speed;	
				}
				enemy.moveX = moveX;
				enemy.moveY = moveY;
				return;
			}
			
			if(enemy.enemyX != enemy.endPoints[enemy.currEndPt].x && enemy.enemyY == enemy.endPoints[enemy.currEndPt].y)
			{
				distance = enemy.endPoints[enemy.currEndPt].x - enemy.endPoints[enemy.currStartPt].x;
				moveY = 0;
				if(distance > 0)
				{
					if(enemy.enemyX > enemy.endPoints[enemy.currEndPt].x)
						moveX = -(enemy.enemyX - enemy.endPoints[enemy.currEndPt].x);
					else
						moveX = distance * enemy.speed;						
				}
				else if (distance < 0)
				{
					if(enemy.enemyX < enemy.endPoints[enemy.currEndPt].x)
						moveX = -(enemy.enemyX - enemy.endPoints[enemy.currEndPt].x);
					else
						moveX = distance * enemy.speed;	
				}
				enemy.moveX = moveX;
				enemy.moveY = moveY;
				return;
			}
		}
		
		public function displayQuestion():void
		{
			var qns: Question = new Question(this._controller, Constant.SHORT_QUESTION);
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
					_endPoint1 = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
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
							_endPointPatrol2 = new Vector.<Point>();
							var endPoint : Point;
							endPoint = new Point (_enemy2.x, _enemy2.y - 80);
							_endPointPatrol2.push(endPoint);
							endPoint = new Point (_enemy2.x + 80, _enemy2.y - 80);
							_endPointPatrol2.push(endPoint);
							endPoint = new Point (_enemy2.x + 80, _enemy2.y);
							_endPointPatrol2.push(endPoint);
							endPoint = new Point (_enemy2.x, _enemy2.y);
							_endPointPatrol2.push(endPoint);
							
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