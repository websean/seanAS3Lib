package sean.utils {
	
	/**
	 * ...
	 * @author Sean Lee
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * 为DrawClip类绘制图形的属性对象类
	 * @classname drawStyle
	 * 
	 */
	public class DrawStyle extends Object {
		private var _bgColor:uint;
		private var _borderColor:uint;
		private var _thickness:uint;
		private var _bgAlpha:Number;
		private var _borderAlpha:Number;
		private var _radius:Number;
		private var _pixelHinting:Boolean;
		private var _scaleMode:String;
		private var _caps:String;
		private var _joints:String;
		private var _miterLimit:Number;
		
		public function DrawStyle():void {
			reSet();
		}
		public function reSet():void {
			_bgColor = 0xffffff;
			_borderColor = 0x666666;
			_thickness = 1;
			_bgAlpha = 1;
			_borderAlpha = 1;
			_radius = 5;
			_pixelHinting = true;
			_scaleMode = "none";
			_caps = "none";
			_joints = "round";
			_miterLimit = 3;
		}
		
		public function get bgColor():uint { return _bgColor; }		
		public function set bgColor(value:uint):void {
			_bgColor = value;
		}
		
		public function get borderColor():uint { return _borderColor; }		
		public function set borderColor(value:uint):void {
			_borderColor = value;
		}
		
		public function get thickness():uint { return _thickness; }		
		public function set thickness(value:uint):void {
			_thickness = value;
		}
		
		public function get bgAlpha():Number { return _bgAlpha; }		
		public function set bgAlpha(value:Number):void {
			_bgAlpha = value;
		}
		
		public function get borderAlpha():Number { return _borderAlpha; }		
		public function set borderAlpha(value:Number):void {
			_borderAlpha = value;
		}
		
		public function get radius():Number { return _radius; }		
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		public function get pixelHinting():Boolean { return _pixelHinting; }		
		public function set pixelHinting(value:Boolean):void {
			_pixelHinting = value;
		}
		
		public function get scaleMode():String { return _scaleMode; }		
		public function set scaleMode(value:String):void {
			_scaleMode = value;
		}
		
		public function get caps():String { return _caps; }		
		public function set caps(value:String):void {
			_caps = value;
		}
		
		public function get joints():String { return _joints; }	
		public function set joints(value:String):void 	{
			_joints = value;
		}
		
		public function get miterLimit():Number { return _miterLimit; }		
		public function set miterLimit(value:Number):void {
			_miterLimit = value;
		}
		
	}
	
}