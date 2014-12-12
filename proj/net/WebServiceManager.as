package proj.net 
{
	
	
	/**WebService通信管理器
	 * ...
	 * 需要在flash发布设置里导入以下库：
	 * Program Files\Adobe\Adobe Flash Builder 4\sdks\3.5.0\frameworks\libs\framework.swc
	 * Program Files\Adobe\Adobe Flash Builder 4\sdks\3.5.0\frameworks\libs\rpc.swc
	 * 
	 * How to Use it:
	 * WebServiceManager.getIns().registerWSDL("http://220.169.30.103/ICOID4External/COIDService.asmx");
		WebServiceManager.getIns().OperationMethod("mathodName", parameters);
		
	 * @author Sean Lee
	 */
	
	import flash.events.EventDispatcher;
	import mx.rpc.soap.*;
	import mx.core.*;
	import mx.rpc.events.*;
	
	public class WebServiceManager extends EventDispatcher
	{
		private static var WSM:WebServiceManager;
		
		private var _ws:WebService;
		private var _operation:Operation;
		
		public function WebServiceManager() 
		{
			_ws = new WebService();
			_ws.addEventListener("load", onWSOnLoad_handle);
		}
		
		public static function getIns():WebServiceManager
		{
			if (WSM == null)
			{
				WSM = new WebServiceManager();
			}
			return WSM;
		}
		
		///注册webservice地址
		public function registerWSDL(wsdl:String):void 
		{
			_ws.wsdl = wsdl + "?wsdl";
			_ws.loadWSDL();
		}
		
		///连接webservice方法
		public function OperationMethod(methodName:String,...rest):void
		{
			_operation = Operation(_ws.getOperation(methodName));
			
			if (_operation)
			{
				_operation.addEventListener("fault", wsError_handle);
				_operation.addEventListener("result", wsResult_handle);
				_operation.send(rest);
			}
		}
		
		//============================================================================Handle
		//
		private function onWSOnLoad_handle(evt:LoadEvent):void
		{
			
		}
		
		//
		private function wsError_handle(evt:FaultEvent):void
		{
			trace(evt);
		}
		
		//
		private function wsResult_handle(evt:ResultEvent):void
		{
			trace(evt.result);
		}
		
	}

}