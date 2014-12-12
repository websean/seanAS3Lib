/*************************  
/////////////////////////Sean Lee 2009.12.03//////////////////////////////
eg.
---------------------------------
xml.xml
<?xml version="1.0" encoding="utf-8"?>
<info>
	<book name="flash as1.0" />
	<book name="flash as2.0" />
	<book name="flash as3.0" />
</info>
---------------------------------
package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.xml.XMLDocument;
	import jdhcn.loadData.*;

	public class test extends Sprite {
		var m:LoadBase;
		var obj:Object;

		public function test():void {
			m = new XMLLoad(progressHandler);
			m.contentPath = "images/xml.xml";
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
					var xml:XML  = new XML (obj.data); 
					xml.ignoreWhite = true;
					trace(xml);
					trace(xml.book[0].@name);
					break;
				case IOErrorEvent.IO_ERROR :
					trace(m.contentPath + " 载入出错!");
					break;
				default :
			}
		}
	}
}
//////////////////////////////Sean Lee 2009.12.03////////////////////////
********************/
package sean.net.loadData
{
	import flash.net.URLLoader;
	import flash.system.System;

	public class XMLLoad extends LoadBase
	{

		public function XMLLoad(callBackFuc:Function):void
		{
			super(callBackFuc);
			this._className = "XMLLoad class";
			this._loadObject = new URLLoader();
			//_loadObject.ignoreWhite = true;
			System.useCodePage = true;
		}
	}
}