package controller.chapterOne
{
	import object.chapterOne.IndexBoard;
	
	public class IndexBoardController
	{
		private var _numberOfCoin					:Number;
		private static const MAXIMUM_PATTERN		:uint   = 1;
		private static const LIST_COMMAND			:Array 	= [0,1];
		private static const CREATE_LENGTH_ARRAY	:uint   = 3;
		private static const DELETE_LENGTH_ARRAY 	:uint   = 2;
		private static const FALSE_LENGTH_ARRAY 	:uint   = 1;
		private static const COIN_TYPE				:String = "03";
		private static const HERO_TYPE				:String = "04";
		
		private var _indexBoard : IndexBoard;
		
		public function IndexBoardController(board:IndexBoard)
		{
			this._indexBoard   = board;
			this._numberOfCoin = 0;
		}
		
		public function analyzeArrayInput(arr:Array):void
		{			
			if(arr.length == FALSE_LENGTH_ARRAY)
				return ;
			else if(arr.length == DELETE_LENGTH_ARRAY){				
				if(arr[0] == LIST_COMMAND[0]){
					var index:uint = arr[1];
					_indexBoard.deleteObject(index);
					return;
				}
			}
			else if(arr.length == CREATE_LENGTH_ARRAY){
				if(arr[0] == LIST_COMMAND[1]){
					
					index            = arr[2];
					var name :String = arr[1];
					updateCoinAmount(name);
					_indexBoard.createObject(name, index);
					return;
				}
			}
			
			trace('Array from console controller is not in defined format');
			return;
		}
		
		public function checkCoinAvail():Boolean
		{
			if(_numberOfCoin <= 0)
				return false;
			else 
				return true;
		}
		
		private function updateCoinAmount(type:String):void
		{	
			if(type == COIN_TYPE)
				_numberOfCoin ++;
			return;
		}
	}
}