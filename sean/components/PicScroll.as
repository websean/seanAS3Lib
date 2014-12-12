package sean.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import gs.TweenLite;
	import sean.components.BaseHasMCSprite;
	import sean.components.HeadIconView;
	
	/**图形滚动切换控件
	 * ...
	 * @author Sean Lee
	 */
	public class PicScroll extends BaseHasMCSprite
	{
		private var _w:Number;
		private var _h:Number;
		
		private var _bg:Sprite;
		
		private var _picArr:Array;
		
		private var _picContainer:Sprite;
		
		private var _timer:Timer;
		
		private var _masker:Sprite;
		
		//已加载完成的图片数量
		private var _picLoadCount:int = 0;
		//当前滚动到的图片的索引
		private var _scrollCount:int = 0;
		//图片滚动的间隔时间
		private var _scrollTime:Number;
		
		private static const ViewState_Play:int = 0;
		private static const ViewState_Pause:int = 1;
		private var _viewState:int;
		
		public function PicScroll(w:Number, h:Number, BgMCClass:String = null, scrollTime:Number=3000) 
		{
			_w = w;
			_h = h;
			if (scrollTime > 0)
			{
				_scrollTime = scrollTime;
			}
			else
			{
				_scrollTime = 3000;
			}
			
			
			super(BgMCClass);
			
			initControl();
		}
		
		override protected function supplementInitView():void 
		{
			super.supplementInitView();
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0xffffff, 0.5);
			_bg.graphics.drawRect(0, 0, _w, _h);			
			_bg.graphics.endFill();
			
			_masker = new Sprite();
			_masker.graphics.clear();
			_masker.graphics.beginFill(0xffffff, 1);
			_masker.graphics.drawRect(0, 0, _w, _h);			
			_masker.graphics.endFill();
			
			_picContainer = new Sprite();
			_picContainer.mask = _masker;
			
			addChild(_bg);
			addChild(_picContainer);
			addChild(_masker);
			
			_timer = new Timer(_scrollTime);
			_picArr = new Array();
		}
		
		private function initControl():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onThisAddToStage_handle);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
			_timer.addEventListener(TimerEvent.TIMER, onTimer_handle);
		}
		
		public function setData(urlArr:Array, isBitmapDataClass:Boolean = false, isMCClass:Boolean = false):void
		{
			while (_picContainer.numChildren > 0)
			{
				_picContainer.removeChildAt(0);
				
			}
			
			while (_picArr.length > 0)
			{
				var ph:HeadIconView = _picArr.pop() as HeadIconView;
				ph.removeEventListener(HeadIconView.EVENT_IconLoadComplete, onLoadPicComplete_handle);
			}
			
			for each(var url:String in urlArr)
			{
				var picH:HeadIconView = new HeadIconView();
				picH.addEventListener(HeadIconView.EVENT_IconLoadComplete, onLoadPicComplete_handle);
				picH.setData(url, _w, _h, isBitmapDataClass, true, _bg, isMCClass);				
				
				_picArr.push(picH);
			}
		}
		
		public function scrollTo(index:int):void
		{
			scrollPic(_scrollCount, index);
		}
		
		public function PlayScroll():void
		{
			_viewState = ViewState_Play;
			if (!_timer.running)
			{
				_timer.start();
			}			
		}
		
		public function PauseScroll():void
		{
			_viewState = ViewState_Pause;
			if (_timer.running)
			{
				_timer.stop();
			}
		}
		
		public function ScrollToNext():void
		{
			scrollPic(_scrollCount, (_scrollCount + 1));
		}
		
		public function ScrollToPrev():void
		{
			scrollPic(_scrollCount, (_scrollCount - 1));
		}
		
		public function scrollPic(fromIndex:int, toIndex:int):void
		{
			if (toIndex >= _picArr.length)
			{
				toIndex = 0;
			}			
			
			if (fromIndex < 0 || toIndex < 0)
			{
				return;
			}
			if (fromIndex >= _picArr.length)
			{
				return;
			}
			
			var currentPh:HeadIconView = _picArr[fromIndex] as HeadIconView;
			_picContainer.addChild(currentPh);
			
			if (fromIndex == toIndex)
			{
				return;
			}
			
			
			if (_picArr.length > 1)
			{
				_timer.stop();
				
				var nextPh:HeadIconView = _picArr[toIndex] as HeadIconView;
				
				_picContainer.addChild(nextPh);
				nextPh.x = (_bg.width - nextPh.width) / 2;
				if (fromIndex < toIndex || (fromIndex==(_picArr.length-1)&&toIndex==0))
				{
					TweenLite.to(currentPh, 0.5, { x:-currentPh.width, onComplete:onFinishTween, onCompleteParams:[currentPh] } );
					TweenLite.from(nextPh, 0.5, { x:_bg.width} );
				}
				else
				{
					TweenLite.to(currentPh, 0.5, { x:currentPh.width, onComplete:onFinishTween, onCompleteParams:[currentPh] } );
					TweenLite.from(nextPh, 0.5, { x:-_bg.width} );
				}				
				
				_scrollCount = toIndex;
			}
		}
		
		override public function get width():Number { return _w; }
		
		override public function set width(value:Number):void 
		{
			_bg.width = value;
		}
		
		override public function get height():Number { return _h; }
		
		override public function set height(value:Number):void 
		{
			_bg.height = value;
		}
		
		//=============================================================================Handle
		//
		private function onThisAddToStage_handle(evt:Event):void
		{
			PlayScroll();
		}
		
		//
		private function onThisRemoveFromStage_handle(evt:Event):void
		{
			PauseScroll();
			
		}
		
		//
		private function onTimer_handle(evt:TimerEvent):void
		{
			/*var currentPh:HeadIconView = _picArr[_scrollCount] as HeadIconView;
			_picContainer.addChild(currentPh);
			
			if (_picArr.length > 1)
			{
				if (_scrollCount < (_picArr.length - 1))
				{
					_scrollCount ++;
				}
				else
				{
					_scrollCount = 0;
				}
				
				var nextPh:HeadIconView = _picArr[_scrollCount] as HeadIconView;
				
				_picContainer.addChild(nextPh);
				nextPh.x = (_bg.width - nextPh.width) / 2;
				TweenLite.to(currentPh, 0.5, { x:-currentPh.width, onComplete:onFinishTween, onCompleteParams:[currentPh] } );
				TweenLite.from(nextPh, 0.5, { x:_bg.width} );		
				
			}*/
			scrollPic(_scrollCount, (_scrollCount + 1));
		}
		
		
		//
		private function onLoadPicComplete_handle(evt:Event):void
		{
			_picLoadCount ++;
			
			if (_picLoadCount >= _picArr.length)
			{
				_picLoadCount = _picArr.length;
				_scrollCount = 0;
				PlayScroll();
			}
			
			var ph:HeadIconView = evt.currentTarget as HeadIconView;			
			if (ph)
			{
				var index:int = _picArr.indexOf(ph);
				if (index == 0)
				{
					_picContainer.addChild(ph);
				}
				
			}
		}
		
		//
		private function onFinishTween(hv:DisplayObject ):void
		{
			if (_picContainer.contains(hv))
			{
				_picContainer.removeChild(hv)
			}
			
			if (_viewState == ViewState_Play)
			{
				PlayScroll();
			}
		}
		
		
	}

}