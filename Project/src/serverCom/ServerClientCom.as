package serverCom
{
	import flash.external.ExternalInterface;
	
	public class ServerClientCom
	{
		private  var qsImgList       : Object;
		
		public function ServerClientCom()
		{
			qsImgList        = {};
		}
		
		public function retrieveQuestionAndImageListFromServer():Object{
			
			qsImgList = ExternalInterface.call('returnUserQuestionListAndImage');
			return qsImgList;
		}
		
		public function saveUserIngameState(userIngameState : uint):void{
			
			ExternalInterface.call('saveUserIngameState', userIngameState);
		}
		
		public function saveUserGameCreation(returnData: Object):void{
			
			ExternalInterface.call('saveGameCreation', returnData);
		}
	}
}