package proj.view 
{
	
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.display.DisplayObject;
	import sean.mvc.patterns.Mediator;
	import flash.display.Sprite;
	
	public class MrMainDocManager extends Mediator
	{
		private static var MMDM:MrMainDocManager;

		//容器对象
		
		
		
		public function MrMainDocManager() 
		{
			super();
			if (MMDM!=null)
			{
				throw(new Error("Singleton error !!! MrMainDocManager.as"));
			}
			
			
		}
		
		public static function getIns():MrMainDocManager
		{
			if (MMDM == null)
			{
				MMDM = new MrMainDocManager();
			}
			return MMDM;
		}
		
		public function startUp():void
		{
			initView();
			initControl();
			initData();
		}
		
		override public function register(viewComponent:DisplayObject):void 
		{
			super.register(viewComponent);
		}
		
		//=================================================================================Private
		//初始化视图
		private function initView():void
		{
			
		}

		//初始化控制
		private function initControl():void
		{
			
		}

		//初始化数据
		private function initData():void
		{
			
		}
		
	}

}