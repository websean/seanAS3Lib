/********************
package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import jdhcn.loadData.LoadData;
	
	public class Test extends Sprite {
		private var obj:LoadData;
		
		public function Test():void {
			obj = new LoadData(onComplete);
			//obj.contentPath = "http://192.168.21.168/001.swf?&r=" + ((Math.random() * 10000) >> 0);
			obj.kind = "swf";
			obj.load();
			//addChild(obj.data);
		}
		public function onComplete(e:Event):void {
			var eType:String = e.type;
			var eObj:Object = e.target;
			switch (e.type) {
				case ProgressEvent.PROGRESS :
					trace(obj.contentPath + " 已经载入: " + eObj.percentLoad +"%");
					break;
				case Event.COMPLETE :
					trace(obj.contentPath + " 载入成功!");
					break;
				case IOErrorEvent.IO_ERROR :
					trace(obj.contentPath + " 载入出错!");
					break;
				default :
			}
		}
	}
	
}
********************/

package sean.net.loadData
{
	import flash.display.Loader;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	
	/**
	 * ...
	 * @author Sean Lee 2009.12.03
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname LoadData
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class LoadData
	{
		private var _tk:String = "";
		private var _kind:String;			//swf/jpg/flv/mp3/xml/txt;
		private var _filePath:String;
		private var _fun:Function;
		
		private var _obj:Object;
		private var _data:Object;
		
		public function LoadData(callBackFuc:Function):void
		{
			_fun = callBackFuc;
		}
		
		private function init():void
		{
			chkKind();
			switch(_kind)
			{
				case "swf":
				case "jpg":
					_obj = new SWFLoad(_fun);
					break;
				case "flv":
					_obj = new FLVLoad(_fun);
					break;
				case "mp3":
					_obj = new MP3Load(_fun);
					break;
				case "xml":
					_obj = new XMLLoad(_fun);
					break;
				case "txt":
					_obj = new TXTLoad(_fun);
					break;
				default:
					throw new Error("load的数据类型不正确");
					return;
			}
			_data = _obj.data;
		}
		
		public function load():void
		{
			init();
			_obj.contentPath = _filePath;
			_obj.load();
		}
		
		private function chkKind():void
		{
			if (_tk == "") 	_kind = getFileKind(_filePath);
			_tk = "";
		}
		
		private function getFileKind(str:String):String
		{
			var _arr:Array = str.split(".");
			return (_arr[_arr.length - 1].substr(0, 3));
		}
		
		public function close():void { _obj.close(); }
		
		/////set/get/////
		public function get percentLoad():Number { return _obj.percentLoad; }
		
		public function get kind():String { return _kind; }		
		public function set kind(value:String):void
		{
			if (kind == "") return;
			_kind = value;
			_tk = value;
		}
		
		public function get contentPath():String { return _filePath; }		
		public function set contentPath(value:String):void
		{
			_filePath = value;
		}
		
		public function get data():*
		{
			var _value:*;
			switch(_kind)
			{
				case "swf":
				case "jpg":
					_value = _data as Loader;
					break;
				case "flv":
					_value = _data as NetStream;
					break;
				case "mp3":
					_value = _data as Sound;
					break;
				case "xml":
				case "txt":
					_value = _data as URLLoader;
					break;
				default:
					throw new Error("load的数据类型不正确");
					return null;
			}
			return _value;
		}
		
		
	}
	
}