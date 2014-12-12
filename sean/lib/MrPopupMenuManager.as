package sean.lib 
{
	
	/**弹出按钮管理类
	 * ...
	 * @author Sean Lee
	 */
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import sean.components.BaseHasMCSprite;
	import sean.mvc.events.GlobalEvent;
	import sean.mvc.patterns.Mediator;
	
	public class MrPopupMenuManager extends Mediator
	{
		
		private static var MPMM:MrPopupMenuManager;
		//对象容器
		private var _container:Sprite;
		//menu视图数组
		private var _menuItemArr:Array;
		
		//Event
		public static const EVENT_MENU_CLICK:String = "PopupMenu_EVENT_MENU_CLICK";
		public static const EVENT_MENU_REMOVE:String = "PopupMenu_EVENT_MENU_REMOVE";
		
		public function MrPopupMenuManager() 
		{
			if (MPMM!=null)
			{
				throw(new Error("Singleton Error!!!  MrPopupMenuManager.as"));
			}
			_menuItemArr = new Array();
		}
		
		public static function getIns():MrPopupMenuManager
		{
			if (MPMM==null)
			{
				MPMM = new MrPopupMenuManager();
			}
			return MPMM;
		}
		
		override public function register(viewComponent:DisplayObject):void 
		{
			super.register(viewComponent);
			_container = viewComponent as Sprite;
		}
		
		///新建弹出按钮
		public function popupMenu(menuLabelList:Array,coordnPoint:Point = null):void
		{
			if (menuLabelList.length>7)
			{
				throw(new Error("长度超出最大限制！！！MrPopupMenuManager.as"));
			}
			
			clearMenus();
			
			if (!coordnPoint)
			{
				coordnPoint = new Point();
			}
			
			for (var i:int = 0; i < menuLabelList.length; i++)
			{
				var label:String = menuLabelList[i];
				if (label == null)
				{
					_menuItemArr.push(null);
					continue;
				}
				
				var menu:BaseHasMCSprite = new BaseHasMCSprite("PopupMenuItem_MC");				
				(menu.getStuffMC().getChildByName("label_txt") as TextField).text = String(menuLabelList[i]);				
				menu.buttonMode =  true;
				menu.mouseChildren = false;
				menu.x = coordnPoint.x;
				if (label != null)
				{
					_menuItemArr.push(menu);
					_container.addChild(menu);
				}
			}
			
			var list:Array = _menuItemArr.concat();
			var newList:Array = new Array();
			while (list.length > 0)
			{
				var item:BaseHasMCSprite = list.shift() as BaseHasMCSprite;
				if (item != null)
				{
					newList.push(item);
				}
			}
			for (var n:int = 0; n < newList.length; n++)
			{
				var menuItem:BaseHasMCSprite = newList[n] as BaseHasMCSprite;
				menuItem.y = coordnPoint.y + menuItem.height * n + 1;
			}
			
			addControl();
			
		}
		
		
		//================================================================================================Private
		//清除所有按钮
		private function clearMenus():void
		{
			for (var i:int = 0; i < _menuItemArr.length; i++)
			{
				if (_menuItemArr[i] == null) continue;
				if (_container.contains(_menuItemArr[i] as BaseHasMCSprite))
				{
					_container.removeChild(_menuItemArr[i] as BaseHasMCSprite)
				}
			}
			while (_menuItemArr.length > 0)
			{
				_menuItemArr.pop();
			}
		}
		
		//添加控制
		private function addControl():void
		{
			_container.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
			_container.addEventListener(MouseEvent.CLICK, onMenusClick_handle);
		}
		
		//移除控制
		private function removeControl():void
		{
			_container.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
			_container.removeEventListener(MouseEvent.CLICK, onMenusClick_handle);
		}
		
		
		//=================================================================================================Handle
		//鼠标在舞台上弹起时处理
		private function onStageMouseUp_handle(evt:MouseEvent):void
		{
			var mouseCDP:Point = new Point(evt.stageX, evt.stageY);
			if (!_container.hitTestPoint(mouseCDP.x,mouseCDP.y))
			{
				clearMenus();
				removeControl();
				//派发事件
				this.dispatchEvent(new GlobalEvent(EVENT_MENU_REMOVE));
			}
		}
		
		//鼠标单击任一按钮时处理
		private function onMenusClick_handle(evt:MouseEvent):void
		{
			var menu:BaseHasMCSprite = evt.target as BaseHasMCSprite;
			var index:int = _menuItemArr.indexOf(menu);
			clearMenus();
			removeControl();
			//派发事件
			this.dispatchEvent(new GlobalEvent(EVENT_MENU_CLICK, index));
		}
		
	}

}