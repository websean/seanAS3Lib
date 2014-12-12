package sean.mvc.events 
{
	
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.events.Event;
	
	public class GlobalEvent extends Event 
	{
		private var _data:*;		
		
		public function GlobalEvent(type:String, eventData:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_data = eventData;
		} 
		
		public override function clone():Event 
		{ 
			return new GlobalEvent(type, _data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GlobalEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get Data():*
		{
			return _data;
		}
		
	}
	
}