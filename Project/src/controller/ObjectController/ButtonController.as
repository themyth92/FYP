package controller.ObjectController
{
	import object.inGameObject.Button;
	
	public class ButtonController
	{
		private var _button:Button;
		
		public function ButtonController(button:Button)
		{
			this._button = button;
		}
		
		public function changeObjectState(currentState:String):void
		{
			this._button.changeState(currentState);
		}
	}
}