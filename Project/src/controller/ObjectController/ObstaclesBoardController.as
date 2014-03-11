package controller.ObjectController
{
	import object.inGameObject.ObstaclesBoard;
	
	public class ObstaclesBoardController
	{
		private var _patternList 	:ObstaclesBoard;
		
		public function ObstaclesBoardController(patternList:ObstaclesBoard)
		{
			this._patternList = patternList;
		}
		
		public function changeObjectState(currentState:String):void
		{
			this._patternList.changeState(currentState);
		}
	}
}