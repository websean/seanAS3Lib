package  
{
	
	/**文档类
	 * ...
	 * @author Sean Lee
	 */
	
	import com.hexagonstar.util.debug.Debug;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
	import proj.control.cmd.*;
	import proj.control.*;
	import proj.model.*;
	import proj.net.*;
	import sean.lib.*;
	import sean.mvc.events.GlobalEvent;
	import sean.mvc.interfaces.ICommand;
	import sean.utils.*;
	import sean.flashdll.*;
	import sean.components.*;
	
	public class Main extends Sprite
	{
		//引擎是否启动
		private var engineRunning:Boolean = false;		
		//动态库加载器
		private var _dllLoader:DLLLoader;
		//外部数据
		private var _extObj:Object;
		
		private var _urlLoader:URLLoader;
		
		//初始化的前提（主配置文件和素材，默认都是false）
		private var WebConfigReady:Boolean = false;
		private var StuffReady:Boolean = false;
		
		//主场景场景容器
		private var _mainSceneContainer:Sprite;
		//主场景工具栏容器
		private var _mainToolContainer:Sprite;
		//弹出框容器
		private var _popupWinContainer:Sprite;
		
		private var _configURL:String = "";
		
		public static var StageWidth:Number;
		public static var StageHeight:Number;
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			StageWidth = stage.stageWidth;
			StageHeight = stage.stageHeight;
			
			//启动数据模型
			Model.getIns().startUp();
			
			///文件配置
			_extObj = loaderInfo.parameters;
			
			if (_extObj["configurl"])
			{
				_configURL = _extObj["configurl"];
			}
			
			///加载素材地址
			if (_extObj["loaderUrl"])
			{
				Debug.trace(String(_extObj["loaderUrl"]) + "=================================") ;
				Model.LoaderUrl = String(_extObj["loaderUrl"]) ;
			}
			else
			{
				//Model.LoaderUrl = "http://192.168.0.16/bar/"  ;     
			}
			///访问服务器地址
			if (_extObj["serverUrl"])
			{
				Model.ServerUrl = String(_extObj["serverUrl"]) ;
			}
			else
			{
				//Model.ServerUrl = "http://192.168.0.16/api.php"  ;     
			}	
			
			var cfg_l:URLLoader = new URLLoader();
			cfg_l.addEventListener(Event.COMPLETE, onCfgComplete_handle);
			cfg_l.addEventListener(IOErrorEvent.IO_ERROR, onCfgError_handle);
			cfg_l.load(new URLRequest(_configURL + "Config.xml"));
			
			
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
			_dllLoader.addDLL(_configURL + "baseUI.swf", "BaseUI");
			_dllLoader.notify();		
			
		}
		
		///获取主场景场景容器
		public function getMainSceneContainer():Sprite
		{
			return _mainSceneContainer;
		}
		
		///获取主场景工具栏容器
		public function getMainToolContainer():Sprite
		{
			return _mainToolContainer;
		}
		
		///获取弹出框容器
		public function getPopupWinContainer():Sprite
		{
			return _popupWinContainer;
		}
		
		//=====================================================================================Private
		///初始化视图层
		private function initView():void
		{
			_mainSceneContainer = new Sprite();
			_mainToolContainer = new Sprite();			
			_popupWinContainer = new Sprite();
			
			addChild(_mainSceneContainer);
			addChild(_mainToolContainer);
			addChild(_popupWinContainer);			
		}
		
		//获取配置报文	
		private function loadConfig():void
		{
			var urlReq:URLRequest = new URLRequest(Model.ServerUrl);
			urlReq.method = URLRequestMethod.POST;
			urlReq.data = HttpNetManager.getURLVariables(1, 1);
			_urlLoader.load(urlReq) ;
		}
		
		//设置配置报文		 
		private function setConfig(config:XML):void
		{
			ConfigModel.ConfigData = config;			
		}
		
		//初始化程序（视图层、数据模型、控制层等）
		private function init():void
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
		
		//=====================================================================================Handle
		//加载外部配置文件成功时处理
		private function onCfgComplete_handle(evt:Event):void
		{
			Debug.trace(XML((evt.target as URLLoader).data).toXMLString());
			Model.LoaderUrl = String(XML((evt.target as URLLoader).data).loaderUrl);
			
			Model.ServerUrl = String(XML((evt.target as URLLoader).data).serverUrl);
			
			var loadPolicyFileURL:String = String(XML((evt.target as URLLoader).data).loadPolicyFile);
			
			var serverPolicyFileURL:String = String(XML((evt.target as URLLoader).data).serverPolicyFile);
			
			for each(var item:XML in XML((evt.target as URLLoader).data).otherPolicyFile.children())
			{
				Debug.trace("otherPolicyFile: ");
				Debug.trace(item.children().toString());
				Security.loadPolicyFile(item.children().toString()); 
			}
			
			if (Model.LoaderUrl && Model.ServerUrl)
			{
				
			}
			else
			{
				throw(new Error("外部xml配置文件里必备内容不全！Error！！！"));
			}
			
			_urlLoader = new URLLoader() ;			
			_urlLoader.addEventListener(Event.COMPLETE, onNetComplete_handle);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onNetError_handle);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetError_handle);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus_handle);
			//允许跨域访问
			Security.allowDomain("*"); 
			//手动加载策略文件
			//Security.loadPolicyFile(loadPolicyFileURL); 	
			//Security.loadPolicyFile(serverPolicyFileURL); 
			
			//启动
			startUp();
			//连接获取配置文件
			//loadConfig() ;
			
			(evt.target as URLLoader).removeEventListener(Event.COMPLETE, onCfgComplete_handle);
			(evt.target as URLLoader).removeEventListener(IOErrorEvent.IO_ERROR, onCfgError_handle);
			
			
		}
		
		//加载外部配置文件失败时处理
		private function onCfgError_handle(evt:Event):void
		{
			throw(new Error("找不到外部xml配置文件！Error！！！"));
		}
		
		//素材元素全部加载完毕时处理
		private function onStuffsLoadComplete_handle(evt:Event):void
		{
			StuffReady = true;
			
			if (StuffReady && WebConfigReady)
			{
				init();
			}
			
		}
		
		//完成并收到返回数据时处理
		private function onNetComplete_handle(evt:Event):void
		{
			WebConfigReady = true;
			
			_urlLoader.removeEventListener(Event.COMPLETE, onNetComplete_handle);
			var strData:XML = XML(_urlLoader.data); 
			setConfig(strData) ;
			
			Debug.trace("获取到的配置文件: ");
			Debug.trace(strData);
			trace("获取到的配置文件: \n" + strData);
			
			if (StuffReady && WebConfigReady)
			{
				init();
			}
		}
		
		//连接错误时处理
		private function onNetError_handle(evt:Event):void
		{
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onNetError_handle);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetError_handle);
			
			trace("Net Error: ",evt.type);
		}
		
		//返回HTTP状态
		private function onHttpStatus_handle(evt:HTTPStatusEvent):void
		{
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus_handle);
			trace("HttpStatus: ",evt.status);
		}
		
	}

}