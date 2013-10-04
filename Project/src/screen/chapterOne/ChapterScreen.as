package screen.chapterOne
{
	import assets.Assets;
	
	import constant.Constant;
	
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

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
					trace(key);
					this.addChild(_commonObject[key]);
				}
			}
		}
	}
}