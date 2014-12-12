package sean.net.loadData
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Sean Lee 2009.12.03
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * JDHCN类包的 载入外部文件 基类
	 * @classname BaseLoad
	 * @methods 
	 * ///////公共属性/////////
	 * contentPath;				//设置/获取外部文件的路径;
	 * 
	 * //////只读属性/////////
	 * bytesLoaded;				//获取已经加载的字节数;
	 * bytesTotal;				//获取内容中的总字节数;
	 * percentLoad;				//获取已加载的百分比;
	 * data;					//获取获取当前加载的对象;
	 * 
	 * ///////公共方法/////////
	 * BaseLoad(fuc:Function);				//构造函数; fun为回调函数;
	 * toString();							//返回当前对象的信息;	 * 
	 * 
	 * ///////公共事件/////////
	 * ProgressEvent.PROGRESS;			//正在加载中;
	 * Event.COMPLETE;					//加载完成;
	 * IOErrorEvent.IO_ERROR;			//加载错误(url错误等);
	 */

	public class LoadBase implements IEventDispatcher
	{
		protected var _dispatcher:EventDispatcher;
		//private var _dispatchEvent:Function;
		protected var _contentPath:String;//加载有URL地址;
		protected var _loadObject:Object;//加载类的实例或对象;
		protected var _className:String;//类名;
		private var _callBackFuc:Function;
		
		//构造函数;
		public function LoadBase(callBackFuc:Function):void
		{
			this._callBackFuc = callBackFuc;
			_dispatcher=new EventDispatcher(this); 
		}
		
		public function toString():String {
			return _className + " -> 加载: " + _contentPath;
		}
		
		///////////////////////   有时需子类重写的方法(eg.FLV)    ///////////////////////
		//得到加载的字节数;
		protected function getBytesLoaded():Number
		{
			return _loadObject.bytesLoaded;
		}
		
		//得到需加载的字节总数;
		protected function getBytesTotal():Number
		{
			return _loadObject.bytesTotal;
		}
		
		///////////////////////   读写属性设置    ///////////////////////
		//指明加载URL;
		public function set contentPath(url:String):void { this._contentPath = url; }		
		public function get contentPath():String { return this._contentPath; }
		
		///////////////////////   只读属性设置    ///////////////////////
		//已经加载的字节数;
		public function get bytesLoaded():Number
		{
			var b:Number = this.getBytesLoaded();
			if(b > 0)
				return b;
			return 0;
		}
		
		//内容中的总字节数;
		public function get bytesTotal():Number
		{
			var b:Number = this.getBytesTotal();
			if(b > 0)
				return b;
			return 0;
		}
		
		//已加载的百分比;
		public function get percentLoad():Number
		{
			var bL:Number = this.bytesLoaded;
			var bT:Number = this.bytesTotal;
			if(bT != 0)
				return Math.floor((bL/bT)*100);
			return 0;
		}
		
		//获取当前对象;
		public function get data():Object
		{
			return _loadObject;
		}
		
		///////////////////////   保护方法    ///////////////////////
		//加载过程时执行;
		protected function progressHandler(evt:Event):void
		{
			//var p:Number = this.percentLoad;
			//trace (this._contentPath+" loading is "+p+"%");
			//dispatchEvent(new Event(ProgressEvent.PROGRESS));
			doDispatchEvent(ProgressEvent.PROGRESS);
		}
		
		//加载成功执行;
		protected function completeHandler(evt:Event):void
		{
			//trace (this._contentPath+"is loaded success");
			doDispatchEvent(Event.COMPLETE);
		}
		
		//加载错误后执行;
		protected function ioErrorHandler(evt:Event):void
		{
			//trace (this._contentPath+"加载错误");
			doDispatchEvent(IOErrorEvent.IO_ERROR);
		}
		
		//开始加载时执行;
		protected function openHandler(evt:Event):void
		{
			//trace (this._contentPath+"加载错误");
			doDispatchEvent(Event.OPEN);
		}
		
		///////////////////////   私有方法    ///////////////////////
		protected function doDispatchEvent(str:String):void
		{
			if (_callBackFuc != null)
			{
				_dispatcher.addEventListener(str, _callBackFuc);
				_dispatcher.dispatchEvent(new Event(str));
			}
		}
		
		///////////////////////   公共方法    ///////////////////////
		//侦测数据数据加载状态;
		public function load():void
		{
			var request:URLRequest = new URLRequest(this._contentPath);
			_loadObject.load(request);
			_loadObject.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loadObject.addEventListener(Event.COMPLETE, completeHandler);
			_loadObject.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loadObject.addEventListener(Event.OPEN, openHandler);
		}
		
		public function close():void
		{
			try
			{
				_loadObject.close();
			}catch(e){}
		}

		///////////////////////   IEventDispatcher    ///////////////////////
		///////////////侦听函数;
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			//other;
			_dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		///////////////将事件调度到事件流中;
		public function dispatchEvent(evt:Event):Boolean
		{
			//other;
			return _dispatcher.dispatchEvent(evt);
		}
		
		///////////////检查 EventDispatcher 对象是否为特定事件类型注册了任何侦听器;
		public function hasEventListener(type:String):Boolean
		{
			//other;
			return _dispatcher.hasEventListener(type);
		}
		
		///////////////移除侦听器;
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			//other;
			_dispatcher.removeEventListener(type,listener,useCapture);
		}
		
		///////////////检查是否用此 EventDispatcher 对象或其任何始祖为指定事件类型注册了事件侦听器;
		public function willTrigger(type:String):Boolean {
			//other;
			return _dispatcher.willTrigger(type);
		}
		
	}
}