package proj.net 
{
	
	/**服务器代理类
	 * ...
	 * @author ==★ Sean Lee ★==
	*/
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.system.Security;
	
	public class SocketManager extends EventDispatcher
	{
		private static var SP:SocketManager;
		
		private var _socket:Socket;
		
		private var _cmdID:String;
		private var _cmdData:ByteArray;
		
		///连接服务器成功事件
		public static const EVENT_CONNECT_SUCCESS:String = "EVENT_CONNECT_SUCCESS";
		///选择相应解析方法事件(socket接收到数据时的事件)
		public static const EVENT_CHOOSE_PARSE_CMD:String = "EVENT_CHOOSE_PARSE_CMD";
		
		public function SocketManager(argu:SingletonForServerProxy) 
		{
			_socket = new Socket();
		}
		
		public static function getIns():SocketManager
		{
			if (SP == null)
			{
				SP = new SocketManager(new SingletonForServerProxy());
			}
			return SP;
		}
		
		
		//====================================================================================Public
		///连接服务器
		public function startConnect():void
		{
			_socket.addEventListener(Event.CONNECT, onSocketConnected_handle);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData_handle);
			_socket.addEventListener(Event.CLOSE, onSocketClosed_handle);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError_handle);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError_handle);
			//Security.loadPolicyFile("xmlsocket://192.168.0.222/crossdomain.xml:80");
			_socket.connect("127.0.0.1",4700);
			trace("connecting...");
		}
		
		///返回socket对象
		public function getSocket():Socket
		{
			return _socket as Socket;
		}
		
		///返回当前命令的命令码
		public function getCMD_ID():String
		{
			return _cmdID as String;
		}
		
		///返回当前需要解析包的数据（去掉长度和命令码后的部分）
		public function getCMD_DATA():ByteArray
		{
			return _cmdData as ByteArray;
		}
		//======================================================================================Handle
		//连接服务器成功时处理
		private function onSocketConnected_handle(evt:Event):void
		{
			trace("connect success!!!!!!!!!!!!!!!!!");
			
			//dispatchEvent=================================
			dispatchEvent(new Event(EVENT_CONNECT_SUCCESS));
		}
		
		//socket接收到数据时处理
		private function onSocketData_handle(evt:ProgressEvent):void
		{
			if ((evt.target as Socket).bytesAvailable)
			{
				trace("_socket.bytesAvailable: ",_socket.bytesAvailable);
				var byteData:ByteArray = new ByteArray();
				var len:uint = _socket.readShort();
				trace("解析包长：",len);
				_socket.readBytes(byteData,0,len);				
				byteData.position = 0;
				
				var cmdNum:int = byteData.readShort();
				
				trace("\n", "======================", "\n", "即将要解包命令码: ", cmdNum, "--SocketManager.as--");
				trace("\n", "======================", "\n", "包内容（除去长度和命令码）："); 
				
				for (var i:int = 0; i < byteData.length; i++)
				{
					trace(byteData[i], " ");
					
				}
				trace("\n", "======================", "\n");
				
				//派发根据命令码执行相应命令的事件
				//dispatchEvent===================================================================================
				//dispatchEvent(new ServerEvent(ServerEvent.CHOOSE_PARSE_CMD_BY_TYPEID, cmdNum.toString(), byteData));				
			}
		}
		
		//服务器关闭或断开socket连接时处理
		private function onSocketClosed_handle(evt:Event):void
		{
			trace("Socket Be Closeed !!!!!.......!!!!!");
			
		}
		
		//socket输入或输出失败时处理
		private function onSocketIOError_handle(evt:IOErrorEvent):void
		{
			trace("Socket IOError !!!!!.......!!!!!");
			
		}
		
		//socket连接安全错误时处理
		private function onSocketSecurityError_handle(evt:SecurityErrorEvent):void
		{
			trace("Socket SecurityError !!!!!.......!!!!!");
		}
		
		
	}
	
}

class SingletonForServerProxy
{
	
}