package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import object.inGameObject.Dialogue;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.ScoreBoard;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StoryStage1 extends Sprite
	{
		private var _dialogue		:Dialogue;
		private var _indexBoard		:IndexBoard;
		private var _scoreBoard		:ScoreBoard;
		
		private var _background		:Image;
		private var _screen			:Image;
		private var _frameIMG		:Image;
		private var _dialogueIMG	:Image;
		private var _guiderIMG		:Image;
		private var _escButton		:Button;
		
		private var _controller		:Controller;
		
		public function StoryStage1()
		{
			super();
			
			_controller 	= new Controller ();
			_dialogue		= new Dialogue(_controller);
			_indexBoard		= new IndexBoard(_controller);
			_scoreBoard		= new ScoreBoard(_controller);
			
			_controller.assignObjectController(null, _dialogue, null, _indexBoard, null, null, _scoreBoard);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			placeImageOnScreen();
			setupGameObject();
			
			this.addEventListener(Event.TRIGGERED, onButtonClicked);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function placeImageOnScreen():void
		{
			/* Load the image into variables */
			this._background	= new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('background'));
			this._screen		= new Image(Assets.getAtlas(Constant.SCREEN_SPRITE).getTexture('GrassScreen'));
			this._frameIMG 		= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.FRAME_IMG));
			this._dialogueIMG 	= new Image(Assets.getAtlas(Constant.CREATE_GAME_SCREEN).getTexture(Constant.DIALOGUE_IMG));
			//this._guiderIMG	= new Image();
			//this._escButton	= new Button();
			
			/* Place the image to correct position on screen */
			this._frameIMG.x 		= Constant.FRAME_STORY_POS.x;
			this._frameIMG.y 		= Constant.FRAME_STORY_POS.y;
			
			this._dialogueIMG.x 	= Constant.DIALOGUE_POS.x;
			this._dialogueIMG.y 	= Constant.DIALOGUE_POS.y;
			
			this._screen.x			= Constant.GRID_STORY_POS.x;
			this._screen.y			= Constant.GRID_STORY_POS.y;
			
//			this._guiderIMG.x		= Constant.GUIDER_POS.x;
//			this._guiderIMG.y		= Constant.GUIDER_POS.y;
//			
//			this._escButton.x		= Constant.ESCBUTTON_POS.x;
//			this._escButton.y		= Constant.ESCBUTTON_POS.y;
			
			/* Add image to display */
			this.addChild(_background);
			this.addChild(_frameIMG);
			this.addChild(_dialogueIMG);
			this.addChild(_screen);
//			this.addChild(_guiderIMG);
//			this.addChild(_escButton);
		}
		
		private function setupGameObject():void
		{
			_dialogue.x 	= Constant.DIALOGUE_POS.x;
			_dialogue.y 	= Constant.DIALOGUE_POS.y;
			
			_indexBoard.x 	= Constant.GRID_STORY_POS.x;
			_indexBoard.y 	= Constant.GRID_STORY_POS.y;
			
			this.addChild(_dialogue);
			this.addChild(_indexBoard);
			this.addChild(_scoreBoard);
		}
		
		private function onButtonClicked(event:Event):void
		{
			//back to menu page
		}
	}
}