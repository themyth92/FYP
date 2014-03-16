package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.TextInput;
	
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ObstaclesBoard;
	import object.inGameObject.ScoreBoard;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class CreateScreen extends Sprite
	{
		//Game Objects
		private var _console		:Console;
		private var _dialogue		:Dialogue;
		private var _indexBoard		:IndexBoard;
		private var _obstaclesBoard	:ObstaclesBoard;
		private var _scoreBoard		:ScoreBoard;
		
		//Display Texture
		private var _background		:Image;
		private var _screen			:Image;
		private var _consoleIMG		:Image;
		private var _frameIMG		:Image;
		private var _screenIMG		:Image;
		private var _gridIMG		:Image;
		private var _dialogueIMG	:Image;
		private var _infoBoardIMG	:Image;
		private var _previewButton	:Button;
		private var _startButton	:Button;
		private var _publishButton	:Button;
		private var _errormsg		:String;
		
		//Boolean
		private var _isFirstTime	:Boolean = true;
		
		//Controller
		private var _controller		:Controller;
		
		//Player characters info
		private var _playerPos		:TextInput;
		private var _gender			:TextInput;
		
		//Enemy 1 character info
		private var _enemy1Type		:TextInput;
		private var _enemy1Pos		:TextInput;
		private var _enemy1Speed	:TextInput;
		private var _enemy1Image	:TextInput;
		
		//Enemy 2 character info	
		private var _enemy2Type		:TextInput;
		private var _enemy2Pos		:TextInput;
		private var _enemy2Speed	:TextInput;
		private var _enemy2Image	:TextInput;
		
		public function CreateScreen()
		{
			super();
			_controller 		= new Controller();
			
			_console 			= new Console		(_controller);
			_dialogue 			= new Dialogue		(_controller);
			_indexBoard 		= new IndexBoard	(_controller);
			_obstaclesBoard 	= new ObstaclesBoard(_controller);
			_scoreBoard			= new ScoreBoard	(_controller);
			
			_controller.assignObjectController(_console, _dialogue, null, _indexBoard, null, _obstaclesBoard, _scoreBoard);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			placeImageOnScreen();
			setupInformationGetter();
			setupGameObject();
			
			this.addEventListener(Event.TRIGGERED, onButtonClicked);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function placeImageOnScreen():void
		{
			/* load object image into variables */
			this._background	= new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('background'));
			this._screen		= new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture('WaterScreen'));
			this._frameIMG 		= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.FRAME_IMG));
			this._dialogueIMG 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.DIALOGUE_IMG));
			this._gridIMG 		= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.GRID_IMG));
			this._infoBoardIMG 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INFOBOARD_IMG));
			this._startButton 	= new Button(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.PLAYB_IMG));
			this._previewButton = new Button(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.PREVIEWB_IMG));
			this._publishButton = new Button(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.PUBLISHB_IMG));
			
			/* place object at corresponding location */
			this._frameIMG.x 		= Constant.FRAME_CREATE_POS.x;
			this._frameIMG.y 		= Constant.FRAME_CREATE_POS.y;
						
			this._dialogueIMG.x 	= Constant.DIALOGUE_POS.x;
			this._dialogueIMG.y 	= Constant.DIALOGUE_POS.y;
			
			this._screen.x			= Constant.GRID_CREATE_POS.x;
			this._screen.y			= Constant.GRID_CREATE_POS.y;
			
			this._gridIMG.x 		= Constant.GRID_CREATE_POS.x;
			this._gridIMG.y 		= Constant.GRID_CREATE_POS.y;
			
			this._infoBoardIMG.x 	= Constant.INFOBOARD_POS.x;
			this._infoBoardIMG.y 	= Constant.INFOBOARD_POS.y;			
			
			this._startButton.x 	= Constant.STARTB_POS.x;
			this._startButton.y 	= Constant.STARTB_POS.y;
			
			this._previewButton.x 	= Constant.PREVIEWB_POS.x;
			this._previewButton.y 	= Constant.PREVIEWB_POS.y;
			
			this._publishButton.x 	= Constant.PUBLISHB_POS.x;
			this._publishButton.y 	= Constant.PUBLISHB_POS.y;
			
			/* add image to display */
			this.addChild(_background);
			this.addChild(_frameIMG);
			this.addChild(_dialogueIMG);
			this.addChild(_screen);
			this.addChild(_gridIMG);
			this.addChild(_infoBoardIMG);
			this.addChild(_startButton);
			this.addChild(_previewButton);
			this.addChild(_publishButton);
		}
		
		private function setupInformationGetter():void
		{
			_playerPos 		= new TextInput();
			_gender			= new TextInput();
			
			_enemy1Type 	= new TextInput();
			_enemy1Pos		= new TextInput();
			_enemy1Speed	= new TextInput();
			_enemy1Image	= new TextInput();
			
			_enemy2Type 	= new TextInput();
			_enemy2Pos		= new TextInput();
			_enemy2Speed	= new TextInput();
			_enemy2Image	= new TextInput();
			
			/* Set background for each input box */
			_playerPos.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_gender.backgroundSkin 		= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			
			_enemy1Type.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy1Pos.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy1Speed.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy1Image.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			
			_enemy2Type.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy2Pos.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy2Speed.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy2Image.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			
			/* Place them on the correct position on the screen */
			_playerPos.x 	= 196 + Constant.INFOBOARD_POS.x;	_playerPos.y 	= 281 + Constant.INFOBOARD_POS.y;
			_gender.x 	 	= 70  + Constant.INFOBOARD_POS.x;	_gender.y 		= 281 + Constant.INFOBOARD_POS.y;
			
			_enemy1Type.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy1Type.y 	= 321 + Constant.INFOBOARD_POS.y;
			_enemy1Pos.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy1Pos.y 	= 321 + Constant.INFOBOARD_POS.y;
			_enemy1Speed.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy1Speed.y 	= 343 + Constant.INFOBOARD_POS.y;
			_enemy1Image.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy1Image.y 	= 343 + Constant.INFOBOARD_POS.y;
			
			_enemy2Type.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy2Type.y 	= 376 + Constant.INFOBOARD_POS.y;
			_enemy2Pos.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy2Pos.y 	= 376 + Constant.INFOBOARD_POS.y;
			_enemy2Speed.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy2Speed.y 	= 398 + Constant.INFOBOARD_POS.y;
			_enemy2Image.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy2Image.y 	= 398 + Constant.INFOBOARD_POS.y;
			
			/* Restrict user input to numberic or alphabet */
			_playerPos.restrict 	= "0-9";
			_gender.restrict 		= "A-Z";
			
			_enemy1Type.restrict 	= "0-9";
			_enemy1Pos.restrict 	= "0-9";
			_enemy1Speed.restrict 	= "\\. 0-9";
			_enemy1Image.restrict 	= "0-9";
			
			_enemy2Type.restrict 	= "0-9";
			_enemy2Pos.restrict 	= "0-9";
			_enemy2Speed.restrict 	= "\\. 0-9";
			_enemy2Image.restrict 	= "0-9";
			
			_playerPos.maxChars 	= 2;
			_gender.maxChars 		= 6;
			
			/* Limit number of characters user can input */
			_enemy1Type.maxChars	= 2;
			_enemy1Pos.maxChars 	= 2;
			_enemy1Speed.maxChars 	= 5;
			_enemy1Image.maxChars 	= 2;
			
			_enemy2Type.maxChars 	= 2;
			_enemy2Pos.maxChars 	= 2;
			_enemy2Speed.maxChars 	= 5;
			_enemy2Image.maxChars 	= 2;
			
			/* Add Information Box to display */
			this.addChild(_playerPos);
			this.addChild(_gender);
			this.addChild(_enemy1Type);
			this.addChild(_enemy1Pos);
			this.addChild(_enemy1Speed);
			this.addChild(_enemy1Image);
			this.addChild(_enemy2Type);
			this.addChild(_enemy2Pos);
			this.addChild(_enemy2Speed);
			this.addChild(_enemy2Image);	
		}
		
		private function setupGameObject():void
		{
			_console.x 		= Constant.CONSOLE_CREATE_POS.x;
			_console.y 		= Constant.CONSOLE_CREATE_POS.y;
			
			_dialogue.x 	= Constant.DIALOGUE_POS.x;
			_dialogue.y 	= Constant.DIALOGUE_POS.y;
			
			_indexBoard.x 	= Constant.GRID_CREATE_POS.x;
			_indexBoard.y 	= Constant.GRID_CREATE_POS.y;
			
			_scoreBoard.x	= 0;
			_scoreBoard.y	= 0;
			
			_obstaclesBoard.x = Constant.INFOBOARD_POS.x + Constant.OBSBOARD_POS.x;
			_obstaclesBoard.y = Constant.INFOBOARD_POS.y + Constant.OBSBOARD_POS.y;
			
			this.addChild(_console);
			this.addChild(_dialogue);
			this.addChild(_indexBoard);
			this.addChild(_obstaclesBoard);
			this.addChild(_scoreBoard);
		}
		
		private function onButtonClicked(event:Event):void
		{
			var buttonClicked	:Button = event.target as Button;
			var playerInfo		:Array  = new Array(_playerPos.text, _gender.text);
			var enemy1Info		:Array  = new Array(_enemy1Type.text, _enemy1Pos.text, _enemy1Speed.text, _enemy1Image.text);
			var enemy2Info		:Array  = new Array(_enemy2Type.text, _enemy2Pos.text, _enemy2Speed.text, _enemy2Image.text);
			
			if(buttonClicked == _startButton)
			{
				this._gridIMG.visible = false;
				_errormsg = _controller.startGame(playerInfo, enemy1Info, enemy2Info);
			}
			else if(buttonClicked == _previewButton)
			{
				
				_errormsg = _controller.previewGame(playerInfo, enemy1Info, enemy2Info);
			}
			else if(buttonClicked == _publishButton)
			{
				
			}
		}
	}
}