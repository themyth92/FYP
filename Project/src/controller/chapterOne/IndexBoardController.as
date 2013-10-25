package controller.chapterOne
{
	import object.chapterOne.IndexBoard;
	
	public class IndexBoardController
	{
		private static const MAXIMUM_PATTERN:uint      = 1;
		private static const LIST_COMMAND:Array        = [0,1];
		private static const CREATE_LENGTH_ARRAY       = 2;
		private static const DELETE_LENGTH_ARRAY       = 3;
		private static const FALSE_LENGTH_ARRAY        = 1;
		
		private var _indexBoard : IndexBoard;
		
		public function IndexBoardController(board:IndexBoard)
		{
			this._indexBoard = board;
		}
		
		public function analyzeArrayInput(arr:Array):void{
			
			if(arr.length == FALSE_LENGTH_ARRAY)
				return ;
			else if(arr.length == DELETE_LENGTH_ARRAY){
				
				if(arr[0] == LIST_COMMAND[0]){
					
					var index:uint = arr[1];
					_indexBoard.deleteObject(index);
				}
			}
			else if(arr.length == CREATE_LENGTH_ARRAY){
				
				if(arr[0] == LIST_COMMAND[1]){
					
					var index:uint   = arr[2];
					var name :String = arr[1];
					_indexBoard.createObject(name, index);
				}
			}
			
			trace('Array from console controller is not in defined format');
			return;
		}
	}
}