/*************************  
/////////////////////////@Sean Lee 2009.12.03//////////////////////////////
eg.
---------------------------------
txt.txt
	id=100&tel=13817708141
---------------------------------
package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import jdhcn.loadData.*;

	public class test extends Sprite {
		var m:LoadBase;
		var obj:Object;

		public function test():void {
			m = new TXTLoad(progressHandler);
			m.contentPath = "images/txt.txt";
			m.load();
			obj = m.data;
			trace(m.toString());
		}
		private function progressHandler(e:Event):void {
			var eType:String = e.type;
			var eObj:Object = e.target;
			switch (e.type) {
				case ProgressEvent.PROGRESS :
					trace(m.contentPath + " 已经载入: " + eObj.percentLoad +"%");
					break;
				case Event.COMPLETE :
					trace(m.contentPath + " 载入成功!");
					trace(eObj.data);
					trace(obj.data);
					var dataFormat:URLVariables = new URLVariables(obj.data);
					trace(dataFormat.id);
					break;
				case IOErrorEvent.IO_ERROR :
					trace(m.contentPath + " 载入出错!");
					break;
				default :
			}
		}
	}
}
//////////////////////////////@Sean Lee 2009.12.03////////////////////////
********************/
package sean.net.loadData
{
	import flash.net.URLLoader;

	public class TXTLoad extends LoadBase
	{

		public function TXTLoad(callBackFuc:Function):void
		{
			super(callBackFuc);
			this._className = "TXTLoad class";
			this._loadObject = new URLLoader();
		}
	}
}