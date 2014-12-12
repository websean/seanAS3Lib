package sean.components.interfaces 
{
	import flash.events.MouseEvent;
	import sean.components.BaseMCButton;
	
	/**
	 * 2012-10-31
	 * @author 蒋坚
	 * 分页组件接口
	 */
	public interface IPagingComponent 
	{
		//下一页
		function nextPage(evt:MouseEvent):void
		//上一页
		function prePage(evt:MouseEvent):void 
		
		//处理上一页 下一页 按钮状态
		function dealBtnState():void ;
		
		//初始化组件
		function initComponent(pageNumValue:int , pBtn:BaseMCButton , nBtn:BaseMCButton):void ;
		
		//销毁自己
		function bombSelf():void
	}
	
}