/************************************
 * ================================ *
 * CONTROLLER FOR INSTRUCTION ARROW *
 * ================================ * 
 ************************************/

package controller.chapterOne
{
	import object.chapterOne.InstrArrow;
	
	public class InstrArrController
	{
		
		//CONSTANT
		private static const DIALOG_ARROW_INSTRUCTION: Array = [[3,0], [4,2]];
		
		//VARIABLE
		private var _instrArrow     : InstrArrow;
		private var _dialogArrow  	 : Array;
		
		public function InstrArrController(arrow:InstrArrow)
		{
			this._instrArrow = arrow;
			_dialogArrow  = [[600, 120, 15, 0 ], [0, 0, 0, 0]];
		}
		
		public function showInstrArrowFromDialogBubble(index:int):void{;

			for(var i:uint = 0 ; i < DIALOG_ARROW_INSTRUCTION.length ; i++){
				
				if(DIALOG_ARROW_INSTRUCTION[i][0] == index){
					
					if(DIALOG_ARROW_INSTRUCTION[i][1] == 0){
						
						_instrArrow.toggleDisplayInstrArrow(true, false, 0);
						_instrArrow.setLeftArrow(_dialogArrow[i][0], _dialogArrow[i][1], _dialogArrow[i][2], _dialogArrow[i][3]);
					}
					else
						if(DIALOG_ARROW_INSTRUCTION[i][1] == 1){
							
							_instrArrow.toggleDisplayInstrArrow(true, false, 1);
							_instrArrow.setRightArrow(_dialogArrow[i][0], _dialogArrow[i][1], _dialogArrow[i][2], _dialogArrow[i][3]);
						}
						else
							if(DIALOG_ARROW_INSTRUCTION[i][1] == 2){
								
								_instrArrow.toggleDisplayInstrArrow(false, false, 0);
								_instrArrow.setLeftArrow(_dialogArrow[i][0], _dialogArrow[i][1], _dialogArrow[i][2], _dialogArrow[i][3]);
							}
							else
								if(DIALOG_ARROW_INSTRUCTION[i][1] == 3){
									
									_instrArrow.toggleDisplayInstrArrow(true, false, 0);
									_instrArrow.setLeftArrow(_dialogArrow[i][0], _dialogArrow[i][1], _dialogArrow[i][2], _dialogArrow[i][3]);
								}
								else
									trace('Something wrong witht the instruction arrow controller array');
				}
			}
		}
	}
}