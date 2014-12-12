package sean.feature 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import sean.mvc.events.GlobalEvent;
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class RotateFeature extends EventDispatcher 
	{
		//操作对象面板
		private var _panel:DisplayObject;
		
		//操作区域
		private var _controlArea:InteractiveObject;
		//
		private var _mouseIcon:DisplayObjectContainer;
		//唯一的控制对象的角度调整的控制域
		private var _panelPositionControlDomainOutSide:Boolean;
		//初始角度误差
		private var _distanceAngle:int;
		
		public static const EVENT_START_ROTATE:String = "RotateFeature_EVENT_START_ROTATE";
		public static const EVENT_STOP_ROTATE:String = "RotateFeature_EVENT_STOP_DRAG";
		public static const EVENT_PANEL_ROTATION_CHANGED:String = "RotateFeature_EVENT_PANEL_ROTATION_CHANGED";
		
		public function RotateFeature() 
		{
			
			
		}
		
		///设置唯一的控制对象
		public function SetPanel(panel:DisplayObject):void
		{
			_panel = panel;
		}
		
		///设置唯一的操作区域
		public function SetControlArea(area:InteractiveObject):void
		{
			_controlArea = area;
		}
		
		///设置鼠标跟随的图标样式
		public function SetMouseIcon(icon:DisplayObjectContainer):void
		{
			_mouseIcon = icon;
			_mouseIcon.mouseEnabled = false;
			_mouseIcon.mouseChildren = false;
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
			removeAreaRollOverListener();
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
				addAreaRollOverListener();
			}
		}
		
		///销毁功能（可复活）
		public function Destroy():void
		{
			CloseFeatureImmediatelly();
			_panel = null;
			_controlArea = null;
			_mouseIcon = null;
			_distanceAngle = 0;
		}
		
		//添加鼠标经过侦听
		private function addAreaRollOverListener():void
		{
			_controlArea.addEventListener(MouseEvent.ROLL_OVER, onAreaRollOver_handle);
			_controlArea.addEventListener(MouseEvent.ROLL_OUT, onAreaRollOut_handle);
		}
		
		//移除鼠标经过侦听
		private function removeAreaRollOverListener():void
		{
			_controlArea.removeEventListener(MouseEvent.ROLL_OVER, onAreaRollOver_handle);
			_controlArea.removeEventListener(MouseEvent.ROLL_OUT, onAreaRollOut_handle);
			try
			{
				_panel.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onAfterRollOverStageMouseMove_handle);
			}
			catch (e:Error)
			{
				
			}
		}
		
		//添加鼠标按下侦听
		private function addAreasMouseDownListener():void
		{
			_controlArea.addEventListener(MouseEvent.MOUSE_DOWN, onAreaMouseDown_handle);
		}
		
		//移除鼠标按下侦听
		private function removeAreasMouseDownListener():void
		{
			_controlArea.removeEventListener(MouseEvent.MOUSE_DOWN, onAreaMouseDown_handle);
		}
		
		///求两点之间的角度(0~360);
		private function TowPointAngle(x1:Number, y1:Number, x2:Number, y2:Number):int
		{
			var t:Number = (y1-y2)/(x1-x2);
			var a:Number = Math.atan(t) * 180 / Math.PI;
			
			if (x1 < x2)
			{
				a = 180 + a;
			}
			else if (y1 < y2)
			{
				a = 360 + a;
			}
			return int(a);
		}
		
		//显示鼠标跟随图标
		private function showMouseIcon(x:Number = 0, y:Number = 0):void
		{
			if (_mouseIcon != null)
			{
				_panel.stage.addChild(_mouseIcon);
				_mouseIcon.x = x;
				_mouseIcon.y = y;
			}	
		}
		
		//隐藏鼠标跟随图标
		private function hideMouseIcon():void
		{
			if (_mouseIcon != null && _panel.stage.contains(_mouseIcon))				
			{
				_panel.stage.removeChild(_mouseIcon);
			}
		}
		
		//============================================================================Handle
		//
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
		
		//鼠标在操作区域鼠标按下时处理
		private function onAreaMouseDown_handle(evt:MouseEvent):void
		{
			var p:Point = _panel.parent.globalToLocal(new Point(evt.stageX, evt.stageY));
			
			_distanceAngle = TowPointAngle(p.x, p.y, _panel.x, _panel.y) - _panel.rotation;
			
			try
			{
				_panel.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				_panel.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
				_panel.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave_handle);
				
				showMouseIcon(evt.stageX, evt.stageY);
			}
			catch (e:Error)
			{
				trace("RotateFeature.as："+e);
			}
			
			
			this.dispatchEvent(new Event(EVENT_START_ROTATE));
			
			Mouse.hide();
			removeAreaRollOverListener();
		}
		
		//操作区域鼠标经过时处理
		private function onAreaRollOver_handle(evt:MouseEvent):void
		{
			Mouse.hide();
			showMouseIcon(evt.stageX, evt.stageY);
			if (_panel.stage)
			{
				_panel.stage.addEventListener(MouseEvent.MOUSE_MOVE, onAfterRollOverStageMouseMove_handle);
			}
		}
		
		//操作区域鼠标移出时处理
		private function onAreaRollOut_handle(evt:MouseEvent):void
		{
			Mouse.show();
			hideMouseIcon();
			if (_panel.stage)
			{
				_panel.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onAfterRollOverStageMouseMove_handle);
			}
		}
		
		//鼠标经过操作按钮后的鼠标跟随控制
		private function onAfterRollOverStageMouseMove_handle(evt:MouseEvent):void
		{
			if (_mouseIcon != null)
			{
				_mouseIcon.x = evt.stageX;
				_mouseIcon.y = evt.stageY;
			}
		}
		
		//鼠标在舞台上移动时处理
		private function onStageMouseMove_handle(evt:MouseEvent):void
		{
			var p:Point = _panel.parent.globalToLocal(new Point(evt.stageX, evt.stageY));
			
			var angle:int = TowPointAngle(p.x, p.y, _panel.x, _panel.y);
			
			//计算排除初始角度
			angle -= angle / Math.abs(angle) * _distanceAngle;
			
			if (_mouseIcon != null)
			{
				_mouseIcon.x = evt.stageX;
				_mouseIcon.y = evt.stageY;
			}
			
			if (_panelPositionControlDomainOutSide)
			{
				
				this.dispatchEvent(new GlobalEvent(EVENT_PANEL_ROTATION_CHANGED, angle));
			}
			else
			{
				_panel.rotation = angle;
			}			
			
			evt.updateAfterEvent();
		}
		
		//鼠标在舞台上弹起时处理
		private function onStageMouseUp_handle(evt:MouseEvent):void
		{
			Mouse.show();
			addAreaRollOverListener();
			if (_panel.stage == null) return;
			
			try
			{
				_panel.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				_panel.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
				_panel.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave_handle);
				
				hideMouseIcon();
			}			
			catch (e:Error)
			{
				trace("RotateFeature.as："+e);
			}
			this.dispatchEvent(new Event(EVENT_STOP_ROTATE));
		}
		
		//鼠标移出舞台时处理
		private function onStageMouseLeave_handle(evt:Event):void
		{
			onStageMouseUp_handle(null);
		}
		
	}

}