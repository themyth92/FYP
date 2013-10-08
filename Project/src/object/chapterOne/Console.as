package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import feathers.controls.TextArea;
	
	import flash.text.TextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Console extends Sprite
	{
		private var _textField    :TextArea;
		private var _consoleNotes :Image;
		
		public function Console()
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddedToStage(e:Event):void{
					
			try{
				
				_textField    = new TextArea();
				_consoleNotes = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.CONSOLE));
				
				_textField.x          					   = Constant.TEXTFIELD_POSX;
				_textField.y          					   = Constant.TEXTFIELD_POSY;
				_textField.width      					   = Constant.TEXTFIELD_WIDTH;
				_textField.height     					   = Constant.TEXTFIELD_HEIGTH;
				_textField.isEditable 					   = true;
				_textField.textEditorProperties.textFormat = new TextFormat(Constant.GROBOLD_FONT, 13);
			}
			catch(e:Error){
				
				trace('Can not load texture');
			}
			
			if(_consoleNotes != null && _textField != null){
				
				this.addChild(_consoleNotes);
				this.addChild(_textField);
			}
		}
		
		private function onRemoveFromStage(e:Event):void{
			
			this.removeChild(_consoleNotes);
			this.removeChild(_textField);
			_consoleNotes = null;
			_textField    = null;
		}
	}
}