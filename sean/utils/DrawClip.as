package sean.utils {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import sean.utils.DrawStyle;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.Point;

	
	/**
	 * ...
	 * @author Sean Lee 2009.11
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * JDHCN包的 绘制矩形 类
	 * @classname DrawRect	//静态类
	 * @methods
	 * drawRect()			//绘制直角矩形;
	 * drawRoundRect()		//绘制圆角矩形;
	 * DrawSector()          //绘制扇形;
	 * @params 
	 * obj			//要绘制图形的对象;
	 * style		//绘制对象的默认属性对象(参考:jdhcn.draw.DrawStyle类);
	 * w			//宽度;
	 * h			//高度;
	 * radius		//圆的径;
	 */
	public class DrawClip
	{
		private static var defaultStyle:DrawStyle = new DrawStyle();
		
		///绘制矩形
		public static function drawRect(obj:Object, x:Number=0, y:Number=0, w:Number = 100, h:Number = 20, style:DrawStyle = null):void {
			if (style == null)
			{
				style = defaultStyle;
			}
			obj.graphics.clear();
			obj.graphics.lineStyle(style.thickness, style.borderColor, style.borderAlpha, style.pixelHinting, style.scaleMode, style.caps, style.joints, style.miterLimit);
			obj.graphics.beginFill(style.bgColor, style.bgAlpha);
			obj.graphics.drawRect(x, y, w, h);
			obj.graphics.endFill();
		}
		
		///绘制圆角矩形
		public static function drawRoundRect(obj:Object, x:Number=0, y:Number=0, w:Number=100, h:Number=20, radius:Number=5, style:DrawStyle = null):void {
			if (style == null)
			{
				style = defaultStyle;
			}
			obj.graphics.clear();
			obj.graphics.lineStyle(style.thickness, style.borderColor, style.borderAlpha, style.pixelHinting, style.scaleMode, style.caps, style.joints, style.miterLimit);
			obj.graphics.beginFill(style.bgColor, style.bgAlpha);
			obj.graphics.drawRoundRect(x, y, w, h, radius);
			obj.graphics.endFill();
		}
		
		///绘制圆形
		public static function drawCircle(obj:Object, x:Number=20, y:Number=20, radius:Number=20, style:DrawStyle = null):void {
			if (style == null)
			{
				style = defaultStyle;
			}
			obj.graphics.clear();
			obj.graphics.lineStyle(style.thickness, style.borderColor, style.borderAlpha, style.pixelHinting, style.scaleMode, style.caps, style.joints, style.miterLimit);
			obj.graphics.beginFill(style.bgColor, style.bgAlpha);
			obj.graphics.drawCircle(x, y, radius);
			obj.graphics.endFill();
		}
		
		///绘制椭圆
		public static function drawEllipse(obj:Object, x:Number=0, y:Number=0, w:Number=80, h:Number=60, style:DrawStyle = null):void {
			if (style == null)
			{
				style = defaultStyle;
			}
			obj.graphics.clear();
			obj.graphics.lineStyle(style.thickness, style.borderColor, style.borderAlpha, style.pixelHinting, style.scaleMode, style.caps, style.joints, style.miterLimit);
			obj.graphics.beginFill(style.bgColor, style.bgAlpha);
			obj.graphics.drawEllipse(x, y, w, h);
			obj.graphics.endFill();
		}
		
		///绘制三角形
		public static function drawTriangle(obj:Object,h:Number = 20, style:DrawStyle = null):void {
			if (style == null)
			{
				style = defaultStyle;
			}
			obj.graphics.clear();
			obj.graphics.lineStyle(style.thickness, style.borderColor, style.borderAlpha, style.pixelHinting, style.scaleMode, style.caps, style.joints, style.miterLimit);
			obj.graphics.beginFill(style.bgColor, style.bgAlpha);
			obj.graphics.moveTo(0, - 2 / 3 * h);
			obj.graphics.lineTo(3 / 4 * h, 1 / 3 * h);
			obj.graphics.lineTo( - 3 / 4 * h, 1 / 3 * h);
			obj.graphics.lineTo(0, - 2 / 3 * h);
			obj.graphics.endFill();
		}
		
		///绘制扇形
		public static function drawSector(mc:Object,x:Number=100,y:Number=100,r:Number=100,
		angle:Number=27,startFrom:Number=270,color:Number=0xff0000):void
		/*
		* mc the DisplayObjectContainer: the container of the sector.
		* x,y the center position of the sector
		* r the radius of the sector
		* angle the angle of the sector
		* startFrom the start degree counting point : 270 top, 180 left, 0 right, 90 bottom , 
		* it is counting from top in this example. 
		* color the fil lin color of the sector
		*/
		{
			mc.graphics.clear();
			/* start to fill the sector with the variable "color" if you want a sector without filling color ,
			* please remove next line below.
			*/
			mc.graphics.beginFill(color,50); //remove this line to unfill the sector
			/* the border of the secetor with color 0xff0000 (red) , you could replace it with any color 
			* you want like 0x00ff00(green) or 0x0000ff (blue).
			*/
			mc.graphics.lineStyle(0,0xff0000); 
			mc.graphics.moveTo(x,y);
			angle=(Math.abs(angle)>360)?360:angle;
			var n:Number=Math.ceil(Math.abs(angle)/45);
			var angleA:Number=angle/n;
			angleA=angleA*Math.PI/180;
			startFrom=startFrom*Math.PI/180;
			mc.graphics.lineTo(x+r*Math.cos(startFrom),y+r*Math.sin(startFrom));
			for(var i:int=1;i<=n;i++)
			{
				startFrom+=angleA;
				var angleMid:Number=startFrom-angleA/2;
				var bx:Number=x+r/Math.cos(angleA/2)*Math.cos(angleMid);
				var by:Number=y+r/Math.cos(angleA/2)*Math.sin(angleMid);
				var cx:Number=x+r*Math.cos(startFrom);
				var cy:Number=y+r*Math.sin(startFrom);
				mc.graphics.curveTo(bx,by,cx,cy);
			}
			if (angle != 360)
			{
				mc.graphics.lineTo(x, y);
			}
			mc.graphics.endFill(); // if you want a sector without filling color , please remove this line.
		}
		
		
		/**
		 * 画斑马线
		 * 
		 * @param	graphics	<b>	Graphics</b> 
		 * @param	beginPoint	<b>	Point	</b> 
		 * @param	endPoint	<b>	Point	</b> 
		 * @param	width		<b>	Number	</b> 斑马线的宽度
		 * @param	grap		<b>	Number	</b> 斑马线的间隔
		 */
		public static function drawZebraStripes(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var halfWidth:Number = width * .5;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var radian1:Number = (radian / Math.PI * 180 + 90) / 180 * Math.PI;
			var radian2:Number = (radian / Math.PI * 180 - 90) / 180 * Math.PI;
			
			var currX:Number, currY:Number;
			var p1x:Number, p1y:Number;
			var p2x:Number, p2y:Number;
			
			while (currLen <= totalLen)
			{
				currX = Ox + Math.cos(radian) * currLen;
				currY = Oy + Math.sin(radian) * currLen;
				p1x = currX + Math.cos(radian1) * halfWidth;
				p1y = currY + Math.sin(radian1) * halfWidth;
				p2x = currX + Math.cos(radian2) * halfWidth;
				p2y = currY + Math.sin(radian2) * halfWidth;
				
				graphics.moveTo(p1x, p1y);
				graphics.lineTo(p2x, p2y);
				
				currLen += grap;
			}
			
		}
 
 
		/**
		 * 画虚线
		 * 
		 * @param	graphics	<b>	Graphics</b> 
		 * @param	beginPoint	<b>	Point	</b> 
		 * @param	endPoint	<b>	Point	</b> 
		 * @param	width		<b>	Number	</b> 虚线的长度
		 * @param	grap		<b>	Number	</b> 
		 */
		public static function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number, y:Number;
			
			while (currLen <= totalLen)
			{
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.moveTo(x, y);
				
				currLen += width;
				if (currLen > totalLen) currLen = totalLen;
				
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.lineTo(x, y); 
				currLen += grap;
			}
			
		}
		
		
		
	}
	
}