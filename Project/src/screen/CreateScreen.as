package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import feathers.controls.List;
	import feathers.controls.TextInput;
	import feathers.dragDrop.IDragSource;
	import feathers.dragDrop.IDropTarget;
	
	import object.CreateGameObject.CreateGameBoard;
	import object.CreateGameObject.CreateGameScoreBoard;
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
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
		private var _controller		:MainController;
		
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
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_gameBoard = new CreateGameBoard();
			
			this.addChild(_gameBoard);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	}
}