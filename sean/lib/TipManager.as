package sean.lib 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...Tip管理类
	 * @author Sean Lee
	 */
	public class TipManager
	{
		private static var TM:TipManager;
		
		//tip整体自身
		private var _tip:Sprite;
		//tip装饰素材容器
		private var _tipFrame:Sprite;
		//tip背景图
		private var _tipBg:Sprite;
		//tip箭头
		private var _tipArrow:Sprite;
		//tip内容（文字或其他显示对象）容器
		private var _tipContent:Sprite;
		
		//tip的目标
		private var _tipTarget:DisplayObject;
		
		private var _textFieldArr:Array;
		private const TextFieldArr_Max_Length:int = 20;
		
		//使用默认样式
		private var _DeFaultStyle:Boolean = true;
		
		//默认文本样式
		private var _defaultTextFormat:TextFormat;
		//自定义文本样式
		private var _userTextFormat:TextFormat;
		
		//使用tip新界面
		private var _newView:Boolean = false;
		private var _newViewClassName:String;
		
		//分割线
		public static const DIVIDE_LINE:String = "---";
		
		private var _startUpStatus:Boolean = false;
		
		public function TipManager() 
		{
			if (TM!=null)
			{
				throw(new Error("Singleton Error !!! TipManager.as"));
			}
			
		}
		
		///获取实例对象
		public static function getIns():TipManager
		{
			if (TM == null)
			{
				TM = new TipManager();
			}
			return TM;
		}
		
		///启动
		public function startUp(DeFaultStyle:Boolean = true):void
		{
			_DeFaultStyle = DeFaultStyle;
			_startUpStatus = true;
			_textFieldArr = new Array();
			
			createGlobalTip();			
			
		}
		
		///打开纯文字tip（支持多行文字）target是tip响应的显示对象，contentArray内项是String
		public function showTip_JustText(target:DisplayObject,contentArray:Array,tipContainer:DisplayObjectContainer,htmlText:Boolean=false, newViewClassName:String = null, textFormat:TextFormat = null):void
		{
			closeTip();
			
			if (newViewClassName)
			{
				_newViewClassName = newViewClassName;
				createNewTextTipView(newViewClassName);
			}
			
			if (textFormat)
			{
				_defaultTextFormat = textFormat;
				_userTextFormat = textFormat;
			}
			
			_tipTarget = target;
			addTargetListener(_tipTarget);
			
			var text_arr:Array = new Array();
			for each(var item:* in contentArray)
			{
				if (item is String)
				{
					text_arr.push(item);
				}
			}
			
			for (var i:int = 0; i < text_arr.length; i++)
			{
				if (i<_textFieldArr.length)
				{
					var txt_h:TextField = (_textFieldArr[i] as TextField);
					
					if (textFormat)
					{
						txt_h.defaultTextFormat = _userTextFormat;
					}
					
					modifySingleTxt(i, txt_h, String(text_arr[i]), htmlText);					
					
				}
				else
				{
					var txt:TextField = getNewTextFieldForTip();
					
					modifySingleTxt(i, txt, String(text_arr[i]), htmlText);					
					
					_textFieldArr.push(txt);
				}
			}
			
			modifyLayOut();
			tipContainer.addChild(_tip);
			modifyTipCoordinate(_tipTarget.stage.mouseX, _tipTarget.stage.mouseY);
		}
		
		//设置单个文本内容和属性
		private function modifySingleTxt(index:int, txt:TextField, contentStr:String, htmlText:Boolean):void
		{
			if (htmlText)
			{
				txt.htmlText = contentStr;
			}
			else 
			{
				txt.text = contentStr;
			}
			txt.width = txt.textWidth + 5;
			txt.height = txt.textHeight + 3;
			_tipContent.addChild(txt);
			txt.y = index * (txt.height + 2);
			txt.x = 0;
		}
		
		
		///打开纯显示对象tip（支持多显示对象）target是tip响应的显示对象，contentArray内项是DisplayObject,vertical表示排列方式默认是竖着
		public function showTip_JustDisObj(target:DisplayObject,contentArray:Array,tipContainer:DisplayObjectContainer,vertical:Boolean = true):void
		{
			closeTip();
			
			_tipTarget = target;
			addTargetListener(_tipTarget);
			var disObj_arr:Array = new Array();
			for each(var item:* in contentArray)
			{
				if (item is DisplayObject)
				{
					disObj_arr.push(item);
				}
			}
			
			for (var i:int = 0; i < disObj_arr.length; i++)
			{
				var disObj:DisplayObject = disObj_arr[i] as DisplayObject;
				
				var distanceX:Number = 0;
				var distanceY:Number = 0;
				if (i > 0)
				{
					var lastDO:DisplayObject = disObj_arr[(i - 1)] as DisplayObject;
					distanceX = lastDO.x + lastDO.width + 5;
					distanceY = lastDO.y + lastDO.height + 5;
				}
				
				if (vertical)
				{
					disObj.x = 0;
					disObj.y = distanceY;					
				}
				else 
				{
					disObj.x = distanceX;
					disObj.y = 0;
				}
				
				_tipContent.addChild(disObj);
			}
			
			modifyLayOut();			
			tipContainer.addChild(_tip);
			modifyTipCoordinate(_tipTarget.stage.mouseX, _tipTarget.stage.mouseY);
		}
		
		///关闭tip显示
		public function closeTip():void
		{
			checkStartUP();
			
			while (_tipContent.numChildren > 0)
			{
				_tipContent.removeChildAt(0);
			}
			if (_tip.parent)
			{
				_tip.parent.removeChild(_tip);
			}
			if (_textFieldArr.length > TextFieldArr_Max_Length)
			{
				_textFieldArr.length = 0;
				_textFieldArr = new Array();
			}
			
			if (_newView)
			{
				_newView = false;
				createGlobalTip();
			}
			
			_tipTarget = null;
		}
		
		
		//================================================================================
		//
		private function checkStartUP():void
		{
			if (!_startUpStatus)
			{
				throw(new Error("TipManager Error !!! has no start up !!! 我看你是使用TipManager的时候没有先startUp吧！！！") );
				return;
			}
		}
		
		//创建通用UI的Tip界面
		private function createGlobalTip():void
		{
			_tip = new Sprite();
			_tipContent = new Sprite();
			
			if (_DeFaultStyle)
			{				
				_tipBg = new Sprite();
				
				//默认显示样式				
				_tipBg.graphics.beginFill(0, 1);
				//_tipBg.graphics.drawRect(0, 0, 10, 10);
				_tipBg.graphics.drawRoundRect(0, 0, 10, 10, 5, 5);
				_tipBg.graphics.endFill();
				
				_tip.addChild(_tipBg);
				_tip.addChild(_tipContent);				
			}
			else
			{			
				//使用库内素材作为显示样式
				var TipStuffClass:Class = ApplicationDomain.currentDomain.getDefinition("TipStuff_MC") as Class;
				_tipFrame = new TipStuffClass();
				_tipBg = _tipFrame.getChildByName("bg") as Sprite;
				_tipArrow = _tipFrame.getChildByName("arrow") as Sprite;
				
				_tip.addChild(_tipFrame);				
				_tip.addChild(_tipContent);
			}
			
			_defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			_userTextFormat = new TextFormat("Arial", 12, 0x000000);
			
			_tip.mouseEnabled = false;
			_tip.mouseChildren = false;
			
		}
		
		//创建text类Tip新界面
		private function createNewTextTipView(className:String):void
		{
			_newView = true;
			
			while (_tip.numChildren > 0)
			{
				_tip.removeChildAt(0);
			}
			while (_tipBg.numChildren > 0)
			{
				_tipBg.removeChildAt(0);
			}
			while (_tipContent.numChildren > 0)
			{
				_tipContent.removeChildAt(0);
			}
			
			//使用库内素材作为显示样式
			var TipStuffClass:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
			_tipFrame = new TipStuffClass();
			_tipBg = _tipFrame.getChildByName("bg") as Sprite;
			_tipArrow = _tipFrame.getChildByName("arrow") as Sprite;
			_tipContent = new Sprite();
			
			_tip.addChild(_tipFrame);				
			_tip.addChild(_tipContent);
			
			_defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			_userTextFormat = new TextFormat("Arial", 12, 0x000000);
			
			_tip.mouseEnabled = false;
			_tip.mouseChildren = false;
		}
		
		//调整布局坐标等
		private function modifyLayOut():void
		{			
			//通用UI布局
			if(!_newView)
			{
				if (_DeFaultStyle)
				{
					_tipBg.graphics.clear();
					_tipBg.graphics.beginFill(0, 1);
					_tipBg.graphics.drawRoundRect(0, 0, _tipContent.width + 10, _tipContent.height + 10, 7, 7);
					_tipBg.graphics.endFill();
					_tipContent.x = 5;
					_tipContent.y = 5;
				}
				else
				{
					_tipBg.width = _tipContent.width + 10;
					_tipBg.height = _tipContent.height + 10;
					_tipContent.x = 7;
					_tipContent.y = 5;
				}
			}
			//特殊UI布局
			else if (_newView && _tipArrow)
			{
				_tipBg.width = _tipContent.width + 14;
				_tipBg.height = _tipContent.height + 10;
				
				_tipArrow.x = 0;
				_tipArrow.y = 0;
				_tipBg.x = -_tipBg.width / 2;
				_tipBg.y = -(_tipArrow.height + _tipBg.height) + 5;
				_tipContent.x = _tipBg.x + 7;
				_tipContent.y = _tipBg.y + 5;
			}
			
			
		}
		
		//调整Tip在容器内的坐标
		private function modifyTipCoordinate(mouse_x:Number,mouse_y:Number):void
		{
			//特殊UI坐标
			if (_newView && _tipArrow)
			{			
				_tip.x = mouse_x;
				_tip.y = mouse_y;
				return;
			}
			
			//通用UI坐标
			_tip.x = mouse_x + 10;
			_tip.y = mouse_y + 22;
			if (_tip.stage)
			{
				if ((_tip.x + _tip.width) > _tip.stage.stageWidth)
				{
					_tip.x = mouse_x - _tip.width;
				}
				if ((_tip.y + _tip.height) > _tip.stage.stageHeight)
				{
					_tip.y = mouse_y - _tip.height;
				}
			}
		}
		
		//
		private function addTargetListener(target:DisplayObject):void
		{
			target.addEventListener(MouseEvent.ROLL_OUT, onTargetRollOut_handle);
			target.addEventListener(MouseEvent.MOUSE_MOVE, onTargetMouseMove_handle);
			
			if (target.stage)
			{
				target.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave_handle);
			}
		}
		
		//
		private function getNewTextFieldForTip():TextField
		{
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.border = false;
			txt.multiline = false;
			txt.wordWrap = false;
			if (_DeFaultStyle)
			{
				txt.defaultTextFormat = _defaultTextFormat;
			}
			else
			{
				txt.defaultTextFormat = _userTextFormat;
			}
			
			
			return txt;
		}
		
		//================================================================================Handle
		//
		private function onTargetRollOut_handle(evt:MouseEvent):void
		{
			if (_tipTarget)
			{
				_tipTarget.removeEventListener(MouseEvent.ROLL_OUT, onTargetRollOut_handle);
				_tipTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onTargetMouseMove_handle);
				if (_tipTarget.stage)
				{
					_tipTarget.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave_handle);
				}
			}
			closeTip();
		}
		
		//
		private function onStageMouseLeave_handle(evt:Event):void
		{
			if (_tipTarget)
			{
				_tipTarget.removeEventListener(MouseEvent.ROLL_OUT, onTargetRollOut_handle);
				_tipTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onTargetMouseMove_handle);
				if (_tipTarget.stage)
				{
					_tipTarget.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave_handle);
				}
			}
			closeTip();
		}
		
		//
		private function onTargetMouseMove_handle(evt:MouseEvent):void
		{
			modifyTipCoordinate(evt.stageX, evt.stageY);
			evt.updateAfterEvent();
		}
		
		
	}

	}