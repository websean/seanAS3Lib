/*************************  
/////////////////////////@Sean Lee 2009.12.03//////////////////////////////
eg.
package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import jdhcn.loadData.FLVLoad;
	import jdhcn.loadData.LoadBase;
	
	public class Test extends Sprite{
		private var m:FLVLoad;
		private var obj:Object;
		private var _flag:Boolean = true;
		private var _video:Video;
				
		public function Test():void{
			m = new FLVLoad(progressHandler);
			m.contentPath = "http://127.0.0.1/flv/001.flv?&r=" + ((Math.random() * 10000) >> 0);
			m.load();
			_video = new Video();
			_video.smoothing = true;
			_video.attachNetStream(m.data as NetStream)
			addChild(_video);
			(m.data as NetStream).resume();
		}
		private function progressHandler(e:Event):void{
			var eType:String = e.type;
			var eObj:Object = e.target;
			switch (e.type) {
				case ProgressEvent.PROGRESS:
					trace (m.contentPath + " 已经载入: " + eObj.percentLoad +"%");
					break;
				case Event.COMPLETE:
					trace (m.contentPath + " 载入成功!");
					break;
				case IOErrorEvent.IO_ERROR:
					trace (m.contentPath + " 载入出错!");
					break;
				default:
			}
		}
	}
	
}
//////////////////////////////Sean Lee 2009.12.03////////////////////////
********************/
package sean.net.loadData
{
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.SecurityErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	public class FLVLoad extends LoadBase
	{
		private var myStream:MyNetStream;
		private var connection:NetConnection;
		private var _soundVol:SoundTransform = new SoundTransform();
		private var _isLoaded:Boolean = false;

		public function FLVLoad(fuc:Function):void
		{
			super(fuc);
			this._className = "FLVLoad class";
			
			connection = new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);
		}
		
        override public function load():void
		{
			if (!_isLoaded)
			{
				_isLoaded = true;
				return;
			}
			_soundVol.volume = 0;
			_loadObject.soundTransform = _soundVol;
			_loadObject.play(_contentPath);
			_loadObject.pause();    
        }
		
		private function netStatusHandler(e:NetStatusEvent):void
		{
			trace(e.info.code);
            switch (e.info.code)
			{
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + _contentPath);
                    break;
            }
        }
		
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
            trace("securityErrorHandler: " + e);
        }
		
		private function connectStream():void
		{
			myStream = new MyNetStream(connection);
			myStream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			myStream.addEventListener(Event.COMPLETE, completeHandler);	
			_loadObject = myStream.stream;
			_loadObject.bufferTime = 1;
            _loadObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_loadObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            _loadObject.client = new CustomClient();
			
			load();
		}
        
        private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
            // ignore AsyncErrorEvent events.
        }
		
		/////override function/////
		override public function get percentLoad():Number { return myStream.percent; }
		
		//得到加载的字节数;
		override protected function getBytesLoaded():Number
		{ 
			//var s:NetStream;s.bytesTotal
			return myStream.bytesLoaded;
		}
		
		//得到需加载的字节总数;
		override protected function getBytesTotal():Number
		{
			return myStream.bytesTotal;
		}
		
	}
}

class CustomClient {
    public function onMetaData(info:Object):void
	{
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }
	
    public function onCuePoint(info:Object):void
	{
        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }
}