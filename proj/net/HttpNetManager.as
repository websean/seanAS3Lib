package proj.net 
{
	import com.hexagonstar.util.debug.Debug;
	import flash.events.TimerEvent;
	import flash.utils.Timer;	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import proj.control.cmd.ParseHttpDataCommand;
	import proj.control.GlobalEventDispatcher;
	import proj.model.Model;
	import sean.mvc.events.GlobalEvent;
	
	/**Http请求的通信管理类（单例）
	 * ...
	 * @author Sean Lee
	 */
	public class HttpNetManager extends EventDispatcher
	{
		
		private static var HNM:HttpNetManager;
		public static var Local:Boolean = false;
		
		private var _urlLoader:URLLoader;
		
		private var requests:Array; //请求列表
		private var isRequesting:Boolean = false ;   //是否请求中
		
		//请求队列允许最大长度
		private const ReqArrMaxLenght:int = 5;
		//间隔器间隔时间（毫秒）
		private const ReqSendTimeMax:Number = 200;
		//命令发送间隔器
		private var _ReqSendTimer:Timer;
		//连接是否超时时间最大值（毫秒）
		private const ReqResultTimeMax:Number = 10000;
		//命令结果等待器（用与检查连接是否超时）
		private var _ReqResultTimer:Timer;
		//解析请求过来的数据
		private var parseHttpDataCommand:ParseHttpDataCommand ;
		
		//事件
		//http数据返回
		public static const EVENT_HTTP_ON_DATA:String = "EVENT_HTTP_ON_DATA";
		
		public function HttpNetManager() 
		{
			if (HNM != null)
			{
				throw(new Error("Singleton Error !!! NetManager.as"));
			}
		}	
		
		public static function getIns():HttpNetManager
		{
			if (HNM == null)
			{
				HNM = new HttpNetManager();
			}
			return HNM;
		}
		
		///返回一个URLVariables(getURLVariables(1,2,["id",202],["name","baby"]);
		public static function getURLVariables(mod:int , act:int , ...arg):URLVariables
		{
			var v:URLVariables = new URLVariables();
			v.mod = mod;
			v.act = act;
			/*v.uid = Model.getIns().Uid;
			v.brandhallid = Model.getIns().BrandHallID;
			v.reqTime = Model.getIns().ReqTime;
			v.t = Model.getIns().ReqTime;
			v.sid = Model.getIns().SessionID;
			v.uid = Model.getIns().Uid;
			v.pid = Model.getIns().Pid;
			v.mid = Model.getIns().Mid;*/
			
			for (var i:int = 0; i < arg.length; i++)
			{
				if (arg[i] is Array && (arg[i] as Array).length == 2)
				{
					v[String(arg[i][0])] = arg[i][1];
					
				}
				else
				{
					continue;
				}
			}
			return v;
		}
		
		public function startUp():void
		{
			//初始化通信对象和设置通信参数
			initNet();
		}
		
		public function addRequest(urlVar:URLVariables):void
		{
			trace("添加请求参数：" + urlVar) ;
			if (!urlVar)
			{
				return;
			}
			
			requests.push(urlVar);
			
			if(!isRequesting)
			{
				sendRequest();
				isRequesting = true ;
			}
		}
		
		//发送请求
		private function sendRequest():void
		{
			
			var urlReq:URLRequest = new URLRequest(Model.ServerUrl);
			urlReq.method = URLRequestMethod.POST;
			urlReq.data = requests.pop();
			
			Debug.trace("请求地址：");
			Debug.trace(Model.ServerUrl);
            trace("发送请求参数：" + urlReq.data);
			trace("请求地址：", Model.ServerUrl);
			Debug.trace("请求参数：");
			Debug.traceObj(urlReq.data);
			
			///判断如果是切换场景请求，则发事件
			var mod:int = urlReq.data["mod"];
			var act:int = urlReq.data["act"];			
			if (mod==10 && act ==2)
			{
				//trace("切换不同主人场景请求！！！");
				//GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(EventConfig.REQUEST_SWITCH_SCENE));
			}
			if (Local) 
			{
			//***×××××××××××××××××××××××××××××××××××测试用×××××××××××××××××××××××××××××××××××××××××××*
			var v:URLVariables = urlReq.data as URLVariables;
			var loadurl:String = "data/" + String(int(v.mod) * 1000 + int(v.act)) + ".xml" ;
			var urlReq_t:URLRequest = new URLRequest(loadurl);			
			trace("单机请求地址：", loadurl);
			_urlLoader.load(urlReq_t);
			//***×××××××××××××××××××××××××××××××××××测试用×××××××××××××××××××××××××××××××××××××××××××*
			}
			else
			{
				_urlLoader.load(urlReq);
			}			
			
			//
			_ReqResultTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onConnectResultTimerComplete_handle);
			_ReqResultTimer.start();
		}
		
		private function initNet():void
		{
			_ReqSendTimer = new Timer(ReqSendTimeMax, 1);
			_ReqResultTimer = new Timer(ReqResultTimeMax, 1);
			requests = new Array();
			
			BuildURLLoader();
			
			parseHttpDataCommand = new ParseHttpDataCommand();
		}
		
		//
		private function BuildURLLoader():void
		{
			//
			if (_urlLoader)
			{
				_urlLoader.removeEventListener(Event.COMPLETE, onNetComplete_handle);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onNetIOError_handle);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetSecurityError_handle);
				_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onNetHTTPStatus_handle);
				_urlLoader = null;
			}			
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onNetComplete_handle);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onNetIOError_handle);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetSecurityError_handle);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onNetHTTPStatus_handle);			
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			//
		}
		
		//============================================================================================Handle
		//命令发送间隔器完成记时时处理
		private function onTimerCountComplete_handle(evt:TimerEvent):void
		{
			_ReqSendTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCountComplete_handle);
			_ReqSendTimer.stop();
			//
			if(requests.length > ReqArrMaxLenght)
			{
				requests.splice(ReqArrMaxLenght);
			}
			sendRequest();
		}
		
		//连接超时
		private function onConnectResultTimerComplete_handle(evt:TimerEvent):void
		{
			//			
			_ReqResultTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onConnectResultTimerComplete_handle);
			_ReqResultTimer.reset();
			trace("连接超时!!!!!!!!!!!");
			Debug.trace("连接超时!!!!!!!!!!!");
			while (requests.length > 0)
			{
				requests.pop();
			}
			
			isRequesting = false;
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent("CONNECT_OVER_TIME"));
		}
		
		//联接成功返回数据时处理
		private function onNetComplete_handle(evt:Event):void
		{
			Debug.trace("返回的报文：===========================================↓\n");
			Debug.trace(_urlLoader.data);
			Debug.trace("\n=========================================================↑");
			trace("返回的报文：=================================================\n" );
			trace(_urlLoader.data);
			trace("\n================================================");
			
			//			
			_ReqResultTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onConnectResultTimerComplete_handle);
			_ReqResultTimer.reset();
			
			try
			{
				var strData:XML = XML(_urlLoader.data);
				//解析数据事件
				parseHttpDataCommand.execute(new GlobalEvent("EVENT_HTTP_ON_DATA", strData)) ;
				this.dispatchEvent(new GlobalEvent("EVENT_HTTP_ON_DATA", strData));
			}
			catch (e:Error)
			{
				throw e;	
			}
			finally
			{
				if(requests.length > 0)
				{
					_ReqSendTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCountComplete_handle);
					_ReqSendTimer.start();
				}
				else
				{
					isRequesting = false ;
				}
			}
			
			
		}
		
		//连接IO错误时处理
		private function onNetIOError_handle(evt:IOErrorEvent):void
		{
			trace("NetManager IOError: ", evt.text);
			Debug.trace("NetManager IOError: " + evt.text);
			isRequesting = false;
		}
		
		//连接安全错误时处理
		private function onNetSecurityError_handle(evt:SecurityErrorEvent):void
		{
			trace("NetManager SecurityError: ", evt.text);
			Debug.trace("NetManager SecurityError: " + evt.text);
			isRequesting = false;
		}
		
		//连接状态信息时处理
		private function onNetHTTPStatus_handle(evt:HTTPStatusEvent):void
		{
			trace("NetManager HTTPStatus: ", evt.status);
			Debug.trace("NetManager HTTPStatus:" + evt.status);
		}
		
	}

}