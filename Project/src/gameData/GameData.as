package gameData
{
	public class GameData
	{
		private static var _gameState : uint = 1;
		
		public static function getGameState():uint{
			return _gameState;
		}
		
		public static function setGameState(gameState : uint):void{
			_gameState = gameState;	
		}
	}
}