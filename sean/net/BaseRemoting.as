package sean.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.system.Security;
	import jdhcn.global.Global;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname BaseRemoting
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class BaseRemoting extends EventDispatcher
	{
		private var gateway:String = "";
		private var nc:NetConnection;
		private var responder:Responder;
		protected var _result:Object;
		
		public static const CALL_SUCCESS:String = "call_success";
		public static const CALL_FAILED:String = "call_failed";
		
		public function BaseRemoting():void 
		{
			super();
			Security.allowDomain("*");
			
		}
		
		public function connect(url:String):void 
		{
			gateway = url;
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onStatusHandler);
			nc.connect(gateway);
		}
		
		public function call(serverMethod:String, ... args):void
		{
			responder = new Responder(onResult, onFault); 
			var str:String = "";
			for (var i:uint = 0; i < args.length; i++)
			{
				str += args[i] + "|";
			}
			nc.call(serverMethod, responder, str); 
		}
		
		public function getResult():Object
		{
			return _result;
		}
		
		private function onFault(fault:Object):void
		{
			Global.traceStr("错误: [");
			for (var i in fault)
			{ 
				Global.traceStr(i + ", " + fault[i]); 
            }
			Global.traceStr("]");
			_result = fault;
			dispatchEvent(new Event(CALL_FAILED));
		}
		
		private function onResult(result:Object):void
		{
			Global.traceStr("结果: " + String(result)); 
			_result = result;
			dispatchEvent(new Event(CALL_SUCCESS));
		}
		
		private function onStatusHandler(evt:NetStatusEvent):void
		{
			trace(evt.info.code);
			switch(String(evt.info.code))
			{
				case "NetConnection.Call.Failed":
					trace("方法调用失败");
					break;
				case "NetConnection.Connect.Rejected":
					var appmsg:String = (evt.info.application == undefined) ? "" : evt.info.application;
					trace(appmsg);
					break;
				case "NetConnection.Connect.Failed":
					trace("连接失败");
					break;
				case "NetConnection.Connect.Closed":
					//
					break;
				case "NetConnection.Connect.Success":
					trace("连接成功！");
					break;
			}
		}
		
	}
}