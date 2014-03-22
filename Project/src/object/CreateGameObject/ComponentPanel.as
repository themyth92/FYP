package object.CreateGameObject
{
	import feathers.controls.ScrollText;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ComponentPanel extends Sprite
	{
		private var _titleInput	:TextInput;
		
		//used to notify user when the game is saved
		//or when user has error
		//this is used in game creation part
		private var _notiPanel   	:ScrollText;
		
		public function ComponentPanel()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//return the title of the input
		public function getTitle():String{
			return this._titleInput.text;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._titleInput = new TextInput();		
			this._titleInput.textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontSize = 12;
				return editor;
			}
				
			//change the textinput width and height
			this._titleInput.width = 150;
			this._titleInput.height = 50;
			
			//debugger to notify error to user
			this._notiPanel        	= new ScrollText();
			
			this.addChild(this._titleInput);
		}
	}
}