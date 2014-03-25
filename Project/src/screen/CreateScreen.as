package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.List;
	import feathers.controls.TextInput;
	import feathers.dragDrop.IDragSource;
	import feathers.dragDrop.IDropTarget;
	
	import object.CreateGameObject.CreateGameBoard;
	import object.CreateGameObject.CreateGameScoreBoard;
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ObstaclesBoard;
	import object.inGameObject.ScoreBoard;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
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
		private var _scoreBoard		:CreateGameScoreBoard;
		
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
		private var _playerPosInput		:TextInput;
		private var _genderInput			:TextInput;
		
		//Enemy 1 character info
		private var _enemy1InputType		:TextInput;
		private var _enemy1InputPos		:TextInput;
		private var _enemy1InputSpeed	:TextInput;
		private var _enemy1InputImage	:TextInput;
		
		//Enemy 2 character info	
		private var _enemy2InputType		:TextInput;
		private var _enemy2InputPos		:TextInput;
		private var _enemy2InputSpeed	:TextInput;
		private var _enemy2InputImage	:TextInput;
		
		//added object
		private var _userDefinedQuestion : Array;
		private var _userDefinedObstacle : Array;
		private var _gameBoard           : CreateGameBoard;
		
		public function CreateScreen()
		{
			super();
			/*_controller 		= new Controller();
			
			_console 			= new Console		(_controller);
			_dialogue 			= new Dialogue		(_controller);
			_indexBoard 		= new IndexBoard	(_controller);
			_obstaclesBoard 	= new ObstaclesBoard(_controller);
			_scoreBoard			= new ScoreBoard	(_controller);
			
			_controller.assignObjectController(_console, _dialogue, null, _indexBoard, null, _obstaclesBoard, _scoreBoard);*/
			
		
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
		/*	placeImageOnScreen();
			setupInformationGetter();
			setupGameObject();
			
			this.addEventListener(Event.TRIGGERED, onButtonClicked);*/
			_gameBoard = new CreateGameBoard();
			
			this.addChild(_gameBoard);
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
			_playerPosInput 		= new TextInput();
			_genderInput			= new TextInput();
			
			_enemy1InputType 	= new TextInput();
			_enemy1InputPos		= new TextInput();
			_enemy1InputSpeed	= new TextInput();
			_enemy1InputImage	= new TextInput();
			
			_enemy2InputType 	= new TextInput();
			_enemy2InputPos		= new TextInput();
			_enemy2InputSpeed	= new TextInput();
			_enemy2InputImage	= new TextInput();
			
			/* Set background for each input box */
			_playerPosInput.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_genderInput.backgroundSkin 		= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			
			_enemy1InputType.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy1InputPos.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy1InputSpeed.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy1InputImage.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			
			_enemy2InputType.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy2InputPos.backgroundSkin 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy2InputSpeed.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			_enemy2InputImage.backgroundSkin = new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.INPUTBOX_IMG));
			
			/* Place them on the correct position on the screen */
			_playerPosInput.x 	= 196 + Constant.INFOBOARD_POS.x;	_playerPosInput.y 	= 281 + Constant.INFOBOARD_POS.y;
			_genderInput.x 	 	= 70  + Constant.INFOBOARD_POS.x;	_genderInput.y 		= 281 + Constant.INFOBOARD_POS.y;
			
			_enemy1InputType.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy1InputType.y 	= 321 + Constant.INFOBOARD_POS.y;
			_enemy1InputPos.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy1InputPos.y 	= 321 + Constant.INFOBOARD_POS.y;
			_enemy1InputSpeed.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy1InputSpeed.y 	= 343 + Constant.INFOBOARD_POS.y;
			_enemy1InputImage.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy1InputImage.y 	= 343 + Constant.INFOBOARD_POS.y;
			
			_enemy2InputType.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy2InputType.y 	= 376 + Constant.INFOBOARD_POS.y;
			_enemy2InputPos.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy2InputPos.y 	= 376 + Constant.INFOBOARD_POS.y;
			_enemy2InputSpeed.x 	= 70  + Constant.INFOBOARD_POS.x; 	_enemy2InputSpeed.y 	= 398 + Constant.INFOBOARD_POS.y;
			_enemy2InputImage.x 	= 196 + Constant.INFOBOARD_POS.x; 	_enemy2InputImage.y 	= 398 + Constant.INFOBOARD_POS.y;
			
			/* Restrict user input to numberic or alphabet */
			_playerPosInput.restrict 	= "0-9";
			_genderInput.restrict 		= "A-Z";
			
			_enemy1InputType.restrict 	= "0-9";
			_enemy1InputPos.restrict 	= "0-9";
			_enemy1InputSpeed.restrict 	= "\\. 0-9";
			_enemy1InputImage.restrict 	= "0-9";
			
			_enemy2InputType.restrict 	= "0-9";
			_enemy2InputPos.restrict 	= "0-9";
			_enemy2InputSpeed.restrict 	= "\\. 0-9";
			_enemy2InputImage.restrict 	= "0-9";
			
			_playerPosInput.maxChars 	= 2;
			_genderInput.maxChars 		= 6;
			
			/* Limit number of characters user can input */
			_enemy1InputType.maxChars	= 2;
			_enemy1InputPos.maxChars 	= 2;
			_enemy1InputSpeed.maxChars 	= 5;
			_enemy1InputImage.maxChars 	= 2;
			
			_enemy2InputType.maxChars 	= 2;
			_enemy2InputPos.maxChars 	= 2;
			_enemy2InputSpeed.maxChars 	= 5;
			_enemy2InputImage.maxChars 	= 2;
			
			/* Add Information Box to display */
			this.addChild(_playerPosInput);
			this.addChild(_genderInput);
			this.addChild(_enemy1InputType);
			this.addChild(_enemy1InputPos);
			this.addChild(_enemy1InputSpeed);
			this.addChild(_enemy1InputImage);
			this.addChild(_enemy2InputType);
			this.addChild(_enemy2InputPos);
			this.addChild(_enemy2InputSpeed);
			this.addChild(_enemy2InputImage);	
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
			var playerInfo		:Array  = new Array(_playerPosInput.text, _genderInput.text);
			var enemy1Info		:Array  = new Array(_enemy1InputType.text, _enemy1InputPos.text, _enemy1InputSpeed.text, _enemy1InputImage.text);
			var enemy2Info		:Array  = new Array(_enemy2InputType.text, _enemy2InputPos.text, _enemy2InputSpeed.text, _enemy2InputImage.text);
			
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