package proj.control 
{
	
	
	/**
	 * ...控制层类
	 * @author Sean Lee
	 */
	
	import flash.events.EventDispatcher;
	
	public class Controller extends EventDispatcher
	{
		private static var C:Controller;
		
		public function Controller() 
		{
			if (C != null)
			{
				throw(new Error("Singleton Error !!! Controller.as"));
			}
		}
		
		public static function getIns():Controller
		{
			if (C==null)
			{
				C = new Controller();
			}
			return C;
		}
		
		///启动
		public function stratUp():void
		{
			
		}
		
		
	}

}