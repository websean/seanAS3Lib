package sean.lib 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import sean.feature.DragFeature;
	/**调试信息控制器
	 * ...
	 * @author Sean Lee
	 */
	public class Output 
	{
		private static var OP:Output;
		
		private var _bg:Sprite;
		private var _txt:TextField;
		private var _modifyArea:Sprite;
		private var _dragFT:DragFeature;
		private var _modifyFT:DragFeature;
		private var _ct:Sprite;
		private var _container:DisplayObjectContainer;
		
		private static var _sendLC:LocalConnection;
		private static const LC_Adress:String = "sean.lib.OutPut";
		private var _receiveLC:LocalConnection;
		
		private static const Panel_W:Number = 300;
		private static const Panel_H:Number = 300;
		private static const Title:String = "Sean Output Panel Version 1.0.1";
		
		public function Output() 
		{
			if (OP != null)
			{
				throw(new Error("Singleton Error!!! OutPut.as"));
			}
			
			init();
			
		}
		
		//初始化
		private function init():void
		{
			_bg = new Sprite();
			_txt = new TextField();
			_modifyArea = new Sprite();
			_ct = new Sprite();
			_ct.addChild(_bg);
			_ct.addChild(_txt);
			_ct.addChild(_modifyArea);
			
			_bg.graphics.lineStyle(1, 0xffffff, 1);
			_bg.graphics.beginFill(0, 0.7);
			_bg.graphics.drawRoundRectComplex(0, 0, Panel_W, Panel_H, 5, 5, 5, 5);
			_bg.graphics.endFill();
			
			_txt.defaultTextFormat = new TextFormat("Verdana", 14, 0xffffff);
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.mouseEnabled = false;
			_txt.selectable = false;
			_txt.width = 280;
			_txt.height = 280;
			_txt.x = 10;
			_txt.y = 10;
			_txt.text = Title + "\n\n";
			
			_modifyArea.graphics.lineStyle(1, 0, 0.2);
			_modifyArea.graphics.beginFill(0xffffff, 1);
			_modifyArea.graphics.moveTo(0, 0);
			_modifyArea.graphics.lineTo( -30, 0);
			_modifyArea.graphics.lineTo(0, -30);
			_modifyArea.graphics.lineTo(0, 0);
			_modifyArea.graphics.endFill();
			_modifyArea.x = Panel_W - 5;
			_modifyArea.y = Panel_H - 5;
			
			_dragFT = new DragFeature();
			_modifyFT = new DragFeature();			
			
			_receiveLC = new LocalConnection();
		}
		
		public static function getIns():Output
		{
			if (OP == null)
			{
				OP = new Output();
			}
			
			return OP;
		}
		
		///输出字符信息
		public static function log(... args):void
		{
			if (_sendLC == null)
			{
				_sendLC = new LocalConnection();
			}
			
			var content:String = "";
			for each(var d:* in args)
			{
				if ((typeof(d) == "object"))
				{
					content +=  "\n" + String(d) + "{\n";
					for (var i:* in d)
					{
						content += String(i) + "：" +String(d[i]) + "\n";
					}
					content +=  "}\n";
				}
				else
				{
					content += String(d) + "  ";
				}				
			}
			
			content += "\n";
			
			//计算文本字节数
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(content);
			var s:uint = byteArray.length;
			byteArray = null; 
			_sendLC.send(LC_Adress, "OutPutTrace", "*bytes:" + s +"\n");
			
			/* If the data size exceeds 39Kb, use another way instead */
			if (s > 39000)
			{
				return;
			}
			
			_sendLC.send(LC_Adress, "OutPutTrace", content);
		}
		
		///开启
		public function StartUp(ct:DisplayObjectContainer):void
		{
			_container = ct;
		}
		
		///打开面板
		public function Open():void
		{
			if (_container.contains(_ct)) return;
			
			_container.addChild(_ct);
			
			_dragFT.SetPanel(_ct);
			_dragFT.AddDragArea(_bg);
			_dragFT.OpenFeature();
			
			_modifyFT.SetPanel(_modifyArea);
			_modifyFT.AddDragArea(_modifyArea);
			_modifyFT.OpenFeature();
			
			_modifyFT.addEventListener(DragFeature.EVENT_PANEL_POSITION_CHANGED, onModify_handle);
			_ct.addEventListener(MouseEvent.MOUSE_WHEEL, onCTMouseWheel_handle);
			
			_receiveLC.client = this;
			_receiveLC.connect(LC_Adress);			
			
			_txt.text = Title + "\n\n";
		}
		
		///关闭面板
		public function Close():void
		{
			_dragFT.CloseFeatureImmediatelly();
			_modifyFT.CloseFeatureImmediatelly();
			
			if (_container.contains(_ct))
			{
				_container.removeChild(_ct);
			}
			_modifyFT.removeEventListener(DragFeature.EVENT_PANEL_POSITION_CHANGED, onModify_handle);
			_ct.removeEventListener(MouseEvent.MOUSE_WHEEL, onCTMouseWheel_handle);
			_receiveLC.close();
			_txt.text = "";
		}
		
		//输出文本
		public function OutPutTrace(content:String):void
		{
			_txt.appendText(content);
			_txt.scrollV = _txt.maxScrollV;
		}
		
		//=======================================================Handle
		//拖拽时处理
		private function onModify_handle(evt:Event):void
		{
			var w:Number = _modifyArea.x + 5;
			var h:Number = _modifyArea.y + 5;
			
			
			if (w < Panel_W)
			{
				w = Panel_W;
				_modifyArea.x = w - 5;
			}
			if (h < Panel_H)
			{
				h = Panel_H;
				_modifyArea.y = h - 5;
			}
			
			_bg.graphics.clear();
			_bg.graphics.lineStyle(1, 0xffffff, 1);
			_bg.graphics.beginFill(0, 0.7);
			_bg.graphics.drawRoundRectComplex(0, 0, w, h, 5, 5, 5, 5);
			_bg.graphics.endFill();
			
			_txt.width = _bg.width - 10;
			_txt.height = _bg.height - 10;
			
		}
		
		//鼠标滚轴时处理
		private function onCTMouseWheel_handle(evt:MouseEvent):void
		{
			var d:Number = evt.delta;
			var v:int = int(2 * d / Math.abs(d));
			_txt.scrollV -= v;
		}
		
		
	}

}