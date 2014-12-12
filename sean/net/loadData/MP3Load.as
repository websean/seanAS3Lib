/*************************  
/////////////////////////@Sean Lee 2009.12.03//////////////////////////////
eg.
package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import jdhcn.loadData.*;
	
	public class test extends Sprite{
		var m:LoadBase;
		var obj:Object;
				
		public function test():void{
			m = new MP3Load(progressHandler);
			m.contentPath = "images/silu.mp3";
			m.load();
			obj = m.data;
			obj.play();
			trace(m.toString());
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
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class MP3Load extends LoadBase
	{

		public function MP3Load(callBackFuc:Function):void
		{
			super(callBackFuc);
			this._className = "MP3Load class";
			this._loadObject = new Sound();
		}
		
		
	}
}