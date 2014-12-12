package sean.components 
{
	
	/**选择型按钮组的管理类
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class BaseToggleGroup extends EventDispatcher
	{
		//按钮对象队列
		private var _btnListArr:Array;
		
		private var _interactiveIndex:int = -1;
		
		//单击按钮激活事件
		public static const EVENT_TOGGLE_BTN:String = "EVENT_TOGGLE_BTN";
		
		public function BaseToggleGroup() 
		{
			_btnListArr = new Array();
		}
		
		///设置组队列
		public function setBtnList(arr:Array):void
		{
			while (_btnListArr.length > 0)
			{
				var btn:BaseToggleButton = _btnListArr.pop() as BaseToggleButton;
				if (btn && btn.parent)
				{
					btn.parent.removeChild(btn);
					btn.removeEventListener(MouseEvent.CLICK, onItemClick_handle);
				}
			}
			
			for each(var item:* in arr)
			{
				if (item is BaseToggleButton)
				{
					_btnListArr.push(item);
					(item as BaseToggleButton).addEventListener(MouseEvent.CLICK, onItemClick_handle);
				}
			}
		}
		
		///增加一个对象进组队列
		public function addItemInGroup(item:BaseToggleButton):void
		{
			_btnListArr.push(item);
			item.addEventListener(MouseEvent.CLICK, onItemClick_handle);
		}
		
		///删除一个对象进组队列
		public function deleteItemInGroup(item:BaseToggleButton):void
		{
			var index:int = _btnListArr.indexOf(item);
			if (index >= 0)
			{
				item.removeEventListener(MouseEvent.CLICK, onItemClick_handle);
				_btnListArr.splice(index, 1);
			}
		}
		
		///获取当前交互对象
		public function getInteractiveItem():BaseToggleButton
		{
			return _btnListArr[_interactiveIndex] as BaseToggleButton;
		}
		
		///获取当前交互对象索引
		public function getInteractiveIndex():int
		{
			return _interactiveIndex;
		}
		
		///获取组长度
		public function GetGroupLength():int
		{
			return _btnListArr.length;
		}
		
		///激活某项
		public function toggleBtn(item:BaseToggleButton = null, index:int = 0):void
		{
			if (item)
			{
				var i:int = _btnListArr.indexOf(item);
				if (i >= 0)
				{
					item.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
			else if(index >=0 && index < _btnListArr.length)
			{
				var btn:BaseToggleButton = _btnListArr[index] as BaseToggleButton ;
				if (btn)
				{
					btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}
		
		///获取按钮组项队列
		public function get Group():Array
		{
			return _btnListArr;
		}
		
		
		//=====================================================================================Handle
		//组员被单击时处理
		private function onItemClick_handle(evt:MouseEvent):void
		{
			var currentItem:BaseToggleButton = evt.currentTarget as BaseToggleButton;
			_interactiveIndex = _btnListArr.indexOf(currentItem);
			
			for each(var item:BaseToggleButton in _btnListArr)
			{
				item.SetToggle(false);
			}
			currentItem.SetToggle(true);
			
			dispatchEvent(new Event(EVENT_TOGGLE_BTN));
		}
		
	}

}