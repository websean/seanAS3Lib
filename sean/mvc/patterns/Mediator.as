package sean.mvc.patterns
{
	/**
	 * ...显示对象管理器类基类（一对一管理，可切换）
	 * @author Sean Lee
	 */
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class Mediator extends EventDispatcher
	{
		public static const NAME:String = 'Mediator';
		
		//自身的key
		protected var mediatorName:String;

		//管理目标
		protected var viewComponent:Object;
		
		
		public function Mediator(mediatorName:String = null, viewComponent:Object = null)
		{
			this.mediatorName = (mediatorName != null)?mediatorName:NAME; 
			this.viewComponent = viewComponent;
		}
		
		///注册管理目标
		public function register(viewComponent:DisplayObject):void 
		{
			this.viewComponent = viewComponent;
			
			onRegister();
		}
		
		///获取自身的key名
		public function getMediatorName():String 
		{	
			return mediatorName;
		}
		
		///获取管理目标
		public function getViewComponent():Object
		{	
			return viewComponent;
		}		
		
		///注册新管理目标时的处理函数
		protected function onRegister():void {}
		
		///清除管理器以及内部所有内容
		public function onRemove():void { }
		
		
	}
}