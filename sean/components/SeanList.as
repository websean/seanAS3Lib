package sean.components 
{
	
	
	/**
	 * ...列表组件
	 * @author Sean Lee
	 */
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	public class SeanList extends Sprite
	{
		//列数
		private var _columns:int;
		//支持拖拽项
		private var _dragItem:Boolean;
		private var _topSpace:Number ;
		private var _leftSpace:Number;
		private var _rowSpace:Number;
		private var _columnSpace:Number;
		//支持垂直滚动条
		private var _hasVScroll:Boolean;
		//支持横向滚动条
		private var _hasHScroll:Boolean;
		//是否是竖向（无限延伸）排列（如果是false则是横向（无限延伸）排列）
		private var _vArrage:Boolean;
		//列表里的（横向）行数
		private var _rows:int;
		
		private var _listWidth:int;
		private var _listHeight:int;
		
		private var _dataArray:Array;
		
		private var _itemsContainer:Sprite;
		private var _mainMasker:Sprite;
		
		private var _vScrollBar:ScrollBar;
		
		//当前被交互的项
		private var _currentInteractiveItem:DisplayObject;
		private var _currentInteractiveItemIndex:int;
		
		//Item的背景
		private var _itemBg:Sprite = null ;
		//Item单击选择的背景
		private var _itemSelectedBg:Sprite = null ;
		
		//事件
		public static const ITEM_CLICK:String = "ITEM_CLICK";
		public static const ITEM_START_DRAG:String = "ITEM_DRAG";
		public static const ITEM_STOP_DRAG:String = "ITEM_STOP_DRAG";
		
		/* * columns：列表里的（竖向（无限延伸）排列）列数
			* topSpace:顶部距离
			* dragItem：是否支持拖拽项
			* hasVScroll：是否支持垂直滚动条
			* hasHScroll：是否支持横向滚动条
			* rowSpace：行间隔（两横向列之间距离）
			* columnSpace：列间隔（两垂直列之间距离）
			* vArrange：是否是竖向排列（如果是false则是横向排列）
			* rows：列表里的（横向（无限延伸）排列）行数
		* */
		public function SeanList(listWidth:int, listHeight:int,  columns:int = 1, topSpace:Number = 2 , leftSpace:Number = 2,
		rowSpace:Number = 10, columnSpace:Number = 10 , dragItem:Boolean = false, 
		hasVScroll:Boolean = false, hasHScroll:Boolean = false,
		vArrange:Boolean=true, rows:int=1) 
		{
			_dataArray = new Array();
			
			_listWidth = listWidth;
			_listHeight = listHeight;
			_columns = columns;
			_topSpace = topSpace ;
			_leftSpace = leftSpace;
			_rowSpace = rowSpace;
			_columnSpace = columnSpace;
			
			_dragItem = dragItem;
			_hasVScroll = hasVScroll;
			_hasHScroll = hasHScroll;
			
			_vArrage = vArrange;
			_rows = rows;
			
			initView();
		}
		
		///初始化显示层
		private function initView():void
		{
			createBackground();
			
			createItemsContainer();
			createMainMasker();
			
			if (_hasVScroll)
			{
				createVScrollBar();
			}
			if (_hasHScroll)
			{
				createHScrollBar();
			}
			
		}
		
		///创建背景
		private function createBackground():void
		{
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, _listWidth, _listHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(0, 0);
			this.graphics.lineStyle(1, 0xffffff,0);
			this.graphics.drawRect(0, 0, _listWidth, _listHeight);
			this.graphics.endFill();
			//防止透明处遮挡住同级的其他元素
			this.mouseEnabled = false;
		}
		
		///创建垂直滚动条
		private function createVScrollBar(scrollBarClassName:String = null):void
		{
			if (_vScrollBar)
			{
				trace("vScrollBar 已存在！！！Error！！！");
				return;
			}
			_vScrollBar = new ScrollBar(_listHeight,true,scrollBarClassName);
			_vScrollBar.x = _listWidth - _vScrollBar.width;
			addChild(_vScrollBar);
			
			_vScrollBar.addEventListener(ScrollBar.EVENT_SCROLL, onVScroll_handle);
			if (_dataArray.length <= 0)
			{
				_vScrollBar.visible = false;
			}
		}
		
		///创建横向滚动条
		private function createHScrollBar(scrollBarClassName:String = null):void
		{
			
		}
		
		///创建项容器
		private function createItemsContainer():void
		{
			_itemsContainer = new Sprite();
			_itemsContainer.x = this._leftSpace;
			_itemsContainer.y = this._topSpace;
			addChild(_itemsContainer);
		}
		
		///创建遮照
		private function createMainMasker():void
		{
			_mainMasker = new Sprite();
			_mainMasker.x = 0;
			_mainMasker.y = 0;
			//防止透明处遮挡住同级的其他元素
			_mainMasker.mouseEnabled = false;
			_mainMasker.mouseChildren = false;
			_mainMasker.graphics.beginFill(0, 1);
			_mainMasker.graphics.drawRect(0, 0, _listWidth, _listHeight);//(0, 0, _listWidth - 4, _listHeight - 4);
			_mainMasker.graphics.endFill();
			addChild(_mainMasker);
			_itemsContainer.mask = _mainMasker;
		}
		
		///刷新显示层
		private function freshView():void
		{
			//先清空容器
			while (_itemsContainer.numChildren > 0)
			{
				_itemsContainer.removeChildAt(0);
			}
			
			//恢复到初始位置
			scrollList(0);
			
			//元素容器的宽和高（因为装载了flash内制组件的元素的高是不准确的，所以需要重新计算）
			var ItemContainerWidth:Number = 0;
			var ItemContainerHeight:Number = 0;
			
			//竖向（无限延伸）排列时的元素排列规则
			if (_vArrage)
			{
				for each(var item:DisplayObject in _dataArray)
				{
					var index:int = _dataArray.indexOf(item);
					item.x = Number((index % _columns) * ((_dataArray[0] as DisplayObject).width + _columnSpace));
					item.y = Number((Math.floor(index / _columns)) * (item.height + _rowSpace));
					_itemsContainer.addChild(item);
					
					ItemContainerWidth += item.width+_columnSpace;
					ItemContainerHeight += item.height + _rowSpace;
				}
				_rows = Math.ceil(_dataArray.length / _columns);
			}
			//横向（无限延伸）排列时的元素排列规则
			else if (!_vArrage)
			{
				for each(var itemH:DisplayObject in _dataArray)
				{
					var indexH:int = _dataArray.indexOf(itemH);
					itemH.x = Number((Math.floor(indexH / _rows)) * ((_dataArray[0] as DisplayObject).width + _columnSpace));
					itemH.y = Number((indexH % _rows) * (itemH.height + _rowSpace));
					_itemsContainer.addChild(itemH);
					
					ItemContainerWidth += itemH.width+_columnSpace;
					ItemContainerHeight += itemH.height + _rowSpace;
				}
				_columns = Math.ceil(_dataArray.length / _rows);
			}
			
			ItemContainerWidth = int(ItemContainerWidth / _dataArray.length) * _columns;
			ItemContainerHeight = int(ItemContainerHeight / _dataArray.length) * _rows;
				
			
			if (_hasVScroll && _vScrollBar)
			{
				if (ItemContainerHeight < _mainMasker.height)
				{
					_vScrollBar.visible = false;
				}
				else
				{
					_vScrollBar.visible = true;
					var barHPercent:Number = _mainMasker.height / ItemContainerHeight;
					_vScrollBar.modifyBarHeight(barHPercent);
					_vScrollBar.modifyBarPosition(0);
				}
				if (_dataArray.length <= 0)
				{
					_vScrollBar.visible = false;
				}
			}
			
			if (_hasHScroll)
			{
				
			}
			
			
		}
		
		///刷新控制器
		private function freshControl():void
		{
			/*if (_dragItem)
			{
				_itemsContainer.addEventListener(MouseEvent.MOUSE_DOWN, onItemsContainerMouseDown_handle);
			}
			_itemsContainer.addEventListener(MouseEvent.CLICK, onItemsContainerClick_handle);*/
			for(var i:int = 0; i < _dataArray.length; i++)
			{	
				(_dataArray[i] as DisplayObject).addEventListener(MouseEvent.CLICK, onItemClick_handle);
				
				if (_dragItem)
				{
					(_dataArray[i] as DisplayObject).addEventListener(MouseEvent.MOUSE_DOWN, onItemMouseDown_handle);
				}
			}
		}
		
		private function removeControl():void
		{
			for(var i:int = 0; i < _dataArray.length; i++)
			{
				if ((_dataArray[i] as DisplayObject).hasEventListener(MouseEvent.CLICK))
				{
					(_dataArray[i] as DisplayObject).removeEventListener(MouseEvent.CLICK, onItemClick_handle);
				}
				
				
				if ((_dataArray[i] as DisplayObject).hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					(_dataArray[i] as DisplayObject).removeEventListener(MouseEvent.MOUSE_DOWN, onItemMouseDown_handle);
				}
				
				if ((_dataArray[i] as DisplayObject).hasEventListener(MouseEvent.ROLL_OVER))
				{
					(_dataArray[i] as DisplayObject).removeEventListener(MouseEvent.ROLL_OVER, onItemRollOverForItemBg_handle);
				}
			}
			
			if (this.hasEventListener(MouseEvent.ROLL_OUT))
			{
				this.removeEventListener(MouseEvent.ROLL_OUT, onListRollOutForItemBg_handle);
			}			
			
			if (_itemSelectedBg)
			{
				if (_itemSelectedBg.hasEventListener(Event.REMOVED_FROM_STAGE))
				{
					_itemSelectedBg.removeEventListener(Event.REMOVED_FROM_STAGE, onItemBgRemovedFromStage_handle);
				}
			}
		}
		
		//=========================================================================================Handle
		///项容器被单击时处理
		private function onItemClick_handle(evt:MouseEvent):void
		{
			var item:DisplayObject = evt.currentTarget as DisplayObject;
			_currentInteractiveItem = item;
			_currentInteractiveItemIndex = _dataArray.indexOf(item);
			trace("YgList.as ____dispatchEvent(new Event(ITEM_CLICK));", "   ItemIndex: ", _currentInteractiveItemIndex);
			
			//冒泡事件
			_currentInteractiveItem.dispatchEvent(new Event(ITEM_CLICK, true));
			
			if (_itemSelectedBg)
			{
				_itemSelectedBg.x = item.x + Number((item.width - _itemSelectedBg.width) / 2);
				_itemSelectedBg.y = item.y + Number((item.height - _itemSelectedBg.height) / 2);
				this._itemsContainer.addChildAt(this._itemSelectedBg , 0);
			}
			
		}
		
		///项容器被按下时处理
		private function onItemMouseDown_handle(evt:MouseEvent):void
		{
			_currentInteractiveItem = evt.currentTarget as DisplayObject;
			_currentInteractiveItemIndex = _dataArray.indexOf(_currentInteractiveItem);
			
			if (this.stage)
			{
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);				
			}
			
		}
		
		///鼠标在stage上移动时处理（只有鼠标按下并移动一次才能触发拖拽）
		private function onStageMouseMove_handle(evt:MouseEvent):void
		{
			if (this.stage) this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
			
			///冒泡事件
			_currentInteractiveItem.dispatchEvent(new Event(ITEM_START_DRAG, true));
			
			if (this.stage)
			{
				this.stage.addEventListener(MouseEvent.MOUSE_UP, dropDrag_handle);
				this.stage.addEventListener(Event.MOUSE_LEAVE, dropDrag_handle);
			}
		}
		
		///放弃拖拽时处理
		private function dropDrag_handle(evt:Event):void
		{
			if (this.stage)
			{
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, dropDrag_handle);
				this.stage.removeEventListener(Event.MOUSE_LEAVE, dropDrag_handle);
			}
			
			dispatchEvent(new Event(ITEM_STOP_DRAG));
		}
		
		///当竖向垂直滚动条滚动时处理
		private function onVScroll_handle(evt:Event):void
		{
			var percent:Number = _vScrollBar.getScrollPercent();
			
			scrollList(percent,0,0,0,1);
		}
		
		//单项鼠标移进时处理
		private function onItemRollOverForItemBg_handle(evt:MouseEvent):void
		{
			_itemsContainer.addChild(_itemBg);
			var item:DisplayObject = evt.currentTarget as DisplayObject;
			
			_itemBg.x = item.x + Number((item.width - _itemBg.width)/2);
			_itemBg.y = item.y + Number((item.height - _itemBg.height)/2);
			
			_itemsContainer.addChild(item);
			_currentInteractiveItem = item;
			_currentInteractiveItemIndex = _dataArray.indexOf(_currentInteractiveItem);
		}
		
		//鼠标移出时处理
		private function onListRollOutForItemBg_handle(evt:MouseEvent):void
		{
			if (_itemsContainer.contains(_itemBg))
			{
				_itemsContainer.removeChild(_itemBg);
			}
		}
		
		//项背景添加进舞台时处理
		private function onItemBgAddedToStage_handle(evt:Event):void
		{
			_itemSelectedBg.addEventListener(Event.REMOVED_FROM_STAGE, onItemBgRemovedFromStage_handle);
		}
		
		//项背景移出舞台时处理
		private function onItemBgRemovedFromStage_handle(evt:Event):void
		{
			_itemSelectedBg.removeEventListener(Event.REMOVED_FROM_STAGE, onItemBgRemovedFromStage_handle);
			if (_itemSelectedBg)
			{
				if(_itemSelectedBg.parent)
				{
					if (_itemSelectedBg.parent.contains(_itemSelectedBg))
					{
						_itemSelectedBg.parent.removeChild(_itemSelectedBg);
					}
				}
			}
			
		}
		
		
		//=========================================================================================API
		override public function get height():Number{ return _mainMasker.height;}
		
		override public function set height(value:Number):void 
		{
			super.height = value;
		}
		
		override public function get width():Number { return _mainMasker.width; }
		
		override public function set width(value:Number):void 
		{
			super.width = value;
		}
		
		///传入数据（array的项为继承DisplayObject的显示对象，建议传入的显示对象为长宽值都一样的元素）
		public function setData(dataArray:Array):void
		{
			removeControl();
			for (var i:int = 0; i < _dataArray.length; i++)
			{
				if (_itemsContainer.contains(_dataArray[i] as DisplayObject))
				{
					_itemsContainer.removeChild(_dataArray[i] as DisplayObject)
					
				}
			}
			_dataArray = dataArray;
			freshView();
			freshControl();
		}
		
		///清空数据和界面
		public function removeData():void
		{
			removeControl();
			for (var i:int = 0; i < _dataArray.length; i++)
			{
				if (_itemsContainer.contains(_dataArray[i] as DisplayObject))
				{
					_itemsContainer.removeChild(_dataArray[i] as DisplayObject)
					
				}
			}
			_dataArray = new Array();
		}
		
		///重新设置界面参数，刷新界面布局
		///重新设置界面参数，刷新界面布局
		public function freshLayoutParameter(listWidth:int, listHeight:int,  columns:int = 1, topSpace:Number = 2 , leftSpace:Number = 2,
		rowSpace:Number = 10, columnSpace:Number = 10 , dragItem:Boolean = false, 
		hasVScroll:Boolean = false, hasHScroll:Boolean = false,
		vArrange:Boolean=true, rows:int=1):void
		{
			_listWidth = listWidth;
			_listHeight = listHeight;
			_columns = columns;
			_topSpace = topSpace ;
			_leftSpace = leftSpace;
			_rowSpace = rowSpace;
			_columnSpace = columnSpace;
			
			_dragItem = dragItem;
			_hasVScroll = hasVScroll;
			_hasHScroll = hasHScroll;
			
			_vArrage = vArrange;
			_rows = rows;
			
			
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, _listWidth, _listHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(0, 0);
			this.graphics.lineStyle(1, 0xffffff,0);
			this.graphics.drawRect(0, 0, _listWidth, _listHeight);
			this.graphics.endFill();
		
		
			///刷新垂直滚动条
		
			///刷新横向滚动条
		
			///刷新项容器			
			_itemsContainer.x = this._leftSpace;
			_itemsContainer.y = this._topSpace;
		
			///刷新遮照
			_mainMasker.x = 0;
			_mainMasker.y = 0;
			_mainMasker.graphics.clear();
			_mainMasker.graphics.beginFill(0, 1);
			_mainMasker.graphics.drawRect(0, 0, _listWidth, _listHeight);
			_mainMasker.graphics.endFill();
			
			freshView();
		}
		
		///设置新滚动条样式（只能使用一次）
		public function addNewScrollBar(VScroll:Boolean, ScrollClassName:String = null):void
		{
			if (VScroll)
			{
				if (!_hasVScroll)
				{
					_hasVScroll = true;
					createVScrollBar(ScrollClassName);
				}
				
			}
			else
			{
				if (!_hasHScroll)
				{
					_hasHScroll = true;
					createHScrollBar(ScrollClassName);
				}
				
			}
		}
		
		///滚动list（从外部控制）。percent是移动的距离占可移动距离的百分比。distance是直接位移的大小。moveItemNum：移动item的个数。使用时三者选一。h_direction是左右方向。v_direction是上下方向（方向不关注数值，只关注正负；负往回，正前进；）		
		public function scrollList(percent:Number=0, distance:Number=0, moveItemNum:int=0, h_direction:int=0, v_direction:int=0):void
		{
			//无数据时执行
			if (_dataArray.length==0)
			{
				_itemsContainer.x = _leftSpace;
				_itemsContainer.y = _topSpace;
				return;
			}
			//
			if (h_direction==v_direction && h_direction==0)
			{
				if (_vArrage)
				{
					h_direction = 0;
					v_direction = 1;
				}
				else
				{
					h_direction = 1;
					v_direction = 0;
				}
			}
			
			
			///滚动方式一，按项的个数滚动
			if (moveItemNum != 0) 
			{
				//横向左右滚动
				if (h_direction != 0)
				{
					if (_itemsContainer.width < _listWidth)
					{
						return;
					}
					if (_itemsContainer.x == _leftSpace)_itemsContainer.x = 0;
					_itemsContainer.x += Number((((_dataArray[0] as DisplayObject).width + _columnSpace) * moveItemNum) * (h_direction / Math.abs(h_direction)));
					
					if (_itemsContainer.x > _leftSpace)
					{
						_itemsContainer.x = _leftSpace;
					}
					if (_itemsContainer.x < _listWidth -_itemsContainer.width)
					{
						_itemsContainer.x = (_listWidth -_itemsContainer.width);
					}
					
				}
				//纵向上下滚动
				if (v_direction != 0)
				{
					if (_itemsContainer.height < _listHeight)
					{
						return;
					}
					if (_itemsContainer.y == _topSpace)_itemsContainer.y = 0;
					_itemsContainer.y += Number((((_dataArray[0] as DisplayObject).height + _rowSpace)* moveItemNum) * (v_direction/Math.abs(v_direction)));
					
					if (_itemsContainer.y > _topSpace)
					{
						_itemsContainer.y = _topSpace;
					}
					if (_itemsContainer.y < _listHeight -_itemsContainer.height)
					{
						_itemsContainer.y = (_listHeight -_itemsContainer.height);
					}
					
				}
				
				return;
			}
			
			
			///滚动方式二，按实际距离滚动
			if (distance != 0)
			{
				//横向左右滚动
				if (h_direction != 0)
				{
					if (_itemsContainer.width < _listWidth)
					{
						return;
					}
					_itemsContainer.x += Number(distance * (h_direction/Math.abs(h_direction)));
					if (_itemsContainer.x > _leftSpace)
					{
						_itemsContainer.x = _leftSpace;
					}
					if (_itemsContainer.x < _listWidth -_itemsContainer.width)
					{
						_itemsContainer.x = (_listWidth -_itemsContainer.width);
					}
				}
				//纵向上下滚动
				if (v_direction != 0)
				{
					if (_itemsContainer.height < _listHeight)
					{
						return;
					}
					_itemsContainer.y += Number(distance * (v_direction/Math.abs(v_direction)));
					if (_itemsContainer.y > _topSpace)
					{
						_itemsContainer.y = _topSpace;
					}
					if (_itemsContainer.y < _listHeight -_itemsContainer.height)
					{
						_itemsContainer.y = (_listHeight -_itemsContainer.height);
					}
				}
				
				return;
			}
			
			///滚动方式三，按百分比滚动
			if (percent >=0 && percent<=1)
			{
				//横向左右滚动
				if (h_direction != 0)
				{
					if (_itemsContainer.width < _listWidth)
					{
						_itemsContainer.x = _leftSpace;
					}
					if (percent < 0.05)
					{
						_itemsContainer.x = _leftSpace;
					}
					else
					{
						_itemsContainer.x = (_listWidth - _itemsContainer.width) * percent + _leftSpace;
					}
				}
				//纵向上下滚动
				if (v_direction != 0)
				{	
					if (_itemsContainer.height < _listHeight)
					{
						_itemsContainer.y = _topSpace;
					}
					if (percent < 0.05)
					{
						_itemsContainer.y = _topSpace;
					}
					else
					{
						_itemsContainer.y = (_listHeight - _itemsContainer.height) * percent + int(_topSpace);
					}
				}				
			}			
			
		}
		
		///获取当前滚动的百分比
		public function getScrolledPercent():Number
		{
			var percent:Number = 0;
			if (_vArrage)
			{
				percent = (_itemsContainer.y - _topSpace) / (_listHeight - _itemsContainer.height);
			}
			else
			{
				percent = (_itemsContainer.x - _leftSpace) / (_listWidth - _itemsContainer.width);
			}
			
			if (percent > 0.98)
			{
				percent = 1;
			}
			
			return percent;			
		}
		
		///获取滚动条显示状态
		public function ScrollBarVisible():Boolean
		{
			if (_vArrage  && _hasVScroll)
			{
				return _vScrollBar.visible;
			}
			
			return false;
		}
		
		///复原滚动位置(v：竖向，h：横向）
		public function RecoverScrollPosition(v:Boolean = true,h:Boolean = false):void
		{
			if (_hasVScroll && v)
			{
				_vScrollBar.modifyBarPosition(0);
				scrollList(0);
			}
			else if (_hasHScroll && h)
			{
				
			}
		}
		
		///设置滚动条位置（按百分比）
		public function ScrollScrollBar(percent:Number):void
		{
			if (percent < 0.05)
			{
				percent = 0;
			}
			
			if (_vArrage)
			{
				if (_hasVScroll)
				{
					_vScrollBar.modifyBarPosition(percent);
				}				
			}
			else
			{
				if (_hasHScroll)
				{
					
				}
			}
			
		}
		
		///获取当前数据长度
		public function getDataLength():Number
		{
			return _dataArray.length;
		}
		
		///获取显示队列
		public function get DataList():Array
		{
			return _dataArray;
		}
		
		///更换一项
		public function addItemByIndex(index:int,item:DisplayObject):void
		{
			if (index > _dataArray.length)
			{
				return;
			}
			removeControl();
			_dataArray.splice(index, 0, item);
			freshView();
			freshControl();
		}
		
		///删除一项
		public function deleteItemByIndex(index:int):void
		{
			if (index >= _dataArray.length)
			{
				return;
			}
			removeControl();
			_dataArray.splice(index, 1);
			freshView();
			freshControl();
		}
		
		///增加一项到列表的末尾
		public function pushItem(item:DisplayObject):void
		{
			removeControl();
			_dataArray.push(item);
			freshView();
			freshControl();
		}
		
		///获取项根据index
		public function getItemByIndex(index:int):DisplayObject
		{
			if (index >= _dataArray.length)
			{
				return null;
			}
			
			var item:DisplayObject = _dataArray[index] as DisplayObject;
			return item as DisplayObject;
		}
		
		
		///获取被交互的项
		public function getBeInteractivedItem():DisplayObject
		{
			return _currentInteractiveItem as DisplayObject;
		}
		
		///获取被交互项的索引
		public function getBeInteractivedItemIndex():int
		{
			return _currentInteractiveItemIndex;
		}
		
		///添加容器内的单项的背景鼠标移进响应
		public function addItemRollOverBg(bg_sp:Sprite):void
		{
			if (_itemBg)
			{
				if (_itemsContainer.parent)
				{
					if (_itemsContainer.parent.contains(_itemBg))
					{
						_itemsContainer.parent.removeChild(_itemBg);
					}
				}				
			}
			
			_itemBg = bg_sp;
			for(var i:int = 0; i < _dataArray.length; i++)
			{	
				(_dataArray[i] as InteractiveObject).addEventListener(MouseEvent.ROLL_OVER, onItemRollOverForItemBg_handle);
				
			}
			this.addEventListener(MouseEvent.ROLL_OUT, onListRollOutForItemBg_handle);
		}
		
		///移除容器内的单项的背景鼠标移进响应
		public function removeItemRollOverBg():void
		{
			for(var i:int = 0; i < _dataArray.length; i++)
			{	
				if ((_dataArray[i] as InteractiveObject).hasEventListener(MouseEvent.ROLL_OVER))
				{
					(_dataArray[i] as InteractiveObject).removeEventListener(MouseEvent.ROLL_OVER, onItemRollOverForItemBg_handle);
				}				
			}
			this.removeEventListener(MouseEvent.ROLL_OUT, onListRollOutForItemBg_handle);
			
			if (_itemBg)
			{
				if (_itemsContainer.parent)
				{
					if (_itemsContainer.parent.contains(_itemBg))
					{
						_itemsContainer.parent.removeChild(_itemBg);
					}
				}				
			}
			
			
		}
		
		///设置Item的单击选中背景 
		public function addItemSelectedBg(itemBg:Sprite):void
		{
			this._itemSelectedBg = itemBg ;
			_itemSelectedBg.addEventListener(Event.REMOVED_FROM_STAGE, onItemBgRemovedFromStage_handle);
			_itemSelectedBg.addEventListener(Event.ADDED_TO_STAGE, onItemBgAddedToStage_handle);
		}
		
		///移除Item的单击选中背景
		public function removeItemSelectedBg():void
		{
			if (_itemSelectedBg)
			{
				if (_itemSelectedBg.hasEventListener(Event.REMOVED_FROM_STAGE))
				{
					_itemSelectedBg.removeEventListener(Event.REMOVED_FROM_STAGE, onItemBgRemovedFromStage_handle);
				}
				if (_itemSelectedBg.hasEventListener(Event.ADDED_TO_STAGE))
				{
					_itemSelectedBg.removeEventListener(Event.ADDED_TO_STAGE, onItemBgAddedToStage_handle);
				}
				
				if (_itemSelectedBg.parent)
				{
					if (_itemSelectedBg.parent.contains(_itemSelectedBg))
					{
						_itemSelectedBg.parent.removeChild(_itemSelectedBg);
					}
				}
				this._itemSelectedBg = null;
			}
			
		}
		
		
		
		/**
		 * 设置Item的单击选中背景 （向下兼容）
		 * @param itemBg
		 * 
		 */		
		/*public function set itemBg(itemBg:Sprite):void
		{
			this._itemSelectedBg = itemBg ;
			_itemSelectedBg.addEventListener(Event.REMOVED_FROM_STAGE, onItemBgRemovedFromStage_handle);
			_itemSelectedBg.addEventListener(Event.ADDED_TO_STAGE, onItemBgAddedToStage_handle);
			
		}
		public function get itemBg():Sprite
		{
			return this._itemSelectedBg ;
		}*/
		
	}

}