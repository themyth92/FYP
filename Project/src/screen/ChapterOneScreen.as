package screen
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import flash.utils.Dictionary;
	
	import object.inGameObject.Button;
	import object.inGameObject.Console;
	import object.inGameObject.Dialogue;
	import object.inGameObject.Hero;
	import object.inGameObject.IndexBoard;
	import object.inGameObject.InstrArrow;
	import object.inGameObject.ObstaclesBoard;
	import object.inGameObject.ScoreBoard;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event; 

	public class ChapterOneScreen extends Sprite
	{
		private var _commonObject : Dictionary;
		private var _console 	  : Console;
		private var _button       : Button;
		private var _controller   : Controller;
		private var _dialogBubble : Dialogue;
		private var _instrArrow   : InstrArrow;
		private var _indexBoard   : IndexBoard;
		private var _patternList  : ObstaclesBoard;
		private var _scoreBoard	  : ScoreBoard;
		
		public function ChapterOneScreen()
		{
			_commonObject = new Dictionary();
			_controller   = new Controller();
			_console      = new Console(_controller);
			_dialogBubble = new Dialogue(_controller);
			_button       = new Button(_controller);
			_instrArrow   = new InstrArrow();
			_patternList  = new ObstaclesBoard(_controller);
			_indexBoard   = new IndexBoard(_controller);
			_scoreBoard	  = new ScoreBoard(_controller);
			
			_controller.assignObjectController(_console, _dialogBubble, _instrArrow, _indexBoard, _button, _patternList, _scoreBoard);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			this.assignChapterTexture();
			this.displayChapterTexture();
		}
		
		private function assignChapterTexture():void{
			
			var displayObject : Image;
			
			try{
				
				for ( var index:uint = 0 ; index < Constant.CHAP_ONE_TEXTURE_ARRAY.length ; index ++){
					
					if(Constant.CHAP_ONE_TEXTURE_ARRAY[index] == 'background'){
						
						displayObject = new Image(Assets.getAtlas(Constant.LOADING_SCREEN).getTexture('background'));
					}
					else{
						
						displayObject = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.CHAP_ONE_TEXTURE_ARRAY[index]));
					}
					
					_commonObject[Constant.CHAP_ONE_TEXTURE_ARRAY[index]] = displayObject;
					displayObject = null;
				}
			}
			catch(e:Error){
				trace('Array out of bound or can not get the texture in chapter one');
			}
		}
		
		private function displayChapterTexture():void{
			var key : String;
			//after that add all the static sprites from sprite 1 (neccessary files for chapter 1 only)
			for(var index:uint = 0 ; index < Constant.CHAP_ONE_TEXTURE_ARRAY.length ; index++){
				
				 key = Constant.CHAP_ONE_TEXTURE_ARRAY[index];
				
				if(_commonObject[key] != null){

					this.addChild(_commonObject[key]);
				}
			}
			
			this.addChild(_console);
			this.addChild(_button);
			this.addChild(_dialogBubble);
			this.addChild(_instrArrow);
			this.addChild(_patternList);
			this.addChild(_indexBoard);
			this.addChild(_scoreBoard);
			arrangeTexture();
		}
		
		private function arrangeTexture():void{
			_commonObject['teacher'].x = 4;
			_commonObject['teacher'].y = 198;
			
			_commonObject['mainFrame'].x = 96;
			_commonObject['mainFrame'].y = 75;
			
			_commonObject['grassBackground'].x = 107;
			_commonObject['grassBackground'].y = 82;
			
			_commonObject['heart'].x = 192;
			_commonObject['heart'].y = 33;
			
			_commonObject['volumeBar'].x = 615;
			_commonObject['volumeBar'].y = 335;
			
			_commonObject['volumeDecBtn'].x = 615;
			_commonObject['volumeDecBtn'].y = 350;
			
			_commonObject['volumeIncBtn'].x = 765;
			_commonObject['volumeIncBtn'].y = 350;
			
			_commonObject['volumeSlider'].x = 650;
			_commonObject['volumeSlider'].y = 327;
			
			_commonObject['bottomSelectionFrame'].x = 96;
			_commonObject['bottomSelectionFrame'].y = 451;
			
			_commonObject['pattern/pattern_03'].x = 80;
			_commonObject['pattern/pattern_03'].y = 33;
			
			_console.x = 611;
			_console.y = 48;
			
			_button.x  = 614;
			_button.y  = 384;
			
			_dialogBubble.x = 32;
			_dialogBubble.y = 20;
			
			_indexBoard.x = 107;
			_indexBoard.y = 82;
		}
	}
}