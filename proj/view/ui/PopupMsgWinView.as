package proj.view.ui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import proj.control.GlobalEventDispatcher;
	import proj.events.EventConfig;
	import proj.view.MrPopupWinManager;
	import sean.components.BaseHasMCSprite;
	import sean.components.BaseMCButton;
	import sean.mvc.events.GlobalEvent;
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class PopupMsgWinView extends BaseHasMCSprite
	{
		
		private var _okBtn:BaseMCButton;
		private var _cancelBtn:BaseMCButton;
		private var _textField:TextField;
		private var _closeBtn:BaseMCButton;
		
		public function PopupMsgWinView() 
		{
			super("PopupMsgWin_MC");
		}
		
		override protected function supplementInitView():void 
		{
			super.supplementInitView();
			
			_okBtn = new BaseMCButton("确定","BaseBtn1_MC");
			//_okBtn.x = 100;
			//_okBtn.y = 170;
			_okBtn.setTextFormat(new TextFormat("Arial", 14, 0xffffff));
			_cancelBtn = new BaseMCButton("取消","BaseBtn1_MC");
			//_cancelBtn.x = 200;
			//_cancelBtn.y = 170;
			_cancelBtn.setTextFormat(new TextFormat("Arial", 14, 0xffffff));
			_textField = super.getStuffMC().getChildByName("content_txt") as TextField;
			_textField.selectable = false;
			_textField.defaultTextFormat = new TextFormat("Arial", 14, 0xffffff);
			//var closeBtnMC:MovieClip = super.getStuffMC().getChildByName("closeBtn_mc") as MovieClip;
			//_closeBtn = new BaseMCButton(null, null, closeBtnMC);
			
			//addChild(_okBtn);
			//addChild(_cancelBtn);
			//addChild(_closeBtn);
			
			_okBtn.addEventListener(MouseEvent.CLICK, onOKBtnClick_handle);
			_cancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClick_handle);
			//_closeBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClick_handle);
		}
		
		///设置文本内容，type表示相应类型，1为只有“确定”，2为“确定”与“取消”都有
		public function setContentText(text:String,html:Boolean = false,type:int = 1):void
		{
			if (html)
			{
				_textField.text = "";
				_textField.htmlText = text;
			}
			else
			{
				_textField.text = "";
				_textField.text = text;
			}
			
			var tf:TextFormat;
			if (_textField.numLines == 1)
			{
				tf = _textField.getTextFormat();
				tf.align = TextFormatAlign.CENTER;
			}
			else
			{
				tf = _textField.getTextFormat();
				tf.align = TextFormatAlign.LEFT;
			}
			_textField.setTextFormat(tf);
			
			switch(type)
			{
				case 1:
				if (contains(_cancelBtn))
				{
					removeChild(_cancelBtn)
				}
				_okBtn.x = int((this.width - _okBtn.width) / 2);
				_okBtn.y = _textField.y + _textField.height + 10;
				addChild(_okBtn);
				break;
				
				case 2:
				_okBtn.x = int((this.width - (_okBtn.width+_cancelBtn.width+50)) / 2);
				_okBtn.y = _textField.y + _textField.height + 10;
				_cancelBtn.x = _okBtn.x + _okBtn.width + 50;
				_cancelBtn.y = _okBtn.y;
				addChild(_okBtn);
				addChild(_cancelBtn);
				break;
			}
		}
		
		//=================================================================================Handle
		//单击确定
		private function onOKBtnClick_handle(evt:MouseEvent):void
		{
			MrPopupWinManager.getIns().closeCurrentPopupWin();
			//派发事件
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(EventConfig.POPUP_MSG_WIN_OK_HANDLE));
		}
		
		//单击取消
		private function onCancelBtnClick_handle(evt:MouseEvent):void
		{
			MrPopupWinManager.getIns().closeCurrentPopupWin();
			//派发事件
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(EventConfig.POPUP_MSG_WIN_CANCEL_HANDLE));
		}
		
	}

}