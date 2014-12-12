package
{
	import com.hexagonstar.util.debug.Debug;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
	import flash.text.TextFormat;
	import proj.control.cmd.StartUpCommand;
	import proj.control.GlobalEventDispatcher;
	import proj.model.ConfigModel;
	import proj.model.Model;
	import proj.net.HttpNetManager;
	import sean.lib.TipManager;
	import sean.mvc.events.GlobalEvent;
	import sean.mvc.interfaces.ICommand;
	import sean.flashdll.*;
	
	/**轻量级文档类
	 * ...
	 * @author Sean Lee
	 */
	public class Main extends Sprite 
	{
		//引擎是否启动
		private var engineRunning:Boolean = false;		
		//动态库加载器
		private var _dllLoader:DLLLoader;
		
		//主场景场景容器
		private var _mianSceneContainer:Sprite;
		//主场景工具栏容器
		private var _mainToolContainer:Sprite;
		//弹出框容器
		private var _popupWinContainer:Sprite;		
		//外部数据
		private var _extObj:Object;
		private var _configURL:String = "";
		
		public static var StageWidth:Number;
		public static var StageHeight:Number;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			this.stage.addEventListener(Event.RESIZE, onStageRsize_handle);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			onStageRsize_handle(null);
			
			//启动数据模型
			Model.getIns().startUp();
			
			///文件配置
			_extObj = loaderInfo.parameters;
			if (_extObj["configurl"] != null)
			{
				_configURL = decodeURI(_extObj["configurl"]);
				trace("_configURL:" + _configURL);
				Debug.trace("_configURL:" + _configURL);
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
			
			//初始化视图层
			initView();
			
			//启动单例模块和引擎模块
			var cmd:ICommand = new StartUpCommand();
			cmd.execute(new GlobalEvent("MainDocStartUp", this));
			
		}
		
		///获取主场景场景容器
		public function getMainSceneContainer():Sprite
		{
			return _mianSceneContainer;
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
			_mianSceneContainer = new Sprite();
			_mainToolContainer = new Sprite();			
			_popupWinContainer = new Sprite();
			
			addChild(_mianSceneContainer);
			addChild(_mainToolContainer);
			addChild(_popupWinContainer);
			
		}
		
		//加载UI素材
		private function loadUI():void
		{
			_dllLoader = new DLLLoader();
			var dllLoaderUI:DLLLoaderUI = new DLLLoaderUI(this, _dllLoader, null);
			
			_dllLoader.addEventListener(DLLLoader.ALL_COMPLETED, onStuffsLoadComplete_handle);
			_dllLoader.addDLL(_configURL + "baseUI.swf", "BaseUI");
			_dllLoader.notify();
		}
		
		//设置配置报文		 
		private function setConfig(config:XML):void
		{
			ConfigModel.ConfigData = config;			
		}
		
		//=====================================================================================Handle
		//
		private function onStageRsize_handle(evt:Event):void
		{
			StageWidth = stage.stageWidth;
			StageHeight = stage.stageHeight;
		}
		
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
			
			//加载素材文件
			loadUI();
			
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
			startUp();
		}
		
		
	}
	
}