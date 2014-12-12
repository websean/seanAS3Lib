package sean.components 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import sean.components.BaseHasMCSprite;
	import sean.components.BaseMCButton;
	import sean.mvc.events.GlobalEvent;
	
	/**下拉菜单控件
	 * ...
	 * @author Sean Lee
	 */
	public class SComboBox extends Sprite 
	{
		public static const EVENT_ITEM_SELETCED:String = "SComboBox_EVENT_ITEM_SELETCED";
		
		private var _UI:BaseHasMCSprite;
		private var _UIClassName:String;
		private var _UIItemClassName:String;
		private var _UIScrollBarClassName:String;
		private var _label:TextField;
		private var _bg:MovieClip;
		private var _btn:BaseMCButton;
		
		private var _stage:Stage;
		///菜单项显示对象集合
		private var _listView:Sprite;
		private var _itemList:Vector.<SComboBoxItem>;
		private var _defaultTextformat:TextFormat;
		private var _defaultLabel:String;
		private var _maxVisableItemNum:int;
		private var _maskW:Number;
		private var _maskH:Number;
		private var _scrollArea:ScrollArea;
		
		private var _labelKeyname:String;
		
		private var BtnInside:Boolean;
		private var BtnPadding:Number = 0;
		private var LabelPadding:Number = 0;
		
		private var _contents:Array;
		private var _currentIndex:int;
		private var _defaultIndex:int;
		
		///maxVisibleItemNum：下拉显示的项数目；defaultLabel：默认文本；defaultTextformat：默认文本样式；UIClassName：菜单默认UI样式；itemUIClassName：下拉项UI样式
		public function SComboBox(maxVisibleItemNum:int = 5, defaultLabel:String = "Default", defaultTextformat:TextFormat = null, UIClassName:String = null,  itemUIClassName:String = null, ScrollBarUIName:String = null) 
		{
			super();
			_maxVisableItemNum = maxVisibleItemNum;
			_UIClassName = UIClassName == null?"SComboBox_MC":UIClassName;
			_UIItemClassName = itemUIClassName;
			_UIScrollBarClassName = ScrollBarUIName;
			_defaultTextformat = defaultTextformat;
			_defaultLabel = defaultLabel;
			
			initData();
			initView();
			initControl();			
		}
		
		//初始化界面
		private function initView():void
		{
			_UI = new BaseHasMCSprite(_UIClassName);
			this.addChild(_UI);
			
			_label = _UI.getTxtByName("txt");
			_bg = _UI.getMCByName("bg");
			_bg.buttonMode = true;
			_btn = _UI.getBaseMCBtnByName("btn");
			
			_label.wordWrap = false;
			_label.multiline = false;
			_label.selectable = false;
			_label.mouseEnabled = false;
			if (_defaultTextformat != null)
			{
				_label.defaultTextFormat = _defaultTextformat;
			}
			
			
			_listView = new Sprite();
			_scrollArea = new ScrollArea(0, 0, 0, false, _UIScrollBarClassName);
			_scrollArea.registerTarget(_listView);
			
			SetDefaultIndex(0);
			
			modifyLayout();
		}
		
		//初始化监听控制
		private function initControl():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onThisAddToStage_handle);
		}
		
		//初始化数据
		private function initData():void
		{
			_contents = new Array();
			_currentIndex = 0;
			_defaultIndex = 0;
			
			_itemList = new Vector.<SComboBoxItem>();
		}
		
		//调整刷新布局
		private function modifyLayout():void
		{
			_btn.x = (_bg.x + _bg.width) + (BtnInside?( -BtnPadding - _btn.width):BtnPadding);
			
			_label.width = _bg.width + (BtnInside?( -BtnPadding - _btn.width - LabelPadding * 2): (-LabelPadding * 2));
			_label.x = LabelPadding;
		}
		
		//清空数据
		private function clearData():void
		{
			while (_contents.length > 0)
			{
				_contents.pop();
			}
		}
		
		//清空界面显示对象
		private function clearView():void
		{
			while (_itemList.length > 0)
			{
				var item:SComboBoxItem = _itemList.pop();
				item.removeEventListener(SComboBoxItem.ITEM_EVENT_ITEM_SELECTED, onItemSelected_handle);
				if (_listView.contains(item))
				{
					_listView.removeChild(item);
				}
			}
			
			while (_listView.numChildren > 0)
			{
				_listView.removeChildAt(0);
			}
		}
		
		//调整指向的项
		public function SelecteItem(index:int):void
		{
			_currentIndex = index;
			
			var data:Object = _contents[_currentIndex] as Object;
			if (data)
			{
				_label.text = String(data[_labelKeyname]);				
			}
			else
			{
				_label.text = _defaultLabel;
			}
			
			this.dispatchEvent(new GlobalEvent(EVENT_ITEM_SELETCED, data));
		}
		
		//
		protected function showItems():void
		{
			if (!_stage)
			{
				return;
			}
			if (_contents.length <= 0)
			{
				return;
			}
			var p:Point = this.localToGlobal(new Point(0, this.height));
			_stage.addChild(_scrollArea);
			_scrollArea.x = p.x;
			_scrollArea.y = p.y;	
			_stage.addEventListener(MouseEvent.CLICK, onThisStageClick_handle);
		}
		
		//
		protected function hideItems():void
		{
			if (_stage)
			{
				if (_stage.contains(_scrollArea))
				{
					_stage.removeChild(_scrollArea);
				}
				_stage.removeEventListener(MouseEvent.CLICK, onThisStageClick_handle);
			}
		}
		
		//====================================================Public
		override public function get width():Number 
		{
			var w:Number = 0;
			w = _UI.getStuffMC().width;
			return w;
		}
		
		override public function set width(value:Number):void 
		{
			//super.width = value;
			if (BtnInside)
			{
				_bg.width = value;
			}
			else
			{
				_bg.width = value - _btn.width - BtnPadding;
			}
			
			modifyLayout();
			
			if (_itemList.length > 0)
			{
				for each(var item:SComboBoxItem in _itemList)
				{
					item.width = _bg.width;
				}
			}
		}
		
		override public function get height():Number 
		{
			return _UI.getStuffMC().height;//super.height;
		}
		
		override public function set height(value:Number):void 
		{
			//super.height = value;
		}
		
		public function ModifyStyle(btnInside:Boolean,btnPadding:Number, labelPadding:Number = 0):void
		{
			BtnInside = btnInside;
			BtnPadding = btnPadding;
			LabelPadding = labelPadding;
			
			modifyLayout();
		}
		
		///设置数据
		public function SetData(dataList:Array, labelKeyName:String = "label", defaultTextFormat:TextFormat = null):void
		{
			clearData();
			clearView();
			
			_contents = dataList.concat();
			_labelKeyname = labelKeyName;
			
			if (_defaultLabel != null)
			{
				_contents.unshift(null);
				
			}
			
			var i:int = 0;
			for each(var obj:Object in _contents)
			{				
				var item:SComboBoxItem = new SComboBoxItem(obj, labelKeyName, defaultTextFormat, _defaultLabel, _UIItemClassName);
				_itemList.push(item);
				_listView.addChild(item);
				item.y = i * item.height;
				i++;
				
				item.addEventListener(SComboBoxItem.ITEM_EVENT_ITEM_SELECTED, onItemSelected_handle);
				
				_maskW = item.width;
				_maskH = item.height * _maxVisableItemNum;
			}
			
			_scrollArea.Resize(_maskW, _maskH);
			_scrollArea.registerTarget(_listView);			
			
			SetDefaultIndex(0);
		}
		
		public function RemoveData():void
		{
			clearData();
			clearView();
			_scrollArea.registerTarget(_listView);
			SetDefaultIndex(0);
		}
		
		///设置默认项索引
		public function SetDefaultIndex(index:int):void
		{
			_defaultIndex = index;
			
			SelecteItem(index);
		}
		
		///获取当前选择项对应的值对象
		public function GetCurrentData():Object
		{
			var data:Object = _contents[_currentIndex] as Object;
			return data;
		}
		
		//====================================================Handle
		//
		private function onThisAddToStage_handle(evt:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
			_stage = this.stage;
			
			this.addEventListener(MouseEvent.CLICK, onBtnClick_handle);
		}
		
		//
		private function onThisRemoveFromStage_handle(evt:Event):void
		{
			hideItems();
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
			this.removeEventListener(MouseEvent.CLICK, onBtnClick_handle);
			_stage = null;		
			
		}
		
		//
		private function onBtnClick_handle(evt:MouseEvent):void
		{
			if (_stage.contains(_listView))
			{
				hideItems();
			}
			else
			{
				showItems();
			}			
			evt.stopImmediatePropagation();
		}
		
		//
		private function onThisStageClick_handle(evt:MouseEvent):void
		{
			hideItems();			
		}
		
		//
		private function onItemSelected_handle(evt:Event):void
		{
			var item:SComboBoxItem = evt.target as SComboBoxItem;
			var index:int = _itemList.indexOf(item);
			SelecteItem(index);
			hideItems();
		}
		
	}

}




import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import sean.components.BaseHasMCSprite;
import sean.components.BaseMCButton;


///下拉菜单显示项
class SComboBoxItem extends BaseHasMCSprite
{
	public static const ITEM_EVENT_ITEM_SELECTED:String = "SComboBoxItem_ITEM_EVENT_ITEM_SELECTED";
	private var _data:Object;
	private var _lb:TextField;
	private var _bgBtn:BaseMCButton;
	private var _defaultTF:TextFormat;
	private var _lbKeyName:String;
	private var _defaultLB:String;
	private var LB_Padding:Number = 0;
	
	public function SComboBoxItem(data:Object, labelKeyName:String = "label", defaultTF:TextFormat = null, defaultLabel:String = null, UIClassName:String = null):void
	{
		_data = data;
		_lbKeyName = labelKeyName;
		_defaultTF = defaultTF;
		_defaultLB = defaultLabel;
		if (UIClassName == null) UIClassName = "SComboBoxItem_MC";
		super(UIClassName);
	}
	
	override protected function supplementInitView():void 
	{
		super.supplementInitView();
		
		_bgBtn = getBaseMCBtnByName("bg");
		_lb = getTxtByName("txt");
		getStuffMC().addChild(_lb);
		
		_lb.wordWrap = false;
		_lb.multiline = false;
		_lb.selectable = false;
		_lb.mouseEnabled = false;
		if (_defaultTF != null)
		{
			_lb.defaultTextFormat = _defaultTF;
		}
		if (_data != null)
		{
			_lb.text = String(_data[_lbKeyName]);
		}
		else if (_defaultLB != null)
		{
			_lb.text = _defaultLB;
		}
		
		_lb.height = _lb.textHeight + 3;
		_lb.y = (_bgBtn.height - _lb.height) / 2;
	}
	
	private function modifyLayout():void
	{
		_lb.width = _bgBtn.width - LB_Padding * 2;
		_lb.x = LB_Padding;
	}
	
	override protected function supplementInitControl():void 
	{
		super.supplementInitControl();
		
		this.addEventListener(Event.ADDED_TO_STAGE, onThisAddToStage_handle);
	}
	
	override public function get width():Number 
	{
		return _bgBtn.width;//super.width;
	}
	
	override public function set width(value:Number):void 
	{
		//super.width = value;
		_bgBtn.width = value;
		modifyLayout();
	}
	
	override public function get height():Number 
	{
		return _bgBtn.height;//super.height;
	}
	
	override public function set height(value:Number):void 
	{
		//super.height = value;
	}
	
	public function get Data():Object
	{
		return _data;
	}
	
	//=========================================================================Handle
	//
	private function onThisAddToStage_handle(evt:Event):void
	{
		this.addEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
		this.addEventListener(MouseEvent.CLICK, onThisMouseClick_handle);
	}
	
	//
	private function onThisRemoveFromStage_handle(evt:Event):void
	{
		this.removeEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
		this.removeEventListener(MouseEvent.CLICK, onThisMouseClick_handle);
	}
	
	//
	private function onThisMouseClick_handle(evt:MouseEvent):void
	{
		evt.stopImmediatePropagation();
		this.dispatchEvent(new Event(ITEM_EVENT_ITEM_SELECTED));
	}
	
	
}