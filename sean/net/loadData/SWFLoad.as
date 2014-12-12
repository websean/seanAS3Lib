/*************************  
/////////////////////////@Sean Lee 2009.12.03//////////////////////////////
eg.
package {
	import flash.display.MovieClip;
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
			m = new SWFLoad(progressHandler);
			m.contentPath = "images/swf.swf";
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
					trace(eObj.data.content);
					trace(obj.content);
					addChild(obj.content);
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
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	public class SWFLoad extends LoadBase
	{

		public function SWFLoad(callBackFuc:Function):void
		{
			super(callBackFuc);
			this._className = "SWFLoad class";
			this._loadObject = new Loader();
		}
		
		public function unload():void
		{
			_loadObject.unload();
		}
		//删除被下载的对象;
		private function unLoadHandler(e:Event):void
		{
			doDispatchEvent(Event.UNLOAD);
		}
		
		/////override function/////
		//得到加载的字节数;
		override protected function getBytesLoaded():Number
		{
			return _loadObject.contentLoaderInfo.bytesLoaded;
		}
		
		//得到需加载的字节总数;
		override protected function getBytesTotal():Number
		{
			return _loadObject.contentLoaderInfo.bytesTotal;
		}
		
		override public function load():void
		{
			var request:URLRequest = new URLRequest(this._contentPath);
			_loadObject.load(request);
			_loadObject.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loadObject.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loadObject.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loadObject.contentLoaderInfo.addEventListener(Event.UNLOAD, unLoadHandler);
		}
	}
}