package sean.net
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname SubDataSingle
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * getInstance():SubDataSingle				//单例类实例化方法;
	 * setParam(serverUrl:String, val:URLVariables, evtFun:Function=null):void			//根据参数值提交数据(serverUrl为请求服务的url地址, val为请求服务的变量参数，evtFun为获取返回值的回调函数<为果为空表示忽略返回值>);
	 * setParamFile(serverUrl:String, val:URLVariables, fileRef:FileReference, evtFun:Function = null):void		//同上，有文件同时上传;	
	 * setParamBitmap(urlStr:String, varsStr:String, bmap:BitmapData, evtFun:Function = null):void				//同上，有BitmapData数据同时上传;
	 * getData():URLVariables				//获取提交后的返回值(普通的字符串数据);
	 * getVarsData():URLVariables			//获取提交后的返回值(URLVariables格式的数据);
	 * getJsonData():*						//获取提交后的返回值(Json格式的数据);
	 * 
	 * ////////公共事件/////////////
	 * Event.COMPLETE						//参考flash.events.Event.COMPLETE;
	 * 
	 * eg.
		var urlStr:String = "http://127.0.0.1/index.aspx";
		sub_btn.addEventListener(MouseEvent.CLICK, onClick);
		var fileRef:FileReference;
		var s:SubmitDataFile = new SubmitDataFile();
		var val:URLVariables = new URLVariables();
		val.t = "unregsign";
		val.user = "lzdk2003";
		val.pwd = "111111";
		//trace(val);
		onBrowseHandler();

		function onClick(e:MouseEvent):void{
			SubDataSingle.getInstance().setParamFile(urlStr, val, fileRef, onComplete);
		}

		function onComplete():void{
			trace(SubDataSingle.getInstance().getJsonData().Status);
		}

		function onBrowseHandler():void {
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onSelectFileHandler, false,0, true);
			try {
				fileRef.browse([new FileFilter("Images", "*.png;*.gif;*.jpg;*.bmp")]);
			} catch (e:Error) {
				trace("browse failed");
			}
		}
		function onSelectFileHandler(e:Event):void {
			trace("fileName=", FileReference(e.target).name);
		}
	 */
	public class SubDataSingle extends EventDispatcher
	{
		private static  var _instance:SubDataSingle;
		private var submitData:*;
		private var _fun:Function;
		private var _obj:SubmitData;
		
		public function SubDataSingle(oneClass:OneClass):void
		{
			super();
			if (oneClass == null)
			{
				throw new Error("此类为单例类,请使用getInstance()获取实例");
			}
		}
		
		public static function getInstance():SubDataSingle
		{
			if (_instance == null)
			{
				_instance = new SubDataSingle(new OneClass());
			}
			return _instance;
		}
		
		public function setParam(serverUrl:String, val:URLVariables, evtFun:Function = null):void
		{
			submitData = new SubmitData();
			submitData.send(serverUrl,val);
			submitData.addEventListener(BaseSubmitData.SUBMIT_SUCCESS, onComplete);
			_fun = evtFun;
		}
		
		public function setParamFile(serverUrl:String, val:URLVariables, fileRef:FileReference, evtFun:Function = null):void
		{
			submitData = new SubmitDataFile() as SubmitDataFile;
			submitData.fileRef = fileRef;
			submitData.send(serverUrl,val);
			submitData.addEventListener(BaseSubmitData.SUBMIT_SUCCESS, onComplete);
			_fun = evtFun;
		}
		
		public function setParamBitmap(urlStr:String, varsStr:String, bmap:BitmapData, evtFun:Function = null):void
		{
			submitData = new SubmitBitmap();
			submitData.sendBitmap(urlStr, varsStr, bmap);
			submitData.addEventListener(BaseSubmitData.SUBMIT_SUCCESS, onComplete);
			_fun = evtFun;
		}
		
		private function onComplete(e:Event):void
		{
			submitData.removeEventListener(BaseSubmitData.SUBMIT_SUCCESS, onComplete);
			if (_fun != null)
			{
				_fun();
			}
			dispatchEvent(e);
		}
		
		public function getData():String
		{
			return submitData.getData();
		}
		public function getVarsData():URLVariables
		{
			return submitData.getVarsData();
		}
		public function getJsonData():* {
			return submitData.getJsonData();
		}
	}
}

class OneClass{}