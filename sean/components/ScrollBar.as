package sean.components 
{
	
	
	/**
	 * ...滚动条组件（支持无上下或左右箭头的样式）
	 * @author Sean Lee
	 */
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	public class ScrollBar extends Sprite
	{
		
		private var _stuff_mc:MovieClip;
		
		private var _upBtn:BaseMCButton;
		private var _downBtn:BaseMCButton;
		public var _bar_up:BaseMCButton;
		private var _bg:MovieClip;
		
		private var _scrollBarHeight:Number;
		private var _mouseExcursion:Number;
		
		private var _percentNum:Number;
		
		//滚动条高度的百分比
		private var _barHeightPercent:Number;
		
		//背景热区（鼠标响应区）
		private var _bgInteractiveArea:Sprite;
		//拖拽过程可移动的距离
		private var _barScrollDistance:Number;
		
		//允许的极限误差（拖动到最上面或最下面，快接近时的误差）
		private static const ScrollWindage:Number = 3;
		
		private var _stuffClassName:String;
		
		public static const EVENT_SCROLL:String = "EVENT_SCROLL";
		private var _layoutVertical:Boolean;
		
		///comp_height：控件长度；vertical：是否纵向布局；stuffClassName：UI素材类名；
		public function ScrollBar(comp_height:Number, vertical:Boolean = true, stuffClassName:String = null) 
		{
			_scrollBarHeight = comp_height;
			_layoutVertical = vertical;
			_stuffClassName = stuffClassName;
			if (vertical)
			{
				initViewForV();
			}
			else
			{
				initViewForH();
			}
			
			initControl();
		}		
		
		private function initViewForV():void
		{
			var ScrollMCClass:Class;
			try
			{
				ScrollMCClass= ApplicationDomain.currentDomain.getDefinition(_stuffClassName?_stuffClassName:"VScrollBar_MC") as Class;
			}
			catch(e:Error)
			{
				trace(e,"ScrollBar.as");
			}
			if (!ScrollMCClass)
			{
				return;
			}
			_stuff_mc = new ScrollMCClass();
			
			var upBtnMC:MovieClip = _stuff_mc.getChildByName("upBtn_mc") as MovieClip;
			var downBtnMC:MovieClip = _stuff_mc.getChildByName("downBtn_mc") as MovieClip;
			if(upBtnMC)_upBtn = new BaseMCButton(null, null, upBtnMC);
			if(downBtnMC)_downBtn = new BaseMCButton(null, null, downBtnMC);
			_bar_up = new BaseMCButton(null, null, _stuff_mc.getChildByName("barUp_mc") as MovieClip);
			_bg = _stuff_mc.getChildByName("bg_mc") as MovieClip;
			
			_bgInteractiveArea = new Sprite();
			
			_bar_up.buttonMode = false;
			
			reSetCom_height(_scrollBarHeight);
			
			addChild(_bg);
			addChild(_bgInteractiveArea);
			addChild(_bar_up);
			if(_upBtn)addChild(_upBtn);
			if(_downBtn)addChild(_downBtn);
			
		}
		
		private function initViewForH():void
		{
			var ScrollMCClass:Class;
			try
			{
				ScrollMCClass= ApplicationDomain.currentDomain.getDefinition(_stuffClassName?_stuffClassName:"HScrollBar_MC") as Class;
			}
			catch(e:Error)
			{
				trace(e,"ScrollBar.as");
			}
			if (!ScrollMCClass)
			{
				return;
			}
			_stuff_mc = new ScrollMCClass();
			
			var upBtnMC:MovieClip = _stuff_mc.getChildByName("upBtn_mc") as MovieClip;
			var downBtnMC:MovieClip = _stuff_mc.getChildByName("downBtn_mc") as MovieClip;
			if(upBtnMC)_upBtn = new BaseMCButton(null, null, upBtnMC);
			if(downBtnMC)_downBtn = new BaseMCButton(null, null, downBtnMC);
			_bar_up = new BaseMCButton(null, null, _stuff_mc.getChildByName("barUp_mc") as MovieClip);
			_bg = _stuff_mc.getChildByName("bg_mc") as MovieClip;
			
			_bgInteractiveArea = new Sprite();
			
			_bar_up.buttonMode = false;
			
			reSetCom_height(_scrollBarHeight);
			
			addChild(_bg);
			addChild(_bgInteractiveArea);
			addChild(_bar_up);
			if(_upBtn)addChild(_upBtn);
			if(_downBtn)addChild(_downBtn);
			
		}
		
		private function initControl():void
		{
			if (!_bar_up)
			{
				return;
			}
			_bar_up.addEventListener(MouseEvent.MOUSE_DOWN, onBarMouseDown_handle);
			_bar_up.addEventListener(MouseEvent.CLICK, onBarClick_handle);
			
			if(_upBtn)_upBtn.addEventListener(MouseEvent.CLICK, onUpBtnClick_handle);
			if(_downBtn)_downBtn.addEventListener(MouseEvent.CLICK, onDownBtnClick_handle);
			_bgInteractiveArea.addEventListener(MouseEvent.CLICK, onBarBgClick_handle);
		}
		
		//======================================================================================================Handle
		//滚动条被按下时处理
		private function onBarMouseDown_handle(evt:MouseEvent):void
		{
			_mouseExcursion = _layoutVertical?(mouseY - _bar_up.y):(mouseX - _bar_up.x);
			
			if (this.stage)
			{
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				this.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseUp_handle);
				this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage_handle);
			}
			
			evt.stopImmediatePropagation();
		}
		
		//
		private function onBarClick_handle(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
		}
		
		//场景舞台上鼠标弹起时处理
		private function onStageMouseUp_handle(evt:MouseEvent):void
		{
			if (this.stage)
			{			
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				this.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseUp_handle);
			}
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage_handle);
		}
		
		//从舞台上移除时处理
		private function onRemoveFromStage_handle(evt:Event):void
		{
			onStageMouseUp_handle(null);
		}
		
		//鼠标在场景舞台移动时处理
		private function onStageMouseMove_handle(evt:MouseEvent):void
		{
			if (_layoutVertical)
			{
				if ((mouseY-_mouseExcursion) < ((_upBtn == null)?0:(_upBtn.height + _upBtn.y)) + ScrollWindage)
				{
					_percentNum = 0;
					_bar_up.y = ((_upBtn == null)?0:(_upBtn.height + _upBtn.y));
					evt.updateAfterEvent();
					dispatchEvent(new Event(EVENT_SCROLL));
					return;
				}
				if((mouseY+(_bar_up.height - _mouseExcursion)) > (_downBtn==null?_scrollBarHeight:_downBtn.y) - ScrollWindage)
				{
					_percentNum = 1;
					_bar_up.y = (_downBtn==null?_scrollBarHeight:_downBtn.y) - _bar_up.height;
					evt.updateAfterEvent();
					dispatchEvent(new Event(EVENT_SCROLL));
					return;
				}
				_bar_up.y = mouseY - _mouseExcursion;
				_percentNum = (_bar_up.y - (_upBtn==null?0:_upBtn.height)) / _barScrollDistance;
			}
			else
			{
				if ((mouseX -_mouseExcursion) < ((_upBtn == null)?0:(_upBtn.width + _upBtn.x)) + ScrollWindage)
				{
					_percentNum = 0;
					_bar_up.x = ((_upBtn == null)?0:(_upBtn.width + _upBtn.x));
					evt.updateAfterEvent();
					dispatchEvent(new Event(EVENT_SCROLL));
					return;
				}
				if((mouseX+(_bar_up.width - _mouseExcursion)) > (_downBtn==null?_scrollBarHeight:_downBtn.x) - ScrollWindage)
				{
					_percentNum = 1;
					_bar_up.x = (_downBtn==null?_scrollBarHeight:_downBtn.x) - _bar_up.width;
					evt.updateAfterEvent();
					dispatchEvent(new Event(EVENT_SCROLL));
					return;
				}
				_bar_up.x = mouseX - _mouseExcursion;
				_percentNum = (_bar_up.x - (_upBtn==null?0:_upBtn.width)) / _barScrollDistance;
			}
			
			//trace(_percentNum);			
			evt.updateAfterEvent();
			
			dispatchEvent(new Event(EVENT_SCROLL));
		}
		
		//向上（前）滚动一个单位按钮被单击时处理
		private function onUpBtnClick_handle(evt:MouseEvent = null):void
		{
			if (_percentNum > 0)
			{
				var stepPercent:Number = _layoutVertical?(_bar_up.height /  _bgInteractiveArea.height):(_bar_up.width / _bgInteractiveArea.width);
				if (_percentNum < stepPercent)
				{
					_percentNum = 0;
				}
				else
				{
					_percentNum = _percentNum - stepPercent;
				}
				
				if (_layoutVertical)
				{
					_bar_up.y = _barScrollDistance * _percentNum + ((_upBtn == null)?0:(_upBtn.height + _upBtn.y));
				}
				else
				{
					_bar_up.x = _barScrollDistance * _percentNum + ((_upBtn == null)?0:(_upBtn.width + _upBtn.x));
				}
				
				dispatchEvent(new Event(EVENT_SCROLL));
			}
			
			if(evt)evt.stopImmediatePropagation();
		}
		
		//向下（后）滚动一个单位按钮被单击时处理
		private function onDownBtnClick_handle(evt:MouseEvent = null):void
		{
			if (_percentNum < 1)
			{
				var stepPercent:Number = _layoutVertical?(_bar_up.height /  _bgInteractiveArea.height):(_bar_up.width / _bgInteractiveArea.width);
				if ((1-_percentNum) < stepPercent)
				{
					_percentNum = 1;
				}
				else
				{
					_percentNum = _percentNum + stepPercent;
				}
				
				if (_layoutVertical)
				{
					_bar_up.y = _barScrollDistance * _percentNum + ((_upBtn == null)?0:(_upBtn.height + _upBtn.y));
				}
				else
				{
					_bar_up.x = _barScrollDistance * _percentNum + ((_upBtn == null)?0:(_upBtn.width + _upBtn.x));
				}
				
				dispatchEvent(new Event(EVENT_SCROLL));
			}
			
			if(evt)evt.stopImmediatePropagation();
		}
		
		//滚动条背景被单击时处理
		private function onBarBgClick_handle(evt:MouseEvent):void
		{
			if (mouseY > _bar_up.y)
			{
				onDownBtnClick_handle();//_downBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else
			{
				onUpBtnClick_handle();//_upBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			
			evt.stopImmediatePropagation();
		}
		
		
		//=======================================================================================================Public
		///重新设置本组件的高度（或长度，如果是横向的）
		public function reSetCom_height(comp_height:Number):void
		{
			if (_layoutVertical)
			{			
				_scrollBarHeight = comp_height;
				_bg.height = _scrollBarHeight;
				_bg.x = 0;
				_bg.y = 0;
				if (_upBtn)
				{
					_upBtn.x = (_bg.width - _upBtn.width) / 2;
					_upBtn.y = 0;	
				}
				if (_downBtn)
				{
					_downBtn.x = (_bg.width - _downBtn.width) / 2;
					_downBtn.y = _bg.height - _downBtn.height;
				}			
				_bar_up.x = (_bg.width - _bar_up.width) / 2;
				_bar_up.y = ((_upBtn == null)?0:(_upBtn.height + _upBtn.y));
				
				_bgInteractiveArea.graphics.clear();
				_bgInteractiveArea.graphics.beginFill(0,0);
				_bgInteractiveArea.graphics.drawRect(0, 0, _bg.width, (_bg.height - ((_upBtn == null)?0:_upBtn.height) - ((_downBtn == null)?0:_downBtn.height)));
				_bgInteractiveArea.graphics.endFill();
				_bgInteractiveArea.x = 0;
				_bgInteractiveArea.y = ((_upBtn == null)?0:(_upBtn.height + _upBtn.y));
				
				_barScrollDistance = _bg.height - ((_upBtn == null)?0:_upBtn.height) - ((_downBtn == null)?0:_downBtn.height) - _bar_up.height;
			}
			else
			{
				_scrollBarHeight = comp_height;
				_bg.width = _scrollBarHeight;
				_bg.x = 0;
				_bg.y = 0;
				if (_upBtn)
				{
					_upBtn.x = 0;
					_upBtn.y = (_bg.height - _upBtn.height) / 2;
				}
				if (_downBtn)
				{
					_downBtn.x = _bg.width - _downBtn.width;
					_downBtn.y = (_bg.height - _downBtn.height) / 2;
				}			
				_bar_up.x = ((_upBtn == null)?0:(_upBtn.width + _upBtn.x));
				_bar_up.y = (_bg.height - _bar_up.height) / 2;
				
				_bgInteractiveArea.graphics.clear();
				_bgInteractiveArea.graphics.beginFill(0,0);
				_bgInteractiveArea.graphics.drawRect(0, 0, _bg.width - ((_upBtn == null)?0:_upBtn.width) - ((_downBtn == null)?0:_downBtn.width), _bg.height);
				_bgInteractiveArea.graphics.endFill();
				_bgInteractiveArea.x =  ((_upBtn == null)?0:(_upBtn.width + _upBtn.x));
				_bgInteractiveArea.y = 0;
				
				_barScrollDistance = _bg.width - ((_upBtn == null)?0:_upBtn.width) - ((_downBtn == null)?0:_downBtn.width) - _bar_up.width;
			}
		}
		
		///获取滚动百分比
		public function getScrollPercent():Number
		{
			
			return _percentNum;
		}
		
		///控制调整滚动条高度（通过百分比对比值）
		public function modifyBarHeight(barHeightPercent:Number):void
		{
			if (_layoutVertical)
			{			
				if (barHeightPercent>=1)
				{
					_barHeightPercent = 0.3;
				}
				else if(barHeightPercent<=0.2)
				{
					_barHeightPercent = 0.2;
				}
				else if(barHeightPercent<1 && barHeightPercent>0.2)
				{
					_barHeightPercent = barHeightPercent;
				}
				_bar_up.setSize(_bar_up.width, _bgInteractiveArea.height * _barHeightPercent);
				_barScrollDistance = _bg.height - ((_upBtn == null)?0:_upBtn.height) - ((_downBtn == null)?0:_downBtn.height) - _bar_up.height;
			}
			else
			{
				if (barHeightPercent>=1)
				{
					_barHeightPercent = 0.3;
				}
				else if(barHeightPercent<=0.2)
				{
					_barHeightPercent = 0.2;
				}
				else if(barHeightPercent<1 && barHeightPercent>0.2)
				{
					_barHeightPercent = barHeightPercent;
				}
				_bar_up.setSize(_bgInteractiveArea.width * _barHeightPercent, _bar_up.height);
				_barScrollDistance = _bg.width - ((_upBtn == null)?0:_upBtn.width) - ((_downBtn == null)?0:_downBtn.width) - _bar_up.width;
			}
		}
		
		///根据外部参数调整滚动条的位置
		public function modifyBarPosition(scrollPercent:Number):void
		{
			if (_layoutVertical)
			{
				_percentNum = scrollPercent;
				_bar_up.y = _barScrollDistance * _percentNum + ((_upBtn == null)?0:(_upBtn.height + _upBtn.y));
			}
			else
			{
				_percentNum = scrollPercent;
				_bar_up.x = _barScrollDistance * _percentNum + ((_upBtn == null)?0:(_upBtn.width + _upBtn.x));
			}
		}
		
	}

}