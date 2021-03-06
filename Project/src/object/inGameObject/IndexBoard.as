/*****************************************************
 * ================================================= *
 *                 INDEXBOARD OBJECT                 *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
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
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class IndexBoard extends Sprite
	{
		//STATES VARIABLE
		private var _state 	:String = Constant.INSTRUCTING_STATE;
		
		/*----------------------------
		|	      Hero constant      |
		-----------------------------*/
		private static const PLAYER_SPEED_FORWARD	:int 	= 3;
		private static const PLAYER_SPEED_BACKWARD	:int 	= -3;
		//CONSTANT
		private static const PATTERN_PREFIX:String	 = 'pattern_';
		private static const MAXIMUM_COLUMN:uint 	 = 11;
		private static const MAXIMUM_ROW:uint        = 9;
		private static const PIXEL_MOVE:int 	     = 40;
		private static const COIN_TYPE:String		 = "03";
		//INDEX BOARD CONSTANT
		private static const LIST_COMMAND			:Array 	= [0,1];
		private static const MAXIMUM_PATTERN		:uint   = 1;
		private static const FALSE_LENGTH_ARRAY 	:uint   = 1;
		private static const DELETE_LENGTH_ARRAY 	:uint   = 2;
		private static const CREATE_LENGTH_ARRAY	:uint   = 3;
		private static const HERO_TYPE				:String = "04";
		
		
		//INDEXBOARD VARIABLES
		private var _patternCollection  :Vector.<Image>;
		private var _patternType	    :Vector.<String>;
		private var _patternIndex       :Vector.<uint>;
		private var _obsList			:Vector.<Obstacles>;
		private var _obsPara			:Vector.<Number>;
		private var _maxCoin		 	:Number = 0;
		private var _screen				:String;
		private var _gameArea			:Rectangle;
		
		//HERO VARARIABLES
		private var _enemy1		   	: Enemies;
		private var _enemy2		   	: Enemies;
		private var _enemyList		: Vector.<Enemies>;
		private var _gotFollow		: Boolean = false;
		private var _gotPatrol		: Boolean = false;
		private var _player	       	: Player;
		private var _controller	   	: MainController;
		private var _heroIndex	   	: uint;
		private var _dragType      	: String;
		private var _testImg       	: Image;
		private var _playerPos	   	: Point;
		private var _gender			: String = "Male";
		
		private var _isDisplayedQuiz: Boolean = false;
		private var _isHit			: Boolean;
		private var _hitCounter		: Number = 0;
		private var _currLife		: Number;
		private var _maxLife		: Number;
		private var _currCollectObs	: Number = 0;
		private var _maxCollectObs	: Number = 0;

		//AI PATH FINDING VARIABLES
		private var _tileVector : Vector.<Object>;
		private var _endPoint	: Point;
		
		/** Constructor **/
		public function IndexBoard(controller:MainController)
		{
			this._controller   = controller;
			this._player         = new Player(_controller);
	
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/**====================================================================
		 * |	                     GET-SET FUNCTIONS		                  | *
		 * ====================================================================**/
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
			return _player;
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
		
		public function get obsList():Vector.<Obstacles>{
			return this._obsList;
		}
		
		public function set state(value:String):void{
			this._state = value;
		}
		
		public function set isDisplayedQuiz(value:Boolean):void{
			this._isDisplayedQuiz = value;
		}

		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		/*-----------------------------------------------------------------------
		| @Added to stage										                 |		
		-------------------------------------------------------------------------*/
		private function onAddedToStage(e:Event):void{
			_gameArea = new Rectangle(0,0, 440, 360);
			
			_patternCollection = new Vector.<Image>();
			_patternIndex      = new Vector.<uint>();
			_patternType 	   = new Vector.<String>();
			
			this._tileVector = new Vector.<Object>();
			makeTiles();
			
			_screen = _controller.screen;
			setupPattern();
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.addEventListener('doingQuiz', onDoingQuiz);
			this.addEventListener('doneQuiz', onFinishQuiz);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onDoingQuiz(event:Event):void{
			this._controller.changeState(Constant.PAUSE_STATE);
		}
		
		private function onFinishQuiz(event:Event):void{
			this._controller.changeState(Constant.PAUSE_STATE);
		}
		
		/*-----------------------------------------------------------------------
		| @Key pressed event for player's movement			                     |		
		-------------------------------------------------------------------------*/
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(_state == Constant.PLAYING_STATE)
			{
				if(e.keyCode == Keyboard.LEFT){			
					movePlayer(Constant.KEY_LEFT);
				}
				else if(e.keyCode == Keyboard.RIGHT){
					movePlayer(Constant.KEY_RIGHT);
				}
				else if(e.keyCode == Keyboard.UP){
					movePlayer(Constant.KEY_UP);
				}
				else if(e.keyCode == Keyboard.DOWN){
					movePlayer(Constant.KEY_DOWN);
				}
			}
		}
		
		/*-----------------------------------------------------------------------
		| @Key pressed event for stopping player			                     |		
		-------------------------------------------------------------------------*/
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(_state == Constant.PLAYING_STATE)
			{
				this._player.moveX = 0;
				this._player.moveY = 0;
				stopPlayer();
			}
		}
		
		/*-----------------------------------------------------------------------
		| @Actions perform each frame						                     |		
		-------------------------------------------------------------------------*/
		private function onEnterFrame(event:Event):void
		{
			if(_state == Constant.PLAYING_STATE)
			{
				this._hitCounter ++;
				if(_gotFollow)
					updateHeroPosition();
				
				/* Move player */ 
				this._player.x += this._player.moveX;
				this._player.y += this._player.moveY;
				
				/* Player's checking functions */
				if(_hitCounter >= 30)
				{
					if(this._isHit)
					{
						this._isHit = false;
						if(this._enemy1 != null && this._enemy1.type == Constant.FOLLOW_TYPE && this._enemy1.playerFound)
						{
							this._enemy1.playerFound = false;
							this._enemy1.counter = 30;
						}
						if(this._enemy2 != null && this._enemy2.type == Constant.FOLLOW_TYPE && this._enemy2.playerFound)
						{
							this._enemy2.playerFound = false;
							this._enemy2.counter = 30;
						}
					}
				}
				checkCollisionWithObstacles();
				checkCollisionWithEnemy();
				checkPlayerOutOfArea();
				
				/* Enemies' moving functions */
				if(_gotFollow)
				{
					if(_enemy1 != null &&_enemy1.type == Constant.FOLLOW_TYPE)
					{
						_enemy1.increaseCounter();
						enemyFollow(_enemy1);
					}
					if(_enemy2 != null && _enemy2.type == Constant.FOLLOW_TYPE)
					{
						_enemy2.increaseCounter();
						enemyFollow(_enemy2);
					}
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
		
		/*-----------------------------------------------------------------------
		| @Remove from stage								                     |		
		-------------------------------------------------------------------------*/
		private function onRemoveFromStage(e:Event):void
		{
			this.dispose();
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		/**====================================================================
		 * |	               SETTING UP OBJECT ON BOARD		              | *
		 * ====================================================================**/
		
		public function stage2MonsterOn():void
		{
			var enemyIMG :Image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture('Enemy/Enemy_4'));
			var enemyPos :Point	= indexToPoint(StoryConstant.STAGE2_ENEMY_POS);
			enemyIMG.x = enemyPos.x;
			enemyIMG.y = enemyPos.y;
			this.addChild(enemyIMG);
		}
		
		public function removeLockOnCorrect(index:Number):void{
			for(var i:uint = 0; i<this._obsList.length; i++)
			{
				if(this._obsList[i].pos.equals(indexToPoint(index)))
				{
					this.removeChild(this._obsList[i])
					this._obsList.splice(i, 1);
				}
			}
		}
		
		private function setupPattern():void
		{
			var collection 		:Vector.<String>;
			var imgCollection	:Vector.<Image> = new Vector.<Image>();
			var index			:Vector.<uint>;
			var type			:Vector.<String>;
			var pos				:uint;
			var i:uint;
			switch(_screen){
				case Constant.STORY_SCREEN_1:
					collection 	= StoryConstant.STAGE1_COLLECTION;
					for(i=0; i< collection.length; i++)
						imgCollection.push(new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(collection[i])));
					index		= StoryConstant.STAGE1_INDEX;
					type		= StoryConstant.STAGE1_TYPE;
					pos			= StoryConstant.STAGE1_PLAYER_POS;
					addObstaclesToBoard(imgCollection, index, type, null);
					createHero(pos);
					break;
				case Constant.STORY_SCREEN_2:
					collection 	= StoryConstant.STAGE2_COLLECTION;
					for(i=0; i< collection.length; i++)
						imgCollection.push(new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(collection[i])));
					index		= StoryConstant.STAGE2_INDEX;
					type		= StoryConstant.STAGE2_TYPE;
					pos			= StoryConstant.STAGE2_PLAYER_POS;
					addObstaclesToBoard(imgCollection, index, type, null);
					createHero(pos);
					break;
				case Constant.STORY_SCREEN_3:
					collection 	= StoryConstant.STAGE3_COLLECTION;
					for(i=0; i< collection.length; i++)
						imgCollection.push(new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(collection[i])));
					index		= StoryConstant.STAGE3_INDEX;
					type		= StoryConstant.STAGE3_TYPE;
					pos			= StoryConstant.STAGE3_PLAYER_POS;
					addObstaclesToBoard(imgCollection, index, type, null);
					createHero(pos);
					setupStage3Enemies();
					break;
				case Constant.STORY_SCREEN_4:
					collection 	= StoryConstant.STAGE4_COLLECTION;
					for(i=0; i< collection.length; i++)
						imgCollection.push(new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(collection[i])));
					index		= StoryConstant.STAGE4_INDEX;
					type		= StoryConstant.STAGE4_TYPE;
					pos			= StoryConstant.STAGE4_PLAYER_POS;
					addObstaclesToBoard(imgCollection, index, type, null);
					createHero(pos);
					setupStage4Enemies();
					break;
				case Constant.STORY_SCREEN_5:
					collection 	= StoryConstant.STAGE5_COLLECTION;
					for(i=0; i< collection.length; i++)
						imgCollection.push(new Image(Assets.getAtlas(Constant.OBSTACLES_SPRITE).getTexture(collection[i])));
					index		= StoryConstant.STAGE5_INDEX;
					type		= StoryConstant.STAGE5_TYPE;
					pos			= StoryConstant.STAGE5_PLAYER_POS;
					addObstaclesToBoard(imgCollection, index, type, StoryConstant.STAGE5_QNS);
					createHero(pos);
					break;
				case Constant.PLAY_SCREEN:
					imgCollection 	= PreviewGameInfo._obsCollection;
					index 			= PreviewGameInfo._obsIndex;
					type 			= PreviewGameInfo._obsType;
					pos 			= PreviewGameInfo._playerPos;
					this._gender	= PreviewGameInfo._playerGender;
					addObstaclesToBoard(imgCollection, index, type, PreviewGameInfo._obsQns);
					createHero(pos);
					previewEnemyToStage();
					break;
					
			}
		}
		
		private function addObstaclesToBoard(collection:Vector.<Image>, index:Vector.<uint>, type:Vector.<String>, qns:Vector.<Object>):void{
			var pos		:Point;
			var obstacles	:Obstacles;
			this._obsList = new Vector.<Obstacles>();
			this._obsPara = new Vector.<Number>();
			for(var i:uint=0; i<collection.length; i++)
			{
				pos = indexToPoint(index[i]);
				//Create a new obstacle
				if(qns != null)
					obstacles	= new Obstacles(type[i], pos, collection[i], qns[i].gotQns, qns[i].qnsIndex);
				else 
					obstacles	= new Obstacles(type[i], pos, collection[i]);
				
				//Position it on screen
				obstacles.x = pos.x;
				obstacles.y = pos.y;
				
				//Count collectible obstacles
				//Update to Main Controller => ScoreBoard
				if(type[i] == Constant.COLLECT_OBS)
					this._maxCollectObs ++;
				else
					this._tileVector[pos.x/40][pos.y/40].walkable = false;
				
				this._obsList.push(obstacles);
				if(this._screen == Constant.PLAY_SCREEN)
					this._obsPara.push(PreviewGameInfo._obsPara[i]);
				this.addChild(obstacles);
			}
			this._controller.getGameStat("max coin", _maxCollectObs);
		}
		
		private function createEnemy():void
		{
			
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
								_tileVector[k][j].visited1 = true;
								_enemy1.currPoint = new Point(_tileVector[k][j].x, _tileVector[k][j].y);
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
				img = PreviewGameInfo._enemyImg[1];
				this._enemy2 = new Enemies(this._controller, pos[0], pos[1], PreviewGameInfo._enemyType[1], speed, img, 1);
				
				this._enemy2.x = pos[0];
				this._enemy2.y = pos[1];
				
				if(PreviewGameInfo._enemyType[1] == "Patrol Enemy")
				{
					this._enemy2.setEndPoints(indexToPoint(PreviewGameInfo._enemyPos[1]));
					for(var m:uint=0; m<PreviewGameInfo._enemy2EndPts.length ;m++)
					{
						this._enemy2.setEndPoints(indexToPoint(PreviewGameInfo._enemy2EndPts[m]));
					}
					this._gotPatrol = true;
				}
				else if(PreviewGameInfo._enemyType[1] == "Follow Enemy")
				{
					_controller.updateUnits(null, _enemy2, null);
					
					for(var n:Number=0; n<11; n++)
					{
						for(var l:Number=0; l<9; l++)
						{
							if((_tileVector[n][l].x == _enemy2.x) && (_tileVector[n][l].y == _enemy2.y))
							{
								_tileVector[n][l].visited2 = true;
								_enemy2.currPoint = new Point(_tileVector[n][l].x, _tileVector[n][l].y);
								break;
							}
						}
					}
					this._gotFollow = true;
				}
				
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
			this._enemy1.setEndPoints(indexToPoint(StoryConstant.STAGE3_ENEMY1_POS));
			this._enemy2.setEndPoints(indexToPoint(StoryConstant.STAGE3_ENEMY2_POS));
			
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
			this._enemy1.setEndPoints(indexToPoint(StoryConstant.STAGE4_ENEMY_POS));

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
				
		
		
		/**====================================================================
		 * |	                 OBJECT CREATION   			                  | *
		 * ====================================================================**/
		public function analyzeArrayInput(arr:Array):void
		{			
			//NO COMMAND             => DO NOTHING
			if(arr.length == FALSE_LENGTH_ARRAY)
				return;
				
				//DELETE COMMAND          => DELETE
			else if(arr.length == DELETE_LENGTH_ARRAY){				
				if(arr[0] == LIST_COMMAND[0]){
					var index:uint = arr[1];
					deleteObject(index);
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
					this._maxCollectObs ++;
					if(name != HERO_TYPE)
					{
						createObject(name, index);
						return;
					}
					else if(createHero(index))
						return;
					else
						trace("More than one hero");	
				}
			}
			return;
		}		
		
		/** CREATE OBJECT BASED ON TYPE AND INDEX **/
		public function createObject(name:String, index:uint):void
		{
			if((_state == Constant.EDITTING_STATE && _screen == Constant.CREATE_GAME_SCREEN) || (_screen != Constant.CREATE_GAME_SCREEN))
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
			if(_state == Constant.EDITTING_STATE || _screen != Constant.CREATE_GAME_SCREEN)
			{
				var modular      : int  = index % MAXIMUM_COLUMN;
				var rowIndex 	 : uint = 0;
				var columnIndex  : uint = 0;
				
				_heroIndex = index;
				
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
					
				_player.x = columnIndex * PIXEL_MOVE;
				_player.y = rowIndex * PIXEL_MOVE;
				
				_player.gender = this._gender;
					
				this.addChild(_player);
				this._isHit = false;
				_controller.updateUnits(null,null,_player);
					
				_tileVector[columnIndex][rowIndex].end = true;
				_endPoint  = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
				_playerPos = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
				
				return true;
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
			if(_state == Constant.EDITTING_STATE || _state == Constant.PLAYING_STATE)
			{
				//IF INDEX GIVEN IS CHARACTER'S INDEX + CHARACTER CREATED 
				//=> DELETE CHARACTER
				if(index == _heroIndex)
				{
					this.deletePlayer();						
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
		public function deletePlayer():void
		{
			if(_state == Constant.EDITTING_STATE)
			{
				this.removeChild(_player);
				return;
			}
		}
		
		public function createPlayer(pos:Number, gender:String):void
		{
			if(_state == Constant.EDITTING_STATE)
			{
				var modular      : int  = pos % MAXIMUM_COLUMN;
				var rowIndex 	 : uint = 0;
				var columnIndex  : uint = 0;
				
				_heroIndex = pos;
				
				//IF NO CHARACTER CREATED => CREATED
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
				
				_player.x = columnIndex * PIXEL_MOVE;
				_player.y = rowIndex	* PIXEL_MOVE;
				
				this.addChild(_player);
				_controller.updateUnits(null,null,_player);
				
				_tileVector[columnIndex][rowIndex].end = true;					
				_endPoint = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
				_playerPos = new Point(_tileVector[columnIndex][rowIndex].x, _tileVector[columnIndex][rowIndex].y);
				
				return;
			}
		}
		
		/**====================================================================
		 * |	                     AI HANDLERS			                  | *
		 * ====================================================================**/
		public function stopCharacters():void
		{
			if(this._enemy1 != null)
			{
				this._enemy1.moveX = 0;
				this._enemy1.moveY = 0;
			}
			
			if(this._enemy2 != null)
			{
				this._enemy2.moveX = 0;
				this._enemy2.moveY = 0;
			}
			
			this._player.moveX = 0;
			this._player.moveY = 0;
		}
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
					_tileVector[i][j].walkable 	= true;
					_tileVector[i][j].visited1 	= false;
					_tileVector[i][j].visited2 	= false;
					y += 40;
				}
				x += 40;
			}
		}
		
		private function updateHeroPosition():void
		{
			clearVisitedTiles();
			if(_enemy1 != null)
				_enemy1.playerFound = false;
			if(_enemy2 != null)
				_enemy2.playerFound = false;
			_endPoint.x = int(this._player.x / 40) * 40;
			_endPoint.y = int(this._player.y / 40) * 40;
		}
		
		private function clearVisitedTiles():void
		{
			var x :Number = int(this._player.x / 40);
			var y :Number = int(this._player.y / 40);
			for(var j:Number=0; j<9 ; j++)
			{
				_tileVector[x][j].visited1 = false;
				_tileVector[x][j].visited2 = false;
			}
			
			for(var i:Number=0; i<11 ; i++)
			{
				_tileVector[i][y].visited1 = false;
				_tileVector[i][y].visited2 = false;
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
				return false;
			else
				return true;
		}
		
		/*-----------------------------------------------------------------------
		| @Enemy follows player													|
		-------------------------------------------------------------------------*/
		private function enemyFollow(enemy:Enemies):void
		{
			if(!enemy.playerFound)
			{
				if(enemy.counter >= 30)
				{
					if(enemy.isReachedTarget)
					{
						enemy.isReachedTarget = false;
						var savedPoint: Point;
						var minF:Number = 10000;
						
						for (var i:Number=-40; i<=40; i+=40) {
							for (var j:Number=-40; j<=40; j+=40) {
								if ((i!=0 && j==0)||(i==0 && j!=0)) {
									if(insideField(enemy.currPoint, i, j))
									{
										var o:Number = (enemy.currPoint.x + i) / 40;
										var u:Number = (enemy.currPoint.y + j) / 40;
										
										if(_tileVector[o][u].walkable)
										{
											if((_tileVector[o][u].visited1 == false && enemy.id == 1) || (_tileVector[o][u].visited2 == false && enemy.id == 2))
											{
												var g:Number = getG(i,j);
												var h:Number = manhattan(new Point((enemy.currPoint.x) + i,(enemy.currPoint.y) + j));
												var f:Number = g + h;
												if(f < minF)
												{
													minF = f;
													savedPoint = new Point((enemy.currPoint.x) + i,(enemy.currPoint.y) + j);
												}
											}
										}
									}
								}
							}
						}	
						
						if(savedPoint)
						{
							var m:Number;
							var n:Number;
							if((savedPoint.x != _endPoint.x) || (savedPoint.y != _endPoint.y))
							{
								enemy.targetPt = savedPoint;
								m = savedPoint.x / 40;
								n = savedPoint.y / 40;
								if(enemy.id == 1)
									_tileVector[m][n].visited1 = true;
								else if(enemy.id == 2)
									_tileVector[m][n].visited2 = true;
							}
							enemy.currPoint = savedPoint;
							enemy.path.push(enemy.currPoint);
							
							if((savedPoint.x == _endPoint.x) && (savedPoint.y == _endPoint.y))
							{
								enemy.playerFound = true;
								enemy.targetPt = savedPoint;
								m = savedPoint.x / 40;
								n = savedPoint.y / 40;
								if(enemy.id == 1)
									_tileVector[m][n].visited1 = true;
								else if(enemy.id == 2)
									_tileVector[m][n].visited2 = true;
							}
						}
						else
						{
							if(enemy.path.length > 1)
							{
								enemy.currPoint = enemy.path[enemy.path.length - 2];
								enemy.targetPt = enemy.currPoint;
								enemy.path.pop();
							}
							else
							{
								trace("Can't be solved");
							}
						}
					}	
					enemy.counter = 0;
				}
			}
		}
		
		/*-----------------------------------------------------------------------
		| @Enemy go patrol														|
		-------------------------------------------------------------------------*/
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
						moveY = distance * (enemy.speed/100);						
				}
				else if (distance < 0)
				{
					if(enemy.enemyY < enemy.endPoints[enemy.currEndPt].y)
						moveY = -(enemy.enemyY - enemy.endPoints[enemy.currEndPt].y);
					else
						moveY = distance * (enemy.speed/100);	
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
						moveX = distance * (enemy.speed/100);						
				}
				else if (distance < 0)
				{
					if(enemy.enemyX < enemy.endPoints[enemy.currEndPt].x)
						moveX = -(enemy.enemyX - enemy.endPoints[enemy.currEndPt].x);
					else
						moveX = distance * (enemy.speed/100);	
				}
				enemy.moveX = moveX;
				enemy.moveY = moveY;
				return;
			}
		}
		
		/**====================================================================
		 * |                    	STATS CONTROL FUNCTION                    | *
		 * ====================================================================**/
		public function updateMaxLife(life:Number):void{
			this._maxLife 	= life;
			this._currLife  = life;
		}
		
		public function updateCloseQuiz():void{
			this._isDisplayedQuiz = false;
		}
		
		/**====================================================================
		 * |                    CHARACTER CONTROL FUNCTION                    | *
		 * ====================================================================**/
		
		/**************************** MAIN FUNCTIONS ****************************/
		/*-----------------------------------------------------------------------
		| @Move and Stop Player upon key pressed			                     |		
		-------------------------------------------------------------------------*/
		private function movePlayer(key:String):void
		{
			switch(key){
				case Constant.KEY_LEFT:
					this._player.moveX 	 		= PLAYER_SPEED_BACKWARD;
					this._player.moveY 	 		= 0;
					this._player.playerStatus   = Constant.HERO_STATUS_LEFT;
					this._player.showHero(2, 1);
					break;
				
				case Constant.KEY_RIGHT:
					this._player.moveX 	 		= PLAYER_SPEED_FORWARD;
					this._player.moveY 	 		= 0;
					this._player.playerStatus   = Constant.HERO_STATUS_RIGHT;
					this._player.showHero(3, 1);
					break;
				
				case Constant.KEY_DOWN:
					this._player.moveX 	 		= 0;
					this._player.moveY 	 		= PLAYER_SPEED_FORWARD;
					this._player.playerStatus   = Constant.HERO_STATUS_DOWN;
					this._player.showHero(1, 1);
					break;
				
				case Constant.KEY_UP:
					this._player.moveX  	 	= 0;
					this._player.moveY  	 	= PLAYER_SPEED_BACKWARD;
					this._player.playerStatus   = Constant.HERO_STATUS_UP;
					this._player.showHero(0, 1);
					break;
				
				default:
					break;
			}
		}

		private function stopPlayer():void
		{
			this._player.moveX = 0;
			this._player.moveY = 0;
			
			switch(this._player.playerStatus)
			{		
				case Constant.HERO_STATUS_UP:
					this._player.showHero(0,0);
					break;
				case Constant.HERO_STATUS_DOWN:
					this._player.showHero(1,0);
					break;
				case Constant.HERO_STATUS_LEFT:
					this._player.showHero(2,0);
					break;
				case Constant.HERO_STATUS_RIGHT:
					this._player.showHero(3,0);
					break;
			}
		}
		
		/*-----------------------------------------------------------------------
		| @Prevent player from going out of game area		                     |		
		-------------------------------------------------------------------------*/
		private function checkPlayerOutOfArea():void
		{
			if(this._player.x + 40 > _gameArea.right)
				this._player.x = _gameArea.right - 40;
			else if(this._player.x < _gameArea.x)
				this._player.x = 0;
			else if(this._player.y + 40 > _gameArea.bottom)
				this._player.y = _gameArea.bottom - 40;
			else if(this._player.y < _gameArea.y)
				this._player.y = 0;
		}
		
		/*-----------------------------------------------------------------------
		| @Check collision with obstacles										|
		| @Perform corresponding actions with obstacles' type					|
		-------------------------------------------------------------------------*/
		private function checkCollisionWithObstacles():void
		{
			var obsList	:Vector.<Obstacles> = this._obsList;
			var player	:Player = this._player;
			
			if(obsList.length == 0)
				return;
			else
			{
				var vx	:Number;
				var vy	:Number;
				var playerX	:Number;
				var playerY :Number;
				
				for(var i:uint=0; i<obsList.length; i++)
				{
					vx = (this._player.x + this._player.width/2) - (obsList[i].pos.x + obsList[i].width/2);
					vy = (this._player.y + this._player.height/2) - (obsList[i].pos.y + obsList[i].height/2);
					
					if(Math.abs(vx) < this._player.width/2 + obsList[i].width/2)
					{
						if(Math.abs(vy) < this._player.height/2 + obsList[i].height/2)
						{
							var overlapX	:Number = this._player.width/2 + obsList[i].width/2 - Math.abs(vx);
							var overlapY	:Number = this._player.height/2 + obsList[i].height/2 - Math.abs(vy);
							if(this._screen != Constant.PLAY_SCREEN)
							{
								if(obsList[i].gotQns)
									showQuestion(i, obsList[i].qnsIndex);
							}
							
							if(obsList[i].type == Constant.COLLECT_OBS)
							{
								if(obsList[i].gotQns)
								{
									showQuestion(i, obsList[i].qnsIndex);
									break;
								}
								else
								{
									obsCollect(i, true);
									break;
								}
							}
							else if(overlapX >= overlapY)
							{
								if(vy > 0)
									this._player.y += overlapY;
								else
									this._player.y -= overlapY;
							}
							else
							{
								if(vx > 0)
									this._player.x += overlapX;
								else
									this._player.x -= overlapX;
							}
							
							if(obsList[i].type == Constant.DAMAGE_OBS)
								takeDamage();
							else if(obsList[i].type == Constant.TELE_OBS)
								teleport(this._obsPara[i]);
							else if(obsList[i].type == Constant.GOAL_OBS)
								finishStage();
							else if(obsList[i].type == Constant.DISAPPEAR_OBS)
								disappearObs(this._obsPara[i]);
							break;
						}
					}
				}
			}
		}
	
		/*-----------------------------------------------------------------------
		| @Check collision with enemies											|
		| @Take damage upon contact												|
		-------------------------------------------------------------------------*/
		private function checkCollisionWithEnemy():void
		{
			var enemyList	:Vector.<Enemies> = this._enemyList;
			if(enemyList != null)
			{
				if(enemyList.length != 0)
				{
					var vx			:Number;
					var vy			:Number;
					for(var i:uint=0; i< enemyList.length; i++)
					{
						vx = (this._player.x + (this._player.width/2)) - (enemyList[i].enemyX + (enemyList[i].image.width/2));
						vy = (this._player.y + (this._player.height/2)) - (enemyList[i].enemyY + (enemyList[i].image.height/2));
						
						if(Math.abs(vx) < this._player.width/2 + enemyList[i].image.width/2)
						{
							if(Math.abs(vy) < this._player.height/2 + enemyList[i].image.height/2)
							{	
								takeDamage();
							}
						}
					}
				}
			}
		}
		
		/**************************** SUPPORT FUNCTIONS ****************************/
		
		/*-----------------------------------------------------------------------
		| @Collect obstacles upon contact										|
		-------------------------------------------------------------------------*/
		public function obsCollect(index:Number, isCorrect:Boolean):void{
			//Remove obstacles from display
			this.removeChild(this._obsList[index]);
			//Remove obstacles from the obstacles list
			this._obsList.splice(index, 1);
			//Increase the stats
			if(isCorrect)
				this._currCollectObs ++;
			//Report to main controller to display on scoreboard
			this._controller.currCollectedObs = this._currCollectObs;
			this._controller.getGameStat("coin", this._currCollectObs);
		}
		
		/*-----------------------------------------------------------------------
		| @Take damage => life reduces											|
		-------------------------------------------------------------------------*/
		private function takeDamage():void{
			if(!this._isHit)
			{
				this._isHit = true;
				this._currLife --;
				this._controller.updateLifeScore(this._currLife);
				this._hitCounter = 0;
			}
			if(this._currLife == 0)
			{
				this._controller.isLost = true;
			}
		}
		
		/*-----------------------------------------------------------------------
		| @Teleport to certain location											|
		-------------------------------------------------------------------------*/
		private function teleport(location:Number):void{
			var validTile:Boolean = true;
			for(var i:uint =0; i<this._obsList.length; i++)
			{
				if(this._obsList[i].pos.equals(indexToPoint(location)))
				{
					validTile = false;
					break;
				}
			}
			if(validTile)
			{
				var yIndex	:Number;
				var xIndex	:Number;
				yIndex = Math.ceil(location/11)-1;
				xIndex = location - yIndex*11 -1;
				this._player.x = xIndex * 40;
				this._player.y = yIndex * 40;
				this._player.moveX = 0;
				this._player.moveY = 0;
				stopPlayer();
			
			}
		}
		
		private function disappearObs(index:Number):void{
			for(var i:uint = 0; i<this._obsList.length; i++)
			{
				if(this._obsList[i].pos.equals(indexToPoint(index)))
				{
					if(this._obsList[i].type != "05")
					{
						if(this._obsList[i].type != "01")
						{
							//Remove obstacles from display
							this.removeChild(this._obsList[i]);
							//Remove obstacles from the obstacles list
							this._obsList.splice(i, 1);
						}
					}
					break;
				}
			}
		}
		
		/*-----------------------------------------------------------------------
		| @Finish the stage														|
		| @Report back to server												|
		-------------------------------------------------------------------------*/
		private function finishStage():void{		
			this._controller.isWon = true;
		}
		
		/*-----------------------------------------------------------------------
		| @If obstacles got qns => show											|
		-------------------------------------------------------------------------*/
		private function showQuestion(id:Number, index:Number):void{
			if(!_isDisplayedQuiz)
			{
				var qns: Question = new Question(this._controller, index, id);
				this._isDisplayedQuiz = true;
				this.addChild(qns);
			}
		}
		
		/**====================================================================
		 * |                    		 APIs			                      | *
		 * ====================================================================**/
		/*-----------------------------------------------------------------------
		| @Compute the point on screen from given grid's index					|
		-------------------------------------------------------------------------*/
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
	}
}