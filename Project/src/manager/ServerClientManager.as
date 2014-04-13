package manager
{
	import flash.external.ExternalInterface;
	
	public class ServerClientManager
	{
		public function ServerClientManager()
		{
		}
		
		public function saveUserIngameState(userIngameState : uint):void
		{
			ExternalInterface.call('saveUserIngameState', userIngameState);
		}
		
		public function saveUserGameCreation(returnData: Object, callBack : Function):void
		{
			ExternalInterface.call('saveGameCreation', returnData);
		}
		
		public function registerSaveGameCallBack(callBack: Function):void
		{
			ExternalInterface.addCallback('waitForServerRespondSavedGame', callBack);
		}
		
		public function initCallServer():Object
		{
			var returnData: Object = {};
			
			returnData = ExternalInterface.call('initCallServer');
			
			return returnData;
		}
		
		public function quitGame():void
		{
			ExternalInterface.call('quitGame');	
		}
		
		public function publishGame(returnData: Object):void
		{
			ExternalInterface.call('publishGame', returnData);
		}
		
		public function sendQnsStats(returnData: Object):void
		{
			ExternalInterface.call('updateQuestionPoll', returnData);
		}
	}
}