package proj.view 
{
	
	
	/**
	 * ...弹出框管理器
	 * @author Sean Lee
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BlurFilter;
	import proj.view.ui.PopupMsgWinView;
	import sean.components.BaseHasMCSprite;
	import sean.components.PopupMsgTxtWin;
	import sean.mvc.patterns.Mediator;
	
	public class MrPopupWinManager extends Mediator
	{
		
		private static var PWM:MrPopupWinManager;

		public static const EVENT_CHECK_POPUPWIN_LIST:String = "EVENT_CHECK_POPUPWIN_LIST";
		//弹出框排队列表
		private var _popupWinList:Array;
		private const PopupWinListMaxLength:Number = 50;
		
		private var _popupWinContainer:Sprite;
		private var _stage:Stage;
		//当前窗体
		private var _currentWin:Sprite;
		//模糊背景
		private var _coverBg:Sprite;
		
		///弹出框显示对象=====
		//提示框
		private var _popupMsgWin:PopupMsgWinView;
		//文本提示
		private var _txtPopup:PopupMsgTxtWin;
		
		///弹出框类型====
		///商店
		public static const Win_Type_Main_Store:int = 1;
		
		
		public function MrPopupWinManager() 
		{
			super();
			if (PWM != null)
			{
				throw(new Error("Singleton Error !!! MrPopupWinManager.as"));
			}
			
			
		}
		
		public static function getIns():MrPopupWinManager
		{
			if (PWM == null)
			{
				PWM = new MrPopupWinManager();
			}
			return PWM;
		}
		
		public function startUp():void
		{
			init();
		}
		
		///注册管理对象
		override public function register(target:DisplayObject):void 
		{
			super.register(target);
			
			_popupWinContainer = target as Sprite;
			_stage = _popupWinContainer.stage;
			if (!_stage)
			{
				throw(new Error("has no stage error !!! MrPopupWinManager.as"));
			}
		}

		//推送一个排队弹出框进列表
		public function pushPopupWinInList(Type:String, Single:Boolean = true):void
		{
			if (!_popupWinList)
			{
				return;
			}
			if (_popupWinList.length > PopupWinListMaxLength)
			{
				return;
			}
			_popupWinList.push( {type:Type, single:Single} );
		}
		
		public static const MsgWinShow_Type_A:int = 1;
		public static const MsgWinShow_Type_AB:int = 2;
		///弹出消息（信息）提示框,type表示相应类型，1为只有“确定”，2为“确定”与“取消”都有
		public function popupMessageWin(content:String,html:Boolean = false, type:int = 1):void
		{
			popupWin(_popupMsgWin, false);
			_popupMsgWin.setContentText(content, html, type);
		}
		
		///弹出文本提示
		public function popupMsgTxt(txt:String):void
		{
			_stage.addChild(_txtPopup);
			_txtPopup.popupTxt(txt);
		}
		
		///弹出消息（复杂显示内容）提示框
		public function popupMegObjWin(content:DisplayObject):void
		{
			
		}
		
		///弹出对话窗体
		public function popupWinByType(winType:int, Single:Boolean = true):void
		{
			var win:Sprite = PopupWinFactory.getIns().GetWinInstance(winType);
			if (!win)
			{
				return;
			}
			popupWin(win, Single);
			
		}
		
		//关闭所有窗体
		public function closeAllPopupWin():void
		{
			while (_popupWinContainer.numChildren > 0)
			{
				_popupWinContainer.removeChildAt(0);
			}
			this.dispatchEvent(new Event(MrPopupWinManager.EVENT_CHECK_POPUPWIN_LIST));
		}
		
		//关闭当前窗体
		public function closeCurrentPopupWin():void
		{
			if (_popupWinContainer.contains(_currentWin))
			{
				_popupWinContainer.removeChild(_currentWin);
			}
			if (_popupWinContainer.numChildren == 1)
			{
				_popupWinContainer.removeChildAt(0);
			}
			else if (_popupWinContainer.numChildren > 1)
			{
				_popupWinContainer.addChildAt(_coverBg, _popupWinContainer.numChildren - 2);
				_currentWin = _popupWinContainer.getChildAt(_popupWinContainer.numChildren - 1) as Sprite;
			}
			this.dispatchEvent(new Event(MrPopupWinManager.EVENT_CHECK_POPUPWIN_LIST));
		}
		
		///关闭指定窗体
		public function closeWin(winType:int):void
		{
			var win:Sprite = PopupWinFactory.getIns().GetWinInstance(winType);
			if (!win)
			{
				return;
			}
			if (_popupWinContainer.contains(win))
			{
				_currentWin = win;
				closeCurrentPopupWin();
			}
		}
		
		
		//========================================================================================Private
		//初始化对象
		private function init():void
		{
			_popupWinList = new Array();
			
			_coverBg = new Sprite();
			_coverBg.graphics.beginFill(0xffffff, 0.2);
			_coverBg.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_coverBg.graphics.endFill();
			var filter:BlurFilter = new BlurFilter(4, 4, 3);
			_coverBg.filters = [filter];
			
			
			_popupMsgWin = new PopupMsgWinView();
			_txtPopup = new PopupMsgTxtWin();
			
			this.addEventListener(EVENT_CHECK_POPUPWIN_LIST, onAskToCheckPopupWinList_handle);
			
		}
		
		//打开窗体
		private function popupWin(win:Sprite, Single:Boolean=true):void
		{
			_currentWin = win;
			if (Single)
			{
				closeAllPopupWin();				
			}
			_popupWinContainer.addChild(_coverBg);
			win.x = int((_stage.stageWidth - win.width) / 2);
			win.y = int((_stage.stageHeight - win.height) / 2);
			_popupWinContainer.addChild(win);
		}
		
		
		//========================================================================================Handle
		//
		private function onAskToCheckPopupWinList_handle(evt:Event):void
		{
			if (_popupWinList.length > 0)
			{
				var obj:Object = _popupWinList.shift();
				popupWinByType(obj["type"], obj["single"]);
			}
		}
		
	}

}