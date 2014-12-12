package sean.mvc.interfaces
{
	
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.events.Event;
	import sean.mvc.events.GlobalEvent;
	
	public interface ICommand 
	{
		function execute(evt:GlobalEvent=null):void;
		/*function undo():void;*/
	}
	
}