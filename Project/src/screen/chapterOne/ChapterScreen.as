package screen.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import object.chapterOne.Button;
	import object.chapterOne.Console;
	import object.chapterOne.DialogBubble;
	import object.chapterOne.IndexBoard;
	import object.chapterOne.Score;

	public class ChapterScreen extends Sprite
	{
		private var _commonObject : Dictionary;
		
		public function ChapterScreen()
		{
			_commonObject = new Dictionary();
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
			
			arrangeTexture();
		}
		
		private function arrangeTexture():void{
			_commonObject['teacher'].x = 13;
			_commonObject['teacher'].y = 233;
			
			_commonObject['dialogBubble'].x = 52;
			_commonObject['dialogBubble'].y = 13;
			
			_commonObject['heart'].x = 284;
			_commonObject['heart'].y = 36;
			
			_commonObject['scoreFace'].x = 503;
			_commonObject['scoreFace'].y = 34;
			
			_commonObject['mainFrame'].x = 150;
			_commonObject['mainFrame'].y = 97;
			
			_commonObject['grassBackground'].x = 165;
			_commonObject['grassBackground'].y = 108;
			
			_commonObject['frameWithIndex'].x =164;
			_commonObject['frameWithIndex'].y = 108;
			
			_commonObject['heart'].x = 287;
			_commonObject['heart'].y = 37;
			
			_commonObject['scoreFace'] = 506;
			_commonObject['scoreFace'] = 34;
			
			_commonObject['consoleNote'].x = 838;
			_commonObject['consoleNote'].y = 58;
			
			_commonObject['volumeBar'].x = 838;
			_commonObject['volumeBar'].y = 549;
			
			_commonObject['volumeDecBtn'].x = 838;
			_commonObject['volumeDecBtn'].y = 566;
			
			_commonObject['volumeIncBtn'].x = 1063;
			_commonObject['volumeIncBtn'].y = 566;
			
			_commonObject['bottomSelectionFrame'].x = 150;
			_commonObject['bottomSelectionFrame'].y = 635;
		}
	}
}