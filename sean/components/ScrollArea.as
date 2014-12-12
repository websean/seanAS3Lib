package sean.components 
{
	
	
	/**滚动区组件
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollArea extends Sprite
	{
		//遮罩
		private var _masker:Sprite;
		//滚动条组件
		private var _scrollBar:ScrollBar;
		//设定宽
		private var _w:Number;
		//设定高
		private var _h:Number;
		//滚动条组件皮肤
		private var _sbMCClassName:String;
		//滚动条与容器之间的间隔距离
		private var _scrollpadding:Number;
		//滚动条是否缩进（内嵌）容器内
		private var _scrollBarInside:Boolean;
		//容器
		private var _targetContainer:Sprite;
		//控制对象
		private var _target:DisplayObject;
		//是否是竖向
		private var _vertical:Boolean;
		//是否一直检查滚动条显示状态
		private var _updateScrollBarAllTheTime:Boolean;
		//是否支持鼠标滚轴滚动
		private var _wheelScroll:Boolean;
		
		///顶部间隙
		private var _spaceH:Number = 0;
		///左边间隙
		private var _spaceW:Number = 0;
		
		public function ScrollArea(w:Number, h:Number, scrollpadding:Number = 0, scrollBarInSide:Boolean = false, scrollBarMCClassName:String = null, vertical:Boolean = true) 
		{
			_w = w;
			_h = h;
			_scrollpadding = scrollpadding;
			_scrollBarInside = scrollBarInSide;
			_sbMCClassName = scrollBarMCClassName;
			_vertical = vertical;
			
			initView();
			initControl();
			
		}
		
		//初始化显示对象
		private function initView():void
		{
			_masker = new Sprite();			
			_scrollBar = new ScrollBar(_h, _vertical, _sbMCClassName);			
			_targetContainer = new Sprite();
			
			addChild(_masker);			
			addChild(_targetContainer);
			addChild(_scrollBar);
			
			_targetContainer.mask = _masker;
			
			modifySize();
		}
		
		//
		private function modifySize():void
		{
			_masker.graphics.beginFill(0, 1);
			_masker.graphics.drawRect(0, 0, _w, _h);
			_masker.graphics.endFill();
			
			_scrollBar.reSetCom_height(_h);
			_scrollBar.x = _w + _scrollpadding*(_scrollBarInside?-1:1) - _scrollBar.width*(_scrollBarInside?1:0);
			_scrollBar.y = 0;
		}
		
		//初始化控制监听
		private function initControl():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onThisAddedToStage_handle);
			_scrollBar.addEventListener(ScrollBar.EVENT_SCROLL, onScroll_handle);
		}
		
		//初始化位置
		private function clearPosition():void
		{
			if (_vertical)
			{
				_targetContainer.y = 0;
				if (_target)
				{
					_target.y = _spaceH;
				}
			}
			else
			{
				_targetContainer.x = 0;
				if (_target)
				{
					_target.x = _spaceW;
				}
			}
			
			_scrollBar.modifyBarPosition(0);
		}
		
		///根据内容刷新滚动条组件的显示状态
		public function updateScrollBarDisable():void
		{
			if (_target)
			{
				if (_vertical)
				{
					if ((_target.height + _spaceH) > _h)
					{
						_scrollBar.visible = true;
						_scrollBar.modifyBarHeight(_h / (_target.height + _spaceH));
					}
					else
					{
						_scrollBar.visible = false;
					}
				}
				else
				{
					if ((_target.width + _spaceW) > _w)
					{
						_scrollBar.visible = true;
						_scrollBar.modifyBarHeight(_w / (_target.width + _spaceW));
					}
					else
					{
						_scrollBar.visible = false;
					}
				}				
			}
		}
		
		///注册控制对象
		public function registerTarget(target:DisplayObject, updateScrollBarAllTheTime:Boolean = false, wheelScroll:Boolean = false):void
		{
			_target = target;
			
			while (_targetContainer.numChildren > 0)
			{
				_targetContainer.removeChildAt(0);
			}
			_spaceH = _target.y;
			_spaceW = _target.x;
			_targetContainer.addChild(_target);
			
			clearPosition();
			updateScrollBarDisable();
			
			_updateScrollBarAllTheTime = updateScrollBarAllTheTime;			
			
			_wheelScroll = wheelScroll;
			
			addUpdateScrollBarDisableCheckAllTheTime();
			addWheelScroll();
		}
		
		override public function get width():Number { return _masker.width; }
		
		override public function set width(value:Number):void 
		{
			_masker.width = value;
		}
		
		override public function get height():Number { return _masker.height; }
		
		override public function set height(value:Number):void 
		{
			_masker.height = value;
		}
		
		///重置尺寸
		public function Resize(w:Number, h:Number, scrollpadding:Number = 0):void
		{
			_w = w;
			_h = h;
			_scrollpadding = scrollpadding;
			modifySize();
		}
		
		
		//根据条件添加滚动条显示状态检查机制
		private function addUpdateScrollBarDisableCheckAllTheTime():void
		{
			if (_updateScrollBarAllTheTime)
			{
				this.addEventListener(Event.ENTER_FRAME, onCheckScrollBarDisable_handle);
			}
		}
		
		//添加鼠标滚轴滚动功能
		private function addWheelScroll():void
		{
			if (_wheelScroll)
			{
				this.addEventListener(MouseEvent.MOUSE_WHEEL, onThisMouseWheel_handle);
			}
		}
		
		///滚动显示内容（按百分比）
		private function ScrollPercent(percent:Number):void
		{
			if (_vertical)
			{
				if ((_target.height + _spaceH) > _h)
				{
					_target.y = _spaceH - ((_target.height + _spaceH) - _h) * percent;
				}
				
			}
			else
			{
				if ((_target.width + _spaceW) > _w)
				{
					_target.x = _spaceW - ((_target.width + _spaceW) - _w) * percent;
				}
				
			}
		}
		
		//=================================================================================Handle
		//当滚动时处理
		private function onScroll_handle(evt:Event):void
		{
			var percent:Number = _scrollBar.getScrollPercent();
			
			ScrollPercent(percent);
		}
		
		//当组件添加到舞台时处理
		private function onThisAddedToStage_handle(evt:Event):void
		{
			clearPosition();
			addUpdateScrollBarDisableCheckAllTheTime();
			addWheelScroll();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);			
		}
		
		//当组件从舞台上移除时处理
		private function onThisRemoveFromStage_handle(evt:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
			this.removeEventListener(Event.ENTER_FRAME, onCheckScrollBarDisable_handle);
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, onThisMouseWheel_handle);
		}
		
		//入帧检查滚动条显示状态
		private function onCheckScrollBarDisable_handle(evt:Event):void
		{
			updateScrollBarDisable();
		}
		
		//鼠标滚轴变化时处理
		private function onThisMouseWheel_handle(evt:MouseEvent):void
		{
			var d:Number = evt.delta;
			var p:Number = _scrollBar.getScrollPercent();
			p -= 0.1 * d / Math.abs(d);
			if (p < 0) p = 0;
			if (p > 1) p = 1;
			_scrollBar.modifyBarPosition(p);
			ScrollPercent(p);
		}
		
	}

}