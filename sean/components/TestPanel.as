package sean.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import proj.model.Model;
	import proj.model.vo.*;
	/**
	 * ...
	 * @author 罗单可
	 */
	public class TestPanel extends Sprite
	{
		private var testButtonArray:Array;
		private var currentY:Number = 20;
		private var back:Sprite;
		private var buttonContainer:Sprite;
		
		public function TestPanel() 
		{
			initView();
		}
		
		private function initButtons():void
		{
			addTestButton("更新上传图片列表数据");
		}
		
		
		
		private function initView():void
		{	
			var testSP:Sprite = new Sprite();
			addChild(testSP);
			var testTF:TextField = new TextField();
			testTF.selectable = false;
			testTF.autoSize = TextFieldAutoSize.LEFT;
			testTF.text = "测试面板";
			testSP.addChild(testTF);
			testSP.mouseChildren = false;
			testSP.buttonMode = true;		
			testSP.addEventListener(MouseEvent.CLICK, clickTestTFHandler);
			testButtonArray = new Array();
			buttonContainer = new Sprite();
			initButtons();
		}
		
		private function addTestButton(bName:String):void
		{
			visible = true;
			var testButton:BaseMCButton = new BaseMCButton(bName);//:BasicButton = new BasicButton(bName);
			testButtonArray.push(testButton);
			testButton.x = 2;
			testButton.y = currentY;
			currentY += testButton.height + 2;
			buttonContainer.addChild(testButton);
			testButton.addEventListener(MouseEvent.CLICK, clickTestButtonHandler);
			
			drawBack();
		}
		
		private function drawBack():void
		{
			if (back)
			{
				removeChild(back);
			}
			back = new Sprite();
			
			back.graphics.beginFill(0xffffff, 0.5);
			back.graphics.lineStyle(1);
			back.graphics.drawRect(0, 0, width + 2, height + 2);
			back.graphics.endFill();
			addChildAt(back,0);
		}
		
		
		//========================================================================Handle
		//
		private function clickTestTFHandler(e:MouseEvent):void 
		{
			if (contains(buttonContainer))
			{
				removeChild(buttonContainer);
			}
			else
			{
				addChild(buttonContainer);
			}
			drawBack();
		}
		
		//
		private function clickTestButtonHandler(e:MouseEvent):void 
		{
			var testButton:BaseMCButton = e.currentTarget as BaseMCButton;
			
			switch (testButton.label) 
			{
				case "更新上传图片列表数据":			
				
				break;	
				
			}
			
			clickTestTFHandler(null);
		}
		
	}

}

/*import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.filters.BevelFilter;
	import flash.text.TextFieldAutoSize;
	
	class BasicButton extends SimpleButton {
		
		private var _label:String;
		private var _upLabel:TextField;
		private var _overLabel:TextField;
		private var _downLabel:TextField;
		private var _up:Sprite;
		private var _over:Sprite;
		private var _down:Sprite;
		private var _hit:Sprite;
		
		public function set label(value:String):void {
			_label = value;
			draw();
		}
		
		public function get label():String { return _label; }
		
		public function BasicButton(label:String) {
			
			_label = label;
			
			_upLabel = new TextField();
			_up = new Sprite();
			_overLabel = new TextField();
			_downLabel = new TextField();
			_down = new Sprite();
			_hit = new Sprite();
			_over = new Sprite();
			
			_upLabel.autoSize = TextFieldAutoSize.LEFT;
			_overLabel.autoSize = TextFieldAutoSize.LEFT;
			_overLabel.textColor = 0xCCCCCC;
			_downLabel.autoSize = TextFieldAutoSize.LEFT;
			
			upState = _up;
			downState = _down;
			overState = _over;
			hitTestState = _hit;
			useHandCursor = true;
			
			draw();
			
		}
		
		private function draw():void {
			
			_upLabel.text = _label;
			_up.graphics.clear();
			_up.graphics.lineStyle();
			_up.graphics.beginFill(0xFFFFFF, 100);
			_up.graphics.drawRect(0, 0, _upLabel.width + 2, _upLabel.height + 2);
			_up.graphics.endFill();
			_up.filters = [new BevelFilter()];
			_up.addChild(_upLabel);
			
			_overLabel.text = _label;
			_over.graphics.clear();
			_over.graphics.lineStyle();
			_over.graphics.beginFill(0xFFFFFF, 100);
			_over.graphics.drawRect(0, 0, _overLabel.width + 2, _overLabel.height + 2);
			_over.graphics.endFill();
			_over.filters = [new BevelFilter()];
			_over.addChild(_overLabel);
			
			_downLabel.text = _label;
			_down.graphics.clear();
			_down.graphics.lineStyle();
			_down.graphics.beginFill(0xFFFFFF, 100);
			_down.graphics.drawRect(0, 0, _overLabel.width + 2, _overLabel.height + 2);
			_down.graphics.endFill();
			_down.filters = [new BevelFilter(4, 225)];
			_down.addChild(_downLabel);
			_downLabel.x = 2;
			_downLabel.y = 2;
			
			_hit.graphics.clear();
			_hit.graphics.lineStyle();
			_hit.graphics.beginFill(0xFFFFFF, 100);
			_hit.graphics.drawRect(0, 0, _up.width, _up.height);
			_hit.graphics.endFill();
		}
		
		
		
	}*/