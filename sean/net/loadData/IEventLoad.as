package sean.net.loadData
{
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class IEventLoad implements IEventDispatcher
	{
		public var _dispatcher:EventDispatcher;

		public function IEventLoad()
		{
			// other ....
			initSender();
		}
		
		private function initSender():void
		{
			_dispatcher=new EventDispatcher(this);
		}
		
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