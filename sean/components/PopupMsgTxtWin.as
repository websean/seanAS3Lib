package sean.components
{
	
	
	/**弹出的文字提示栏
	 * ...
	 * @author Sean Lee
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import gs.TweenLite;
	import sean.utils.SeanUtils;
	
	public class PopupMsgTxtWin extends Sprite
	{
		private var _txt:TextField;
		
		private var _stayTimer:Timer;
		
		private var StageWidth:Number = 600;
		private var StageHeight:Number = 500;
		
		public function PopupMsgTxtWin() 
		{
			initView();
			initControl();
		}
		
		///设置提示的文本内容
		public function popupTxt(txt:String,html:Boolean = false):void
		{
			_stayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onStayTimeComplete_handle);
			_stayTimer.reset();
			
			_txt.text = txt;
			
			_txt.width = _txt.textWidth + 3;
			_txt.height = _txt.textHeight + 3;
			
			_txt.x = (StageWidth - _txt.width) / 2;
			_txt.y = (StageHeight - _txt.height) / 2;
			
			_txt.alpha = 1;
			
			TweenLite.from(_txt, 1, { y:(_txt.y + 100 ), onComplete:onFinishShowTween_handle } );
			
			
		}
		
		//初始化视图
		private function initView():void
		{
			_txt = new TextField();
			_txt.selectable = false;
			_txt.wordWrap = false;
			_txt.defaultTextFormat = new TextFormat("Arial", 30, 0xff0000, true);
			
			_txt.filters = [new GlowFilter(0x000000)];
			
			addChild(_txt);
		}
		
		//初始化控制
		private function initControl():void
		{
			_stayTimer = new Timer(2000, 1);
			addEventListener(Event.ADDED_TO_STAGE, initStageData_handle);
		}
		
		//================================================================================================================Handle
		//文本显示动作完成时处理
		private function onFinishShowTween_handle():void
		{
			_stayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onStayTimeComplete_handle);
			_stayTimer.start();
			
		}
		
		//文本停留时间结束时处理
		private function onStayTimeComplete_handle(evt:TimerEvent):void
		{
			_stayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onStayTimeComplete_handle);
			_stayTimer.stop();
			
			TweenLite.to(_txt, 1, { y:(_txt.y - 100) , alpha:0, onComplete:onFinishRemoveTween_handle} );
		}
		
		//文本移走动作结束时处理
		private function onFinishRemoveTween_handle():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		//初始化场景舞台数据
		private function initStageData_handle(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStageData_handle);
			StageWidth = stage.stageWidth;
			StageHeight = stage.stageHeight;
		}
		
	}

}