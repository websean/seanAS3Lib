package sean.net.loadData
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Sean Lee 2009.12.03
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname MyNetStream 
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class MyNetStream extends EventDispatcher
	{
		private var _stream:NetStream;
		private var _loadingTimer:Timer;
		private var _percent:Number;
		
		public static const DEFAULT_LOADING_PROGRESS:Number = 250;
		
		public function MyNetStream(connection:NetConnection):void
		{
			_loadingTimer = new Timer(DEFAULT_LOADING_PROGRESS);
			_loadingTimer.addEventListener(TimerEvent.TIMER, onLoadingHandler);
			_loadingTimer.start();
			
			_stream = new NetStream(connection);
		}
		
		public function hiddenLoading():void
		{
			_loadingTimer.stop();
		}
		
		private function onLoadingHandler(e:TimerEvent):void
		{
			_percent = (((_stream.bytesLoaded / _stream.bytesTotal) * 10000) >> 0) / 100;
			if (_percent <= 0) return;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
			if (_percent >= 100)
			{
				_loadingTimer.stop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/////set/get/////
		public function get stream():NetStream { return _stream; }
		public function get percent():Number { return _percent; }
		public function get bytesTotal():Number { return _stream.bytesTotal; }
		public function get bytesLoaded():Number { return _stream.bytesLoaded; }
		
		
		
	}
	
}