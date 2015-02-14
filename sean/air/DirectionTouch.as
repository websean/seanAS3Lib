package sean.air
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	
	/*
	移动触摸交互的方向控制器（模拟游戏摇杆）
	
	Sean Lee
	2015.1.19
	*/
	
	public class DirectionTouch extends Sprite
	{
		private var _bgArea:Sprite;
		private var _dragArea:Sprite;
		private var _stage:Stage;
		private var _mouseP:Point;
		private var _keyBoardsValus:Array;
		
		public function DirectionTouch()
		{
			super();
			
			init();
			initListener();
		}
		
		private function init():void
		{
			_keyBoardsValus = new Array();
			
			_bgArea = new Sprite();
			_dragArea = new Sprite();
			
			addChild(_bgArea);
			addChild(_dragArea);
			
			SetSizeAndStyle(100);
		}
		
		private function initListener():void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_handle);
		}
		
		/**
		 *设置尺寸和样式 （默认是圆形摇杆）
		 * @param w 宽度（必要参数）
		 * @param h 高度
		 * @param color 颜色
		 * @param alpha 透明度
		 * 
		 */		
		public function SetSizeAndStyle(w:int, h:int = 0, color:uint = 0xffffff, alpha:Number = 0.5):void
		{
			var c:uint = color;
			var a:Number = alpha
			var r:int = int(w/2);
			_bgArea.graphics.beginFill(c, a);
			_bgArea.graphics.drawCircle(0,0,r);
			_bgArea.graphics.endFill();
			
			_dragArea.graphics.beginFill(c, a);
			_dragArea.graphics.drawCircle(0,0,r-10);
			_dragArea.graphics.endFill();
			
			_bgArea.x = 0;
			_bgArea.y = 0;
			
			_dragArea.x = 0;
			_dragArea.y = 0;
		}
		
		override public function get width():Number
		{
			
			return _bgArea.width;
		}
		
		override public function get height():Number
		{
			
			return _bgArea.height;
		}
		
		//===================================================Handle
		//
		private function onMouseDown_handle(evt:MouseEvent):void
		{
			if(this.stage != null)
			{
				_stage = stage;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
				this.addEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
				this.addEventListener(Event.ENTER_FRAME, onThisMouseMoveEnterFrame_handle);
				evt.stopImmediatePropagation();
			}
		}
		
		//
		private function onStageMouseUp_handle(evt:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
			this.removeEventListener(Event.ENTER_FRAME, onThisMouseMoveEnterFrame_handle);
			_dragArea.x = 0;
			_dragArea.y = 0;
			
			for each(var value:uint in _keyBoardsValus)
			{
				//trace(value);
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,true,false,0,value,0,false,false,false));
			}
			
			
			evt.stopImmediatePropagation();
		}
		
		private function onStageMouseMove_handle(evt:MouseEvent):void			
		{
			var p:Point = new Point(evt.stageX, evt.stageY);
			_mouseP = this.globalToLocal(p);
			
			_dragArea.x = _mouseP.x;
			_dragArea.y = _mouseP.y;
		}
		
		//
		private function onThisRemoveFromStage_handle(evt:Event):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove_handle);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp_handle);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onThisRemoveFromStage_handle);
			this.removeEventListener(Event.ENTER_FRAME, onThisMouseMoveEnterFrame_handle);
			_stage = null;
		}
		
		//
		private function onThisMouseMoveEnterFrame_handle(evt:Event):void
		{
			var pi:Number = Math.atan2((_dragArea.y -_bgArea.y),(_dragArea.x -_bgArea.x));
			var jiaodu:Number = 180 * pi/Math.PI;
			//trace(pi);
			trace(jiaodu);
			var keyValue:uint = 0;
			if(pi < 0)
			{
				keyValue = Keyboard.W;
				
			}
			else
			{
				keyValue = Keyboard.S;
			}
			
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,true,false,0,
				keyValue == Keyboard.W?Keyboard.S:Keyboard.W,0,false,false,false));
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,keyValue,0,false,false,false));
			if(_keyBoardsValus.indexOf(keyValue)<0)
			{
				_keyBoardsValus.push(keyValue);
			}
			
			//=====================================
			if(jiaodu<90 && jiaodu>-90)
			{
				keyValue = Keyboard.D;
			}
			else
			{
				keyValue = Keyboard.A;
			}
			
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,true,false,0,
				keyValue == Keyboard.D?Keyboard.A:Keyboard.D,0,false,false,false));
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,keyValue,0,false,false,false));
			if(_keyBoardsValus.indexOf(keyValue)<0)
			{
				_keyBoardsValus.push(keyValue);
			}
		}
	}
}