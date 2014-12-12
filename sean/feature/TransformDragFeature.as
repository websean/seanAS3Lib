package sean.feature 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**显示对象的拖拽缩放变形功能
	 * ...
	 * @author Sean Lee
	 */
	public class TransformDragFeature extends EventDispatcher 
	{
		//操作对象面板
		private var _panel:DisplayObject;
		//可拖拽操作的区域
		private var _dragArea:InteractiveObject;
		
		//鼠标按下时在操作区域上的全局坐标
		private var _downPoint:Point;
		//操作点与注册点之间的距离（x，y）（全局坐标系）
		private var _distancePoint:Point;
		
		private var _dragF:DragFeature;
		
		private var _panelPositionControlDomainOutside:Boolean;
		
		///变形事件
		public static const EVENT_ON_TRANSFORM:String = "TransformDragFeature_EVENT_ON_TRANSFORM";
		///开始变形
		public static const EVENT_START_TRANSFORM:String = "TransformDragFeature_EVENT_START_TRANSFORM";
		///结束变形
		public static const EVENT_STOP_TRANSFORM:String = "TransformDragFeature_EVENT_STOP_TRANSFORM";
		
		public function TransformDragFeature() 
		{
			
			_dragF = new DragFeature();
		}
		
		///设置唯一的控制对象
		public function SetPanel(panel:DisplayObject):void
		{
			_panel = panel;
		}
		
		///添加交互对象
		public function SetDragArea(area:InteractiveObject):void
		{
			_dragArea = area;
			_dragF.SetPanel(_dragArea);
			_dragF.AddDragArea(_dragArea);
		}
		
		///设置拖拽限制区
		public function SetLimitArea(rect:Rectangle):void
		{
			var p:Point = _panel.localToGlobal(new Point(0, 0));
			var distance:Point = new Point(p.x - rect.x, p.y - rect.y);
			
			//_dragF.SetLimitArea(new Rectangle(p.x, p.y, rect.width - distance.x, rect.height - distance.y),true);
			_dragF.SetLimitArea(rect);
		}
		
		///设置唯一的控制对象的位置调整的控制域（内部实现，还是外部实现）
		public function SetPanelPositionControlDomainOutside(outside:Boolean):void
		{
			_panelPositionControlDomainOutside = outside;
		}
		
		///关闭功能（下次控制对象添加到舞台时生效）
		public function CloseFeature():void
		{
			if (_panel == null)
			{
				throw(new Error("无控制对象！！！"));
			}
			_panel.removeEventListener(Event.ADDED_TO_STAGE, onPanelAddToStage_handle);
			_dragF.CloseFeature();
		}
		
		///立即关闭功能（立即生效）
		public function CloseFeatureImmediatelly():void
		{
			if (_panel == null)
			{
				throw(new Error("无控制对象！！！"));
			}
			_dragF.CloseFeatureImmediatelly();
			_panel.removeEventListener(Event.ADDED_TO_STAGE, onPanelAddToStage_handle);
			_panel.removeEventListener(Event.ENTER_FRAME, onPanelEnterFrame_handle);
			_panel.removeEventListener(Event.REMOVED_FROM_STAGE, onPanelRemovedFromStage_handle);
			_dragF.removeEventListener(DragFeature.EVENT_START_DRAG, onStartDarg_handle);
		}
		
		///打开功能
		public function OpenFeature():void
		{
			if (_panel == null)
			{
				throw(new Error("无控制对象！！！"));
			}
			
			_panel.addEventListener(Event.ADDED_TO_STAGE, onPanelAddToStage_handle);
			_dragF.OpenFeature();
			
			if (_panel.stage != null)
			{
				AddDragListener();
			}
		}
		
		///销毁功能
		public function Destroy():void
		{
			CloseFeatureImmediatelly();
			_dragF.Destroy();
			_panel = null;
			_dragArea = null;
		}
		
		//添加拖拽监听
		private function AddDragListener():void
		{
			_dragF.addEventListener(DragFeature.EVENT_START_DRAG, onStartDarg_handle);
			_dragF.addEventListener(DragFeature.EVENT_STOP_DRAG, onStopDarg_handle);
		}
		
		//移除拖拽监听
		private function RemoveDragListener():void
		{
			_panel.removeEventListener(Event.REMOVED_FROM_STAGE, onPanelRemovedFromStage_handle);
			_dragF.removeEventListener(DragFeature.EVENT_START_DRAG, onStartDarg_handle);
		}
		
		//============================================================Handle
		//操作对象面板添加到舞台时处理
		private function onPanelAddToStage_handle(evt:Event):void
		{
			_panel.addEventListener(Event.REMOVED_FROM_STAGE, onPanelRemovedFromStage_handle);
			AddDragListener();
			_dragF.OpenFeature();
		}
		
		//操作对象面板从舞台移除时处理
		private function onPanelRemovedFromStage_handle(evt:Event):void
		{
			RemoveDragListener();
			_dragF.CloseFeature();
		}
		
		//
		private function onStartDarg_handle(evt:Event):void
		{
			_panel.addEventListener(Event.ENTER_FRAME, onPanelEnterFrame_handle);
			this.dispatchEvent(new Event(EVENT_START_TRANSFORM));
		}
		
		//
		private function onStopDarg_handle(evt:Event):void
		{
			_panel.removeEventListener(Event.ENTER_FRAME, onPanelEnterFrame_handle);
			this.dispatchEvent(new Event(EVENT_STOP_TRANSFORM));
		}
		
		//
		private function onPanelEnterFrame_handle(evt:Event):void
		{
			if (_panelPositionControlDomainOutside)
			{
				
			}
			else
			{
				_panel.width = (_dragArea.x + _dragArea.width / 2) - _panel.x;
				_panel.height = (_dragArea.y + _dragArea.height / 2) - _panel.y;
			}
			
			this.dispatchEvent(new Event(EVENT_ON_TRANSFORM));
		}
		
	}

}