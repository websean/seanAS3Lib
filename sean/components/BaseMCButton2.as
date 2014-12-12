package sean.components 
{
	
	
	/**包含MovieClip类型的按钮基类
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import sean.components.BaseHasMCSprite;
	
	public class BaseMCButton2 extends Sprite
	{
		protected var _stuffMC:BaseHasMCSprite;
		protected var _labelText:TextField;
		protected var _label:String;
		
		protected const FRAME_UP:String = "up";
		protected const FRAME_OVER:String = "over";
		protected const FRAME_DOWN:String = "down";
		protected const FRAME_DISABLE:String = "disable";
		
		///构造函数。label：标签文字；stuffClassName：按钮素材类名；button_MC：按钮对象，如果此值不为空，前两项值即可忽略。
		public function BaseMCButton2(Label:String=null, stuffClassName:String=null, button_MC:MovieClip=null) 
		{
			//直接传对象方式
			if (button_MC)
			{
				_stuffMC = new BaseHasMCSprite("");
				_stuffMC.addInStuffMC(button_MC);
				this.addChildAt(_stuffMC, 0);
				initView();
				initControl();
				return;
			}
			
			//新建对象方式
			if (!stuffClassName)
			{
				stuffClassName = "BaseButtonBg_MC";
			}			
			_stuffMC = new BaseHasMCSprite(stuffClassName);				
			_label = Label;
			this.addChild(_stuffMC);
			
			initView();
			initControl();
		}
		
		///设置和获取按钮文本
		public function set label(str:String):void
		{
			_label = str;
			
			modifyLayout();
		}
		public function get label():String
		{
			return _label;
		}
		public function get LabelText():TextField
		{
			return _labelText;
		}
		
		///设置按钮文本样式
		public function setTextFormat(textFormat:TextFormat):void
		{
			_labelText.defaultTextFormat = textFormat;
			modifyLayout();
		}
		
		//设置宽高大小
		public function setSize(w:Number, h:Number):void
		{
			_stuffMC.getStuffMC().width = w;
			_stuffMC.getStuffMC().height = h;
			modifyLayout();
		}
		
		//设置按钮响应状态
		public function SetStatus(status:Boolean):void
		{
			if (status)
			{
				addControl();
				//屏蔽单击事件
				_stuffMC.removeEventListener(MouseEvent.CLICK, onStopClick_handle);
				_stuffMC.getStuffMC().buttonMode = true;
				_stuffMC.getStuffMC().gotoAndStop(FRAME_UP);
			}
			else
			{
				removeControl();
				_stuffMC.addEventListener(MouseEvent.CLICK, onStopClick_handle);
				_stuffMC.getStuffMC().buttonMode = false;
				_stuffMC.getStuffMC().gotoAndStop(FRAME_DISABLE);
			}
			//有可能发生不同帧的图形大小不相等
			modifyLayout();
		}
		
		///规划大小尺寸
		public function LayoutSize(w:Number, h:Number):void
		{
			if(w>0)_stuffMC.getStuffMC().width = w;
			if(h>0)_stuffMC.getStuffMC().width = h;
			
			_labelText.x = int((_stuffMC.getStuffMC().width - _labelText.width) / 2);
			_labelText.y = int((_stuffMC.getStuffMC().height - _labelText.height) / 2);
		}
		
		//初始化界面
		private function initView():void
		{
			_stuffMC.getStuffMC().gotoAndStop(FRAME_UP);
			_stuffMC.getStuffMC().buttonMode = true;
			
			this.x = _stuffMC.x;
			this.y = _stuffMC.y;
			_stuffMC.x = 0;
			_stuffMC.y = 0;
			
			if (label)
			{
				_labelText = new TextField();
				_labelText.mouseEnabled = false;
				_labelText.selectable = false;
				_labelText.multiline = false;
				_labelText.wordWrap = false;
				
				addChild(_labelText);
			}			
			
			modifyLayout();
			
			
		}
		
		//初始化控制
		private function initControl():void
		{
			addControl();
		}
		
		//添加所有监听控制
		protected function addControl():void
		{
			_stuffMC.getStuffMC().addEventListener(MouseEvent.MOUSE_UP, onBtnUp_handle);
			_stuffMC.getStuffMC().addEventListener(MouseEvent.ROLL_OVER, onBtnRollOver_handle);
			_stuffMC.getStuffMC().addEventListener(MouseEvent.ROLL_OUT, onBtnRollOut_handle);
			_stuffMC.getStuffMC().addEventListener(MouseEvent.MOUSE_DOWN, onBtnDown_handle);
		}
		
		//移除所有监听控制
		protected function removeControl():void
		{
			_stuffMC.getStuffMC().removeEventListener(MouseEvent.MOUSE_UP, onBtnUp_handle);
			_stuffMC.getStuffMC().removeEventListener(MouseEvent.ROLL_OVER, onBtnRollOver_handle);
			_stuffMC.getStuffMC().removeEventListener(MouseEvent.ROLL_OUT, onBtnRollOut_handle);
			_stuffMC.getStuffMC().removeEventListener(MouseEvent.MOUSE_DOWN, onBtnDown_handle);
		}
		
		//刷新排板布局
		private function modifyLayout():void
		{
			if (_label)
			{
				_labelText.text = _label;
				_labelText.height = _labelText.textHeight + 3;
				_labelText.width = _labelText.textWidth + 4;
				if (_labelText.width > _stuffMC.getStuffMC().width)
				{
					_stuffMC.getStuffMC().width = _labelText.width + 5;
				}
				if (_labelText.height > _stuffMC.getStuffMC().height)
				{
					_stuffMC.getStuffMC().height = _labelText.height + 5;
				}
				_labelText.x = int((_stuffMC.getStuffMC().width - _labelText.width) / 2);
				_labelText.y = int((_stuffMC.getStuffMC().height - _labelText.height) / 2);
			}
			else
			{
				
			}
			
		}
		private var _hasDown:Boolean = false;
		private var _downTarget:InteractiveObject;
		//============================================================================handle
		//鼠标在响应区弹起
		private function onBtnUp_handle(evt:MouseEvent):void
		{
			if(_hasDown && _downTarget != evt.target)this.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, evt.localX, evt.localY, evt.relatedObject, evt.ctrlKey, evt.altKey, evt.shiftKey, evt.buttonDown, evt.delta));
			_stuffMC.getStuffMC().gotoAndStop(FRAME_OVER);
			this.dispatchEvent(evt);
			_hasDown = false;
			_downTarget = null;
		}
		
		//鼠标在响应区移进
		private function onBtnRollOver_handle(evt:MouseEvent):void
		{
			if(!_hasDown)_stuffMC.getStuffMC().gotoAndStop(FRAME_OVER);
		}
		
		//鼠标在响应区移出
		private function onBtnRollOut_handle(evt:MouseEvent):void
		{
			_stuffMC.getStuffMC().gotoAndStop(FRAME_UP);_hasDown = false;
		}
		
		//鼠标在响应区按下
		private function onBtnDown_handle(evt:MouseEvent):void
		{
			_stuffMC.getStuffMC().gotoAndStop(FRAME_DOWN); _hasDown = true; _downTarget = evt.target as InteractiveObject;
		}
		
		//阻止单击事件流
		private function onStopClick_handle(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
		}
		
	}

}