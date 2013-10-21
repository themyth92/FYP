package controller.chapterOne
{
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.BubbleController;
	import controller.chapterOne.HeroController;
	
	import object.chapterOne.Console;
	import object.chapterOne.DialogBubble;
	import object.chapterOne.Hero;
	
	public class Controller
	{
		private var _console		 : Console;
		private var _hero   		 : Hero;
		private var _dialogBubble	 : DialogBubble;
		private var _heroController : HeroController;
		private var _dialogBubbleController : BubbleController;
		
		public function Controller()
		{
		}
		
		public function notifyObserver(e:Object):void{
			
			if(e.event){
				if(e.event == Constant.TRIGGER){
					switch(e.target){
						case Constant.DIALOG_NEXT_ARROW:
							_dialogBubbleController.changeDialog(e.arg);
						break;
						default:
						break;
					}
				}
			}
			else
				trace('Error with event undefined');
		}
		
		public function assignObjectController(console:Console, hero:Hero, dialogBubble:DialogBubble):void{
			this._console 		    = console;
			this._hero    	        = hero;
			this._dialogBubble     = dialogBubble;
			_heroController         = new HeroController(_hero);
			_dialogBubbleController = new BubbleController(_dialogBubble);
		}
	}
}