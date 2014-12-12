package proj.view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**场景基类
	 * ...
	 * @author Sean Lee
	 */
	public class BaseScene extends Sprite 
	{
		private var _type:String;
		
		public function BaseScene(type:String) 
		{
			_type = type;
			super();
			
			initData();
			initView();
			initControl();
		}
		
		//初始化数据
		protected function initData():void
		{
			
		}
		
		//初始化界面
		protected function initView():void
		{
			
		}
		
		//初始化侦听控制
		protected function initControl():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		//获取场景类型名
		public function get Type():String
		{
			return _type;
		}
		
		//场景添加到舞台上时处理
		protected function onAddToStage(evt:Event):void
		{
			
		}
		
		//场景从舞台上移除时处理
		protected function onRemoveFromStage(evt:Event):void
		{
			
		}
		
	}

}