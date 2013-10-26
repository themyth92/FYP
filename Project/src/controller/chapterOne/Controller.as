package controller.chapterOne
{
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.BubbleController;
	import controller.chapterOne.ConsoleController;
	import controller.chapterOne.HeroController;
	import controller.chapterOne.IndexBoardController;
	import controller.chapterOne.InstrArrController;
	
	import object.chapterOne.Console;
	import object.chapterOne.DialogBubble;
	import object.chapterOne.Hero;
	import object.chapterOne.IndexBoard;
	import object.chapterOne.InstrArrow;
	
	public class Controller
	{
		private var _console		 		 : Console;
		private var _hero   		 		 : Hero;
		private var _dialogBubble	 		 : DialogBubble;
		private var _heroController 		 : HeroController;
		private var _instrArrow     		 : InstrArrow;
		private var _indexBoard             : IndexBoard;
		private var _dialogBubbleController : BubbleController;
		private var _instrArrowController 	 : InstrArrController;
		private var _consoleController      : ConsoleController;
		private var _indexBoardController   : IndexBoardController;
		
		public function Controller()
		{
		}
		
		public function notifyObserver(e:Object):void{
			
			if(e.event){
				if(e.event == Constant.TRIGGER){
					switch(e.target){
						case Constant.DIALOG_NEXT_ARROW:
							_dialogBubbleController.changeDialog(e.arg);
							_instrArrowController.showInstrArrowFromDialogBubble(e.arg);
						break;
						case Constant.SUBMIT_BTN:
							var commandArr:Array = _consoleController.consoleControllerActivate();
							_indexBoardController.analyzeArrayInput(commandArr);
						break;
						default:
						break;
					}
				}
			}
			else
				trace('Error with event undefined');
		}
		
		public function assignObjectController(console:Console, hero:Hero, dialogBubble:DialogBubble, instrArrow:InstrArrow, indexBoard:IndexBoard):void{
			
			this._console 		    = console;
			this._hero    	        = hero;
			this._dialogBubble      = dialogBubble;
			this._instrArrow        = instrArrow;
			this._indexBoard        = indexBoard;
			
			_heroController         = new HeroController(_hero);
			_dialogBubbleController = new BubbleController(_dialogBubble);
			_instrArrowController   = new InstrArrController(_instrArrow);
			_consoleController      = new ConsoleController(_console);
			_indexBoardController   = new IndexBoardController(_indexBoard);
		}
	}
}