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
	import sean.mvc.events.GlobalEvent;
	
	/**面板区域可拖拽功能类（通过拖拽多区域控制移动指定的唯一面板对象）
	 * ...
	 * @author Sean Lee
	 */
	public class DragFeature extends EventDispatcher 
	{
		public static const EVENT_START_DRAG:String = "DragFeature_EVENT_START_DRAG";
		public static const EVENT_STOP_DRAG:String = "DragFeature_EVENT_STOP_DRAG";
		public static const EVENT_PANEL_POSITION_CHANGED:String = "DragFeature_EVENT_PANEL_POSITION_CHANGED";
		
		//操作对象面板
		private var _panel:DisplayObject;
		//可拖拽操作的区域列表（项类型为：InteractiveObject）
		private var _areaList:Array;
		
		//鼠标按下时在操作区域上的全局坐标
		private var _downPoint:Point;
		//操作点与注册点之间的距离（x，y）（全局坐标系）
		private var _distancePoint:Point;
		
		//鼠标区域
		private var _limitArea:Rectangle;
		//目标显示的坐标区域
		private var _croodinateArea:Rectangle;
		//唯一的控制对象的位置调整的控制域
		private var _panelPositionControlDomainOutSide:Boolean;
		
		public function DragFeature() 
		{
			_areaList = new Array();
		}
		
		///设置唯一的控制对象
		public function SetPanel(panel:DisplayObject):void
		{
			_panel = panel;
		}
		
		///添加交互对象
		public function AddDragArea(area:InteractiveObject):void
		{
			_areaList.push(area);
		}
		
		///设置操作限制区（全局坐标系）
		public function SetLimitArea(rect:Rectangle):void
		{
			_limitArea = rect;
		}
		
		//设置目标显示的坐标区域（父级坐标系）
		public function SetCroodinateArea(rect:Rectangle):void
		{
			_croodinateArea = rect;
		}
		
		///设置唯一的控制对象的位置调整的控制域（内部实现，还是外部实现）
		public function SetPanelPositionControlDomain(outSide:Boolean = false):void
		{
			_panelPositionControlDomainOutSide = outSide;
		}
		
		///关闭功能（下次控制对象添加到舞台时生效）
		public function CloseFeature():void
		{
			if (_panel == null)
			{
				throw(new Error("无控制对象！！！"));
			}
			_panel.removeEventListener(Event.ADDED_TO_STAGE, onPanelAddToStage_handle);
		}
		
		///立即关闭功能（立即生效）
		public function CloseFeatureImmediatelly():void
		{
			if (_panel == null)
			{
				throw(new Error("无控制对象！！！"));
			}
			onStageMouseUp_handle(null);			
			removeAreasMouseDownListener();
			_panel.removeEventListener(Event.REMOVED_FROM_STAGE, onPanelRemovedFromStage_handle);
			_panel.removeEventListener(Event.ADDED_TO_STAGE, onPanelAddToStage_handle);
		}
		
		///打开功能
		public function OpenFeature():void
		{
			if (_panel == null)
			{
				throw(new Error("无控制对象！！！"));
			}
			
			_panel.addEventListener(Event.ADDED_TO_STAGE, onPanelAddToStage_handle);
			if (_panel.stage != null)
			{
				addAreasMouseDownListener();
			}
		}
		
		///销毁功能（可复活）
		public function Destroy():void
		{
			CloseFeatureImmediatelly();
			while (_areaList.length > 0)
			{
				_areaList.pop();
			}
			_panel = null;
		}
		
		//给所有交互区域添加鼠标按下事件侦听
		private function addAreasMouseDownListener():void
		{
			for each(var area:InteractiveObject in _areaList)
			{
				area.addEventListener(MouseEvent.MOUSE_DOWN, onAreaMouseDown_handle);
			}
		}
		
		//移除所有交互区域鼠标按下事件侦听
		private function removeAreasMouseDownListener():void
		{
			for each(var area:InteractiveObject in _areaList)
			{
				area.removeEventListener(MouseEvent.MOUSE_DOWN, onAreaMouseDown_handle);
			}
		}
		
		//============================================================Handle
		//操作对象面板添加到舞台时处理
		private function onPanelAddToStage_handle(evt:Event):void
		{
			_panel.addEventListener(Event.REMOVED_FROM_STAGE, onPanelRemovedFromStage_handle);
			addAreasMouseDownListener();
			
		}
		
		//操作对象面板从舞台移除时处理
		private function onPanelRemovedFromStage_handle(evt:Event):void
		{
			_panel.removeEventListener(Event.REMOVED_FROM_STAGE, onPanelRemovedFromStage_handle);
			removeAreasMouseDownListener();
		}
		
		//交互区域鼠标按下时处理
		private function onAreaMouseDown_handle(evt:MouseEvent):void
		{
			var area:InteractiveObject = evt.currentTarget as InteractiveObject;
			_downPoint = new Point(evt.stageX, evt.stageY);			
			try
			{
				_panel.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				_panel.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
				_panel.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave_handle);
			}
			catch (e:Error)
			{
				trace(e);
			}
			
			var p:Point = _panel.parent.globalToLocal(_downPoint);
			_distancePoint = new Point(p.x - _panel.x, p.y - _panel.y);
			
			this.dispatchEvent(new Event(EVENT_START_DRAG));
		}
		
		//鼠标在舞台上移动时处理
		private function onStageMouseMove_handle(evt:MouseEvent):void
		{
			var p:Point = _panel.parent.globalToLocal(new Point(evt.stageX, evt.stageY));
			
			if (_limitArea != null)
			{
				if (evt.stageX > (_limitArea.x + _limitArea.width) || evt.stageX < _limitArea.x
				|| evt.stageY > (_limitArea.y + _limitArea.height) || evt.stageY<_limitArea.y)
				{
					onStageMouseUp_handle(null);
					return;
				}
			}
			
			
			if (_panelPositionControlDomainOutSide)
			{
				var posiotion:Point = new Point();
				posiotion.x = p.x - _distancePoint.x;
				posiotion.y = p.y - _distancePoint.y;
				this.dispatchEvent(new GlobalEvent(EVENT_PANEL_POSITION_CHANGED, posiotion));
			}
			else
			{
				_panel.x = p.x - _distancePoint.x;
				_panel.y = p.y - _distancePoint.y;
				
				if (_croodinateArea != null)
				{
					if (_panel.x < _croodinateArea.x)
					{
						_panel.x = _croodinateArea.x;
					}
					else if (_panel.x > _croodinateArea.x + _croodinateArea.width)
					{
						_panel.x = _croodinateArea.x + _croodinateArea.width;
					}
					
					if (_panel.y < _croodinateArea.y)
					{
						_panel.y = _croodinateArea.y;
					}
					else if (_panel.y > _croodinateArea.y + _croodinateArea.height)
					{
						_panel.y = _croodinateArea.y + _croodinateArea.height;
					}
				}
				this.dispatchEvent(new GlobalEvent(EVENT_PANEL_POSITION_CHANGED, new Point(_panel.x, _panel.y)));
			}			
			
			evt.updateAfterEvent();
		}
		
		//鼠标在舞台上弹起时处理
		private function onStageMouseUp_handle(evt:MouseEvent):void
		{
			if (_panel.stage == null) return;
			
			try
			{
				_panel.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				_panel.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
				_panel.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave_handle);
			}			
			catch (e:Error)
			{
				trace("DragFeature.as："+e);
			}
			this.dispatchEvent(new Event(EVENT_STOP_DRAG));
		}
		
		//鼠标移出舞台时处理
		private function onStageMouseLeave_handle(evt:Event):void
		{
			onStageMouseUp_handle(null);
		}
		
		
	}

}