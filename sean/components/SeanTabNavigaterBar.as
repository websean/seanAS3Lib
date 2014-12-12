package sean.components 
{
	
	
	/**标签导航类
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextFormat;
	
	public class SeanTabNavigaterBar extends Sprite
	{
		//标签标题的队列
		private var _tabTextArray:Array;
		//标签按钮的队列
		private var _tabArray:Array;
		//内容（引用）的队列
		private var _contentArray:Array;
		//当前显示的内容（引用）
		private var _currentContent:DisplayObject;		
		//标签按钮的容器
		private var _tabContainer:Sprite;
		//装载内容的容器的引用
		private var _contentContainer:DisplayObjectContainer;
		//标签按钮是否横向排列
		private var _tabLayout_h:Boolean;
		//tab按钮之间的间隙
		private var _tabSpace:Number;
		
		private var _activeIndex:int;
		//
		private var _tabBtnClassName:String;
		//Label样式数组（未选中和选中两种样式）
		private var _tabLabelTextFormatArr:Array;
		
		public static const EVENT_TAB_ITEM_CLICK:String = "EVENT_TAB_ITEM_CLICK";
		
		///tabLayout_h：表示标签按钮是否横向排列；tabBtnClassName：表示tab按钮的素材类名；tabLabelTextFormatArr：表示按钮的不同状态字体样式；tabSpace：按钮间隙
		public function SeanTabNavigaterBar(tabTextArr:Array, contentArr:Array = null, contentContainer:DisplayObjectContainer=null, activeIndex:int = 0, tabLayout_h:Boolean=true,tabBtnClassName:String = null, tabLabelTextFormatArr:Array = null, tabSpace:Number = 2) 
		{
			_tabArray = new Array();
			_tabTextArray = tabTextArr;
			_tabLayout_h = tabLayout_h;
			_tabBtnClassName = tabBtnClassName;
			_tabLabelTextFormatArr = tabLabelTextFormatArr;
			_tabSpace = tabSpace;
			
			if (contentArr)
			{
				_contentArray = contentArr;
			}
			else
			{
				
			}			
			_contentContainer = contentContainer;			
			initView();
			initControl();
			
			//设置默认激活
			setDefaultActive(_activeIndex);
		}
		
		///重新设置数据
		public function reSetData(tabTextArr:Array,contentArr:Array = null, contentContainer:DisplayObjectContainer=null, activeIndex:int = 0):void
		{
			while (_tabTextArray.length > 0 && _tabTextArray)
			{
				_tabTextArray.pop();
			}
			while (_contentArray.length > 0 && _contentArray)
			{
				_contentArray.pop();
			}			
			_tabTextArray = tabTextArr;
			if (contentArr)
			{
				_contentArray = contentArr;
			}
			else
			{
				
			}			
			_contentContainer = contentContainer;			
			
			//重新整理tab按钮对象
			for (var i:int = 0; i < _tabTextArray.length; i++)
			{
				if (i<_tabArray.length)
				{
					(_tabArray[i] as TabBtn).reSetTitle(String(_tabTextArray[i]));
				}
				else if (i>=_tabArray.length)
				{
					var tabBtn:TabBtn = new TabBtn(String(_tabTextArray[i]), _tabBtnClassName);
					_tabArray.push(tabBtn);
				}				
			}			
			if (_tabTextArray.length < _tabArray.length)
			{
				var distance:int = _tabArray.length - _tabTextArray.length;				
				_tabArray = _tabArray.slice(0, i);
			}			
			//
			modifyLayout();
			
			//设置默认激活
			setDefaultActive(_activeIndex);
		}
		
		///获取当前激活的标签索引
		public function getActiveIndex():int
		{
			return _activeIndex;
		}		
		
		//初始化界面
		private function initView():void
		{
			_tabContainer = new Sprite();			
			addChild(_tabContainer);			
			
			//初始化tab按钮对象
			for (var i:int = 0; i < _tabTextArray.length; i++)
			{
				var tabBtn:TabBtn = new TabBtn(String(_tabTextArray[i]), _tabBtnClassName, _tabLayout_h, _tabLabelTextFormatArr);
				
				_tabArray.push(tabBtn);
			}			
			modifyLayout();			
			//setActiveTabAt(_activeIndex);			
		}
		
		private function initControl():void
		{
			this.addEventListener("TabItemClick", onTabItemClick_handle);
		}
		
		//默认激活
		public function setDefaultActive(index:int):void
		{
			try 
			{
				(_tabArray[index] as TabBtn).simulateDispatchItemClickEvent();
			}
			catch (e:Error)
			{
				
			}
		}
		
		//设置激活状态
		private function setActiveTabAt(index:int):void
		{
			for each(var btn:TabBtn in _tabArray)
			{
				btn.setStatus(false);
			}
			if (index>=0 && index<_tabArray.length)
			{
				(_tabArray[index] as TabBtn).setStatus(true);
			}			
			_activeIndex = index;
		}
		
		//刷新布局
		private function modifyLayout():void
		{
			
			while (_tabContainer.numChildren > 0)
			{
				_tabContainer.removeChildAt(0);
			}
			
			//排列标签
			for (var n:int=0; n < _tabArray.length; n++)
			{
				//横向排列
				if (_tabLayout_h)
				{
					if (n==0)
					{
						(_tabArray[n] as TabBtn).x = 0;
					}
					else
					{
						(_tabArray[n] as TabBtn).x = (_tabArray[n - 1] as TabBtn).x + (_tabArray[n - 1] as TabBtn).width + _tabSpace;
					}
				}
				//纵向排列
				else
				{
					if (n==0)
					{
						(_tabArray[n] as TabBtn).y = 0;
					}
					else
					{
						(_tabArray[n] as TabBtn).y = (_tabArray[n - 1] as TabBtn).y + (_tabArray[n - 1] as TabBtn).height + _tabSpace;
					}
				}
				
				_tabContainer.addChild(_tabArray[n] as TabBtn);
			}
		}
		
		//===================================================================Handle		
		//当单击自身时处理
		private function onTabItemClick_handle(evt:Event):void
		{
			var index:int = _tabArray.indexOf(evt.target);
			if (index < 0) 
			{
				return;
			}
			setActiveTabAt(index);
			
			if (_contentContainer && _contentArray)
			{
				while (_contentContainer.numChildren > 0)
				{
					_contentContainer.removeChildAt(0);
				}
				if (index < _contentArray.length)
				{
					if (!(_contentArray[index] is DisplayObject))
					{
						throw(new Error("队列里放的不是显示对象!  Error !!! YgTabNavigaterBar.as"));
					}
					
					_contentContainer.addChild(_contentArray[index] as DisplayObject);
				}
				
			}
			
			dispatchEvent(new Event(EVENT_TAB_ITEM_CLICK));
		}
		
	}

}

//===========================================================================================================
//===========================================================================================================
//===========================================================================================================
//===========================================================================================================
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.system.ApplicationDomain;
///标签按钮类
class TabBtn extends Sprite
{
	private var _title_txt:TextField;
	private var _bg_mc:MovieClip;
	
	private var _title:String;
	private var _active:Boolean = false;
	private var _tabButtonClassName:String = "YgNavigaterBtn_MC";
	
	//是否横向按钮
	private var _layout_h:Boolean;
	//Label样式数组（未选中和选中两种样式）
	private var _labelTextFormatArr:Array;
	
	public function TabBtn(tabName:String, tabBtnClassName:String = null, layout_h:Boolean = true, labelTextFormatArr:Array = null):void
	{
		if (tabBtnClassName)
		{
			_tabButtonClassName = tabBtnClassName;
		}
		_title = tabName;
		_layout_h = layout_h;
		_labelTextFormatArr = labelTextFormatArr;
		
		initView();
		initControl();
	}
	
	///设置激活状态
	public function setStatus(active:Boolean):void
	{
		_active = active;
		if (_active)
		{
			this.buttonMode = false;
			removeListener();
			_bg_mc.gotoAndStop("able");
			
			setLabelTextFormatByStatus(_active);				
		}
		else
		{
			this.buttonMode = true;
			initControl();
			_bg_mc.gotoAndStop("disable");
			
			setLabelTextFormatByStatus(_active);
		}
	}
	
	///重设标题文字
	public function reSetTitle(str:String):void
	{
		_title = str;
		_title_txt.text = _title;
		modifyLayout();
	}
	
	///模拟派发鼠标单击事件
	public function simulateDispatchItemClickEvent():void
	{
		onBgClick_handle();
	}
	
	private function initView():void
	{
		
		var TabBtnClass:Class = ApplicationDomain.currentDomain.getDefinition(_tabButtonClassName) as Class;

		if (!TabBtnClass)
		{
			throw(new Error("找不到tab指定的库素材元件"+_tabButtonClassName+"！！！"));
			
		}
		this.buttonMode = true;
		_title_txt = new TextField();
		_bg_mc = new TabBtnClass();
		_bg_mc.gotoAndStop("disable");
		
		//样式
		_title_txt.selectable = false;
		_title_txt.wordWrap = false;
		_title_txt.multiline = false;
		_title_txt.mouseEnabled = false;
		if (_labelTextFormatArr)
		{
			_title_txt.defaultTextFormat = _labelTextFormatArr[0] as TextFormat;
		}
		else
		{
			_title_txt.defaultTextFormat = new TextFormat("Arial", 12, 0x2871af);
		}
		
		if (!_layout_h)
		{
			_title_txt.wordWrap = true;
			_title_txt.multiline = true;
		}
		
		_title_txt.text = _title;
		modifyLayout();
		
		addChild(_bg_mc);
		addChild(_title_txt);
	}
	
	private function initControl():void
	{
		_bg_mc.addEventListener(MouseEvent.CLICK, onBgClick_handle);
	}
	
	private function removeListener():void
	{
		if (_bg_mc.hasEventListener(MouseEvent.CLICK))
		{
			_bg_mc.removeEventListener(MouseEvent.CLICK, onBgClick_handle);
		}
		
	}
	
	private function modifyLayout():void
	{
		if (_layout_h)
		{
			_title_txt.width = _title_txt.textWidth + 3;
			_title_txt.height = _title_txt.textHeight + 3;
			
			_bg_mc.width = _title_txt.width + 10 + 10;
			_title_txt.x = 10;
			_title_txt.y = int((_bg_mc.height - _title_txt.height) / 2);
		}
		else
		{
			_title_txt.width = 22;
			_title_txt.height = _title_txt.textHeight + 10;
			
			_bg_mc.height = _title_txt.height + 10 + 10;
			_title_txt.x = int((_bg_mc.width - _title_txt.width) / 2) + 2;
			_title_txt.y = 10;
		}
		
	}
	
	//根据是否选中（可用）设置label字体样式
	private function setLabelTextFormatByStatus(active:Boolean):void
	{		
		if (_labelTextFormatArr)
		{
			var index:int = active?1:0;
			if (_labelTextFormatArr.length >= 2)
			{
				_title_txt.setTextFormat(_labelTextFormatArr[index] as TextFormat);
			}	
		}
		else
		{
			
		}
	}
	
	//======================================================================Handle
	//单击时处理
	private function onBgClick_handle(evt:MouseEvent=null):void
	{
		dispatchEvent(new Event("TabItemClick", true));
	}
	
}