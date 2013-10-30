package screen.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.chapterOne.Controller;
	
	import flash.utils.Dictionary;
	
	import object.chapterOne.Button;
	import object.chapterOne.Console;
	import object.chapterOne.DialogBubble;
	import object.chapterOne.Hero;
	import object.chapterOne.IndexBoard;
	import object.chapterOne.InstrArrow;
	import object.chapterOne.PatternList;
	import object.chapterOne.Score;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event; 

	public class ChapterScreen extends Sprite
	{
		private var _commonObject : Dictionary;
		private var _console 	   : Console;
		private var _button       : Button;
		private var _controller   : Controller;
		//private var _hero         : Hero;
		private var _dialogBubble : DialogBubble;
		private var _instrArrow   : InstrArrow;
		private var _indexBoard   : IndexBoard;
		private var _patternList  : PatternList;
		
		public function ChapterScreen()
		{
			_commonObject = new Dictionary();
			_controller   = new Controller();
			_console      = new Console(_controller);
			//_hero         = new Hero(_controller);
			_dialogBubble = new DialogBubble(_controller);
			_button       = new Button(_controller);
			_instrArrow   = new InstrArrow();
			_patternList  = new PatternList();
			_indexBoard   = new IndexBoard(_controller);
			
			_controller.assignObjectController(_console, _dialogBubble, _instrArrow, _indexBoard);
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
			//this.addChild(_hero);
			this.addChild(_dialogBubble);
			this.addChild(_instrArrow);
			this.addChild(_patternList);
			this.addChild(_indexBoard);
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
			
			_commonObject['scoreFace'] = 375;
			_commonObject['scoreFace'] = 32;
			
			_commonObject['volumeBar'].x = 838;
			_commonObject['volumeBar'].y = 549;
			
			_commonObject['volumeDecBtn'].x = 838;
			_commonObject['volumeDecBtn'].y = 566;
			
			_commonObject['volumeIncBtn'].x = 1063;
			_commonObject['volumeIncBtn'].y = 566;
			
			_commonObject['bottomSelectionFrame'].x = 96;
			_commonObject['bottomSelectionFrame'].y = 451;
			
			_console.x = 611;
			_console.y = 48;
			
			_button.x  = 614;
			_button.y  = 384;
			
			//_hero.x = 300;
			//_hero.y = 500;
			
			_dialogBubble.x = 32;
			_dialogBubble.y = 20;
			
			_indexBoard.x = 107;
			_indexBoard.y = 82;
		}
	}
}