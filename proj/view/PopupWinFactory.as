package proj.view 
{
	
	/**弹出框界面管理工厂类
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import proj.view.ui.PopupMsgWinView;
	
	public class PopupWinFactory 
	{
		private static var PWF:PopupWinFactory;
		
		private var _winList:Array;
		
		private var _currentWinType:int;
		
		public function PopupWinFactory(element:SingletonForPopupWinFactory) 
		{
			if (PWF != null)
			{
				throw(new Error("Singleton Error !!!   PopupWinFactory.as"));
			}
			
			initWinList();
		}
		
		public static function getIns():PopupWinFactory
		{
			if (PWF == null)
			{
				PWF = new PopupWinFactory(new SingletonForPopupWinFactory());
			}
			
			return PWF;
		}
		
		public function GetWinInstance(winType:int):Sprite
		{
			var win:Sprite;
			_currentWinType = winType;
			switch(winType)
			{
				case Win_Type_Test_Win:
					win = initWin(PopupMsgWinView);
					break;
					
					
				default:
					break;
			}
			
			return win;
		}
		
		//定时清理窗口队列
		public function ClearWinListOnTime():void
		{
			initWinList();
		}
		
		//初始化窗口队里数组
		private function initWinList():void
		{
			if (_winList)
			{
				while (_winList.length > 0)
				{
					_winList.pop();
				}
			}
			else
			{
				_winList = new Array();
			}
			
		}
		
		//检查某类型界面是否在队列中存在
		private function checkClassInList(ViewClass:Class):Sprite
		{
			var v:Sprite;
			for each(var view:Sprite in _winList)
			{
				if (view is ViewClass)
				{
					v = view;
					break;
				}
			}
			
			return v;
		}
		
		//初始化界面
		private function initWin(ViewClass:Class, hasDefinition_CheckName:String = null):Sprite
		{
			var view:Sprite = checkClassInList(ViewClass);
			
			if (!view)
			{
				//无类检查
				/*if (hasDefinition_CheckName)
				{
					var hasClass:Boolean = ApplicationDomain.currentDomain.hasDefinition(hasDefinition_CheckName);
					if (!hasClass)
					{
						var data:Object = new Object();
						data["winType"] = _currentWinType;
						data["className"] = hasDefinition_CheckName
						GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(EventConfig.ASK_LOAD_STUFF_FOR_VIEW, data));
						return null;
					}
				}*/
				
				view = new ViewClass;
				
				_winList.push(view);
			}
			return view;
		}
		
		//======================================================================Win Type
		//
		public static const Win_Type_Test_Win:int = 1000;
		
		
	}

}


class SingletonForPopupWinFactory
{
	
}