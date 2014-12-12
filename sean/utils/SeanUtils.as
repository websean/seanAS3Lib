package sean.utils 
{
	
	/**
	 * ...通用工具类
	 * @author Sean Lee
	 */
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.net.URLVariables;
	
	public class SeanUtils
	{
		///调试状态
		private static var _Debug:Boolean = false ;
		
		public function SeanUtils() 
		{
			
		}
		
		///获取调试状态参数
		public static function get Debug():Boolean
		{
			return _Debug;
		}
		
		public static function set Debug(value:Boolean):void 
		{
			_Debug = value;
		}
		
		///调试输出（显示对象，类比trace）
		public static function getDisplayObjPath(t:DisplayObject):String 
		{   
		   var a:String = getDOPath(t);
		   return a;
		}	  
		private static function getDOPath(t:DisplayObject, name:String = ""):String
		{	   
			if (name == "") 
			{
				name = t.name;
			}else 
			{
				name = t.name +"." +name;
			}
		   
		   if (t.parent.name) 
		   {
				return getDOPath(t.parent, name);
		   }
		   else 
		   {
				return name;
		   }
		}
		
		public static function ComputeScaleSizeByLimit(w_original:Number, h_original:Number, w_limit:Number, h_limit:Number):Number
		{
			if (w_limit == h_limit && w_limit == 0)
			{
				return 1;
			}
			
			var WH_Scale:Number = w_limit / h_limit;
			var bgWH_S:Number = w_original / h_original;
			var scaleNum:Number;
			
			///比限定范围小，就无须缩放
			if (w_original <= w_limit && h_original <= h_limit)
			{
				scaleNum = 1;
			}
			else
			{			
				if (bgWH_S >= WH_Scale)
				{
					if (w_original > w_limit)
					{						
						scaleNum = w_limit / w_original;
					}
				}
				else
				{				
					if (h_original > h_limit)
					{						
						scaleNum = h_limit / h_original;
					}
				}				
				
			}
			
			if (!scaleNum)
			{
				throw(new Error("YgUtils.as: 图片缩放操作中缩放比例系数计算错误！！！"));
			}
			
			return scaleNum;
		}
		
		///根据容器限定大小去缩放图片（等比缩放，自身图片比例不变）
		public static function getNewBitmapData_WhichScaleSizeByLimit(bmpd:BitmapData, w_limit:Number, h_limit:Number):BitmapData
		{
			
			var newBmpD:BitmapData;
			
			var newBMPD_W:Number;
			var newBMPD_H:Number;
			
			var scaleNum:Number = ComputeScaleSizeByLimit(bmpd.width, bmpd.height, w_limit, h_limit);
			newBMPD_W = int(bmpd.width*scaleNum);
			newBMPD_H = int(bmpd.height*scaleNum);
			
			
			newBmpD= new BitmapData(newBMPD_W, newBMPD_H, true, 0);
			newBmpD.draw(bmpd, new Matrix(scaleNum, 0, 0, scaleNum), null, null, null, true);
			return newBmpD;
		}
		
		///调整显示对象的缩放比
		public static function ModifyDisplayOBJScale(mc:DisplayObject, w:Number = 0, h:Number = 0):void		
		{
			if (w == 0 && h == 0) return;
			mc.scaleX = mc.scaleY = 1;
			var scaleX:Number = w / mc.width;
			var scaleY:Number = h / mc.height;
			
			if (w == 0)
			{
				scaleX = scaleY;
			}
			
			if (h == 0)
			{
				scaleY = scaleX;
			}
			
			mc.scaleX = scaleX;
			mc.scaleY = scaleY;
		}
		
		///根据限制大小改变显示对象的缩放比并保持比例（mc：操作对象；w_limit：限宽；h_limit：限高；scaleMax：是否取限制区域的最大显示值，如果取最小限制值则显示对象呗限制在区域内显示，否则限制对象将填满限制区域且允许有超出部分；）
		public static function LimitDisPlayOBJScale(mc:DisplayObject, w_limit:Number = 0, h_limit:Number = 0, scaleMax:Boolean = false):void		
		{
			if (w_limit == 0 && h_limit == 0) return;
			mc.scaleX = mc.scaleY = 1;
			var scaleX:Number = w_limit / mc.width;
			var scaleY:Number = h_limit / mc.height;			
			
			if (w_limit > 0 && h_limit > 0)
			{
				var scale:Number = 1;
				if (scaleMax)
				{
					scale = Math.max(scaleX, scaleY);
				}
				else
				{
					scale = Math.min(scaleX, scaleY);
				}		
				mc.scaleX = mc.scaleY = scale;
			}
			else
			{
				if (w_limit == 0)
				{
					scaleX = scaleY;
				}			
				if (h_limit == 0)
				{
					scaleY = scaleX;
				}
				mc.scaleX = scaleX;
				mc.scaleY = scaleY;
			}
		}
		
		///把秒转换成时分秒的格式
		public static function getTimeStringBySeconds(second:Number):String
		{
			var timeStr:String = "";
			var dayStr:String = "";
			var hourStr:String = "";
			var minStr:String =  "";
			var sndStr:String = "";
			
			var day:Number = Math.floor(second / (3600 * 24));
			if (day > 0)
			{
				second = second - (day * 3600 * 24);
			}
			var hour:Number = Math.floor(second / 3600);
			var min:Number =  Math.floor((second % 3600) / 60);
			var snd:Number = (second % 3600) % 60;
			dayStr = day == 0?"":String(day + "天");
			hourStr = hour == 0?"":String(hour + "时");
			minStr = min == 0?"":String(min + "分");
			sndStr = String(snd + "秒");
			
			timeStr = String(dayStr + hourStr + minStr + sndStr);
			
			
			return timeStr;
		}
		
		///把秒转换成（00:00:00）的格式
		public static function getTimeStringBySeconds_2(second:Number, full:Boolean = false):String
		{
			var timeStr:String = "";
			
			var hourStr:String = "";
			var minStr:String =  "";
			var sndStr:String = "";
			
			var hour:Number = Math.floor(second / 3600);
			var min:Number =  Math.floor((second % 3600) / 60);
			var snd:Number = (second % 3600) % 60;
			
			hourStr = hour < 10?String("0"+ hour + ":"):String(hour + ":");
			minStr = min < 10?String("0"+ min + ":"):String(min + ":");
			sndStr = snd < 10?String("0" + snd):String(snd);
			
			if (hour<=0 && !full)
			{
				hourStr = "";
			}
			
			timeStr = String(hourStr + minStr + sndStr);			
			
			return timeStr;
		}
		
		
	}

}