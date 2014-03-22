package controller.ObjectController
{
	import object.inGameObject.ScoreBoard;
	
	public class ScoreBoardController
	{
		private var _scoreBoard : ScoreBoard;
		
		public function ScoreBoardController(scoreBoard:ScoreBoard)
		{
			this._scoreBoard = scoreBoard;
		}
		
		public function coinUpdateProcess(currentCoin:Number, maxCoin:Number):void
		{
			_scoreBoard.updateCoinTracker(currentCoin, maxCoin);
		}
		
		public function lifeUpdateProcess(currentLife:Number, maxLife:Number):void
		{
			_scoreBoard.updateLifeTracker(currentLife, maxLife);
		}
		
		public function changeObjectState(currentState:String):void
		{
			this._scoreBoard.changeState(currentState);
		}
		
		public function enableLifeEdit(value:Boolean):void
		{
			this._scoreBoard.isLifeEnabled = value;
		}
		
		public function enableTimeEdit(value:Boolean):void
		{
			this._scoreBoard.isTimeEnabled = value;
		}
	}
}