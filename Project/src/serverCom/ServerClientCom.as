package serverCom
{
	import flash.external.ExternalInterface;
	
	public class ServerClientCom
	{
		public  var qsImgList : Object;
		
		public function ServerClientCom()
		{
			qsImgList = {};
		}
		
		public function retrieveQuestionAndImageListFromServer():Object{
			
			qsImgList = ExternalInterface.call('returnUserQuestionListAndImage');
			return qsImgList;
		}
	}
}