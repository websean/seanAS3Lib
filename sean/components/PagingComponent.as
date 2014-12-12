package sean.components 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import sean.components.interfaces.IPagingComponent;
	
	/**
	 * 2012-10-31
	 * @author 蒋坚
	 * 分页组件
	 */
	public class PagingComponent extends EventDispatcher implements IPagingComponent 
	{
		//切换页面事件
		public static var CHANGE_PAGE_EVENT:String = "CHANGE_PAGE_EVENT";
		
		///每页显示数
		private var _eachPageNum:int = 0;
		///当前页数
		private var _currentPage:int = 1;
		///总页数
		private var _totalPage:int = 0;
		
		//总记录条数
		private var _totalNum:int = 0;
		//上一页按钮
		private var _preBtn:BaseMCButton;
		//下一页按钮
		private var _nextBtn:BaseMCButton;
		
		public function PagingComponent() 
		{
			
		}
		
		///初始化组件（eachPageNum：每页显示数；pBtn：上一页按钮；nBtn：下一页按钮；）
		public function initComponent(eachPageNum:int, pBtn:BaseMCButton, nBtn:BaseMCButton):void
		{
			_eachPageNum = eachPageNum;
			_preBtn = pBtn;
			_nextBtn = nBtn; 
			
			/*_preBtn.SetStatus(false);
			_nextBtn.SetStatus(false);*/
		}
		
		///设置数据（currPageNum：当前页/从1开始；totalValue：总条数）
		public function setData(currPageNum:int, totalValue:int):void
		{
			total = totalValue;
			currentPage = currPageNum;
			
			dealBtnState();
		}
		
		///下一页
		public function nextPage(evt:MouseEvent):void
		{
			if (_currentPage < _totalPage)
			{
				currentPage = _currentPage + 1 ;
				dealBtnState() ;
			}
		}
		
		///上一页
		public function prePage(evt:MouseEvent):void
		{
			if (_currentPage > 1)
			{
				currentPage = _currentPage - 1 ;
				dealBtnState() ;
			}
		}
		
		///根据当前页面情况显示按钮状态---待补充
		public function dealBtnState():void
		{
			_preBtn.addEventListener(MouseEvent.CLICK , prePage) ;
			_nextBtn.addEventListener(MouseEvent.CLICK , nextPage) ;
			
			if (_totalPage < 2)
			{
				_preBtn.SetStatus(false) ;
				_nextBtn.SetStatus(false) ;
				
				_preBtn.removeEventListener(MouseEvent.CLICK , prePage) ;
				_nextBtn.removeEventListener(MouseEvent.CLICK , nextPage) ;
			}
			else
			{
				if (_currentPage == 1)
				{
					_preBtn.SetStatus(false) ;
					_nextBtn.SetStatus(true) ;
					_preBtn.removeEventListener(MouseEvent.CLICK , prePage) ;
					_nextBtn.addEventListener(MouseEvent.CLICK , nextPage) ;
				}
				else if (_currentPage == _totalPage)
				{
					_preBtn.SetStatus(true) ;
					_nextBtn.SetStatus(false) ;
					_preBtn.addEventListener(MouseEvent.CLICK , prePage) ;
					_nextBtn.removeEventListener(MouseEvent.CLICK , nextPage) ;
				}
				else
				{
					_preBtn.SetStatus(true) ;
					_nextBtn.SetStatus(true) ;
					
					_preBtn.addEventListener(MouseEvent.CLICK , prePage) ;
					_nextBtn.addEventListener(MouseEvent.CLICK , nextPage) ;
				}
			}
		}
		
		
		public function get pageNum():int 
		{
			return _eachPageNum;
		}
		
		public function set pageNum(value:int):void 
		{
			_eachPageNum = value;
		}
		
		public function get currentPage():int 
		{
			return _currentPage;
		}
		
		public function set currentPage(value:int):void 
		{
			_currentPage = value;
			
			if(_currentPage > _totalPage)
			{
				_currentPage = _totalPage;
			}
			
			if (_currentPage < 1)
			{
				_currentPage = 1;
			}
			
			dispatchEvent(new Event(CHANGE_PAGE_EVENT)) ;
		}
		
		public function get totalPageNum():int 
		{
			return _totalPage;
		}
		
		public function set totalPageNum(value:int):void 
		{
			_totalPage = value;
		}
		
		/*public function get preBtn():base 
		{
			return _preBtn;
		}
		
		public function set preBtn(value:BaseHasMCSprite):void 
		{
			_preBtn = value;
		}
		
		public function get nextBtn():BaseHasMCSprite 
		{
			return _nextBtn;
		}
		
		public function set nextBtn(value:BaseHasMCSprite):void 
		{
			_nextBtn = value;
		}*/
		
		public function get total():int 
		{
			return _totalNum;
		}
		
		public function set total(value:int):void 
		{
			_totalNum = value;
			
			/*if (_totalNum % pageNum == 0)
			{
				_totalPage = int(_totalNum / pageNum) ;
			}
			else
			{
				_totalPage = int(_totalNum / pageNum) + 1 ;
			}*/
			
			_totalPage = Math.ceil(_totalNum / _eachPageNum);
		}
		
		///销毁自己
		public function bombSelf():void 
		{
			_currentPage = 1;
			_totalPage = 0;
			_eachPageNum = 0;
			_preBtn.SetStatus(false);
			_nextBtn.SetStatus(false);
			
			_preBtn.removeEventListener(MouseEvent.CLICK, prePage);
			_nextBtn.removeEventListener(MouseEvent.CLICK, nextPage);
			
			/*_preBtn = null;
			_nextBtn = null;*/
		}
		
		///设置当前页面
		public function setCurrentPage(page:int):void
		{
			if (page != _currentPage)
			{
				currentPage = page ;
				dealBtnState() ;
			}
		}
	}

}