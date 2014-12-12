package proj.control 
{
	
	
	/**
	 * ...全局事件转发器
	 * @author Sean Lee
	 */
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class GlobalEventDispatcher extends EventDispatcher
	{
		private static var GED:GlobalEventDispatcher;
		
		
		
		public function GlobalEventDispatcher() 
		{
			if (GED != null)
			{
				throw(new Error("Singleton Error !!! GlobalEventDispatcher.as"));
			}
			
		}
		
		public static function getIns():GlobalEventDispatcher
		{
			if (GED==null)
			{
				GED = new GlobalEventDispatcher();
			}
			return GED;
		}
		
		///转发事件
		public function sendGlobalEvent(e:Event):void
		{
			this.dispatchEvent(e);
		}
		
	}

}