package  
{
	
	/**主文档类
	 * ...
	 * @author Sean Lee
	 */
	
	import com.hexagonstar.util.debug.Debug;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import proj.model.ConfigModel;
	import proj.model.Model;
	import proj.net.HttpNetManager;
	import sean.lib.TipManager;
	import sean.mvc.events.GlobalEvent
	import sean.mvc.interfaces.ICodeObject;
	import sean.mvc.interfaces.ICommand;
	import proj.control.cmd.StartUpCommand;
	import sean.utils.DrawClip;
	import sean.utils.DrawStyle;
	import sean.utils.SeanUtils;
	import sean.flashdll.*;
	
	public class DemoMainDoc extends Sprite
	{
		//引擎是否启动
		private var engineRunning:Boolean = false;		
		//动态库加载器
		private var _dllLoader:DLLLoader;
		//外部数据
		private var _extObj:Object;
		
		private var _sessionID:int ;    ///从平台获得
		private var _pid:int ;          ///从平台获得		
		private var _configXML:XML      ///配置报文
		private var urlLoader:URLLoader;
		
		public function DemoMainDoc() 
		{
			//启动数据模型
			Model.getIns().startUp();
			
			///文件配置
			_extObj = loaderInfo.parameters;
			if (!_extObj["sessionID"])
			{
				if (SeanUtils.Debug)
				{
					_extObj["sessionID"] = 10;
					_extObj["pid"] = 10;
				}
				else
				{
					//throw(new Error("无数据sessionID，程序中断！！！请重新操作或刷新页面"));
				}
				
			}
			//Model.getIns().SessionID = int(_extObj["sessionID"]) ;
			//Model.getIns().Pid = int(_extObj["pid"]) ;
			
			///加载素材地址
			if (_extObj["loaderUrl"])
			{
				Debug.trace(String(_extObj["loaderUrl"]) + "=================================") ;
				Model.LoaderUrl = String(_extObj["loaderUrl"]) ;
			}
			else
			{
				Model.LoaderUrl = "http://192.168.0.16/bar/"  ;     
			}
			///访问服务器地址
			if (_extObj["serverUrl"])
			{
				Model.ServerUrl = String(_extObj["serverUrl"]) ;
			}
			else
			{
				Model.ServerUrl = "http://192.168.0.16/api.php"  ;     
			}			
			
			urlLoader = new URLLoader() ;			
			urlLoader.addEventListener(Event.COMPLETE, onNetComplete_handle);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onNetError_handle);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetError_handle);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onNetError_handle);
			//允许跨域访问
			Security.allowDomain("*"); 
			//手动加载策略文件
			Security.loadPolicyFile("http://192.168.0.17/yghome/image/avatar/crossdomain.xml"); 	
			
			//连接获取配置文件
			loadConfig() ;
			
		}
		
		///启动
		public function startUp(obj:Object=null):void
		{
			if (!engineRunning)
			{
				engineRunning = true;
			}else 
			{
				return;
			}
			_extObj = obj;
			
			_dllLoader = new DLLLoader();
			var dllLoaderUI:DLLLoaderUI = new DLLLoaderUI(this, _dllLoader, null);
			
			_dllLoader.addEventListener(DLLLoader.ALL_COMPLETED, onStuffsLoadComplete_handle);
			_dllLoader.addDLL("barStuff.swf", "mainStuff");
			
			_dllLoader.notify();		
			
		}
		
		//=====================================================================================Private
		///初始化视图层
		private function initView():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, onthisRollover_handle);
			
		}
		
		//
		private function onthisRollover_handle(evt:MouseEvent):void
		{
			TipManager.getIns().showTip_JustText(this, ["@!#!@#!@$#@%#$^#^", "@#$F$G$%^"], this.stage, false);
		}
		
		//获取配置报文	
		private function loadConfig():void
		{
			var urlReq:URLRequest = new URLRequest(Model.ServerUrl);
			urlReq.method = URLRequestMethod.POST;
			urlReq.data = HttpNetManager.getURLVariables(10, 1);
			urlLoader.load(urlReq) ;
		}
		
		//设置配置报文		 
		private function setConfig(config:XML):void
		{
			ConfigModel.ConfigData = config;			
		}		
		
		//=====================================================================================Handle
		//素材元素全部加载完毕时处理
		private function onStuffsLoadComplete_handle(evt:Event):void
		{
			//初始化视图层
			initView();			
			
			//启动单例模块和引擎模块
			var cmd:ICommand = new StartUpCommand();
			cmd.execute(new GlobalEvent("MainDocStartUp", this));		
			
			//for test
			/*if(YgUtils.Debug)
			{
				var tp:TestPanel = new TestPanel();
				tp.x = 10;
				stage.addChild(tp);
			}*/
			
		}
		
		//完成并收到返回数据时处理
		private function onNetComplete_handle(evt:Event):void
		{
			
			urlLoader.removeEventListener(Event.COMPLETE, onNetComplete_handle);
			var strData:XML = XML(urlLoader.data); 
			setConfig(strData) ;
			
			trace("获取到的配置文件:" + strData);
			
			///启动程序
			startUp();
		}
		
		//连接错误时处理
		private function onNetError_handle(evt:Event):void
		{
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onNetError_handle);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetError_handle);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onNetError_handle);
			trace("Net Error: ",evt.type);
		}
		
	}

}