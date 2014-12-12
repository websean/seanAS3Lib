package sean.net.loadData
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author Sean Lee 2009.12.03
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname BatchLoad
	 * @methods
	 * ///////公共属性/////////
	 * index():int						//当前正在载入第几个;
	 * totalFiles():int					//队列中总共有多少个文件需要载入;
	 * percentLoad():Number				//当前正在载入文件的进度(百分比);
	 * own():LoadData					//获取当前数据载入的引用;
	 * 
	 * ///////公共方法/////////
	 * add(obj:*):void					//往载入队列中添加需要载入的文件对象或文件数组对象(对象格式为LoadDataType);
	 * start():void						//开始载入;
	 * pause():void						//暂停载入;
	 * stop():void						//停止载入;
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class BatchLoad extends EventDispatcher
	{
		private var arr:Array;
		private var urlArr:Array;
		private var _currIndex:int = 0;
		
		public function BatchLoad():void
		{
			init();
		}
		
		private function init():void
		{
			urlArr = new Array();
			arr = new Array();
		}
		
		public function start():void
		{
			arr[_currIndex] = new LoadData(onListener);
			arr[_currIndex].contentPath = urlArr[_currIndex].url;
			arr[_currIndex].kind = urlArr[_currIndex].kind;
			arr[_currIndex].load();
		}
		
		public function pause():void
		{
			arr[_currIndex].close();
		}
		
		public function stop():void 
		{
			arr[_currIndex].close();
			_currIndex = 0;
		}
		
		//此参数中对象类型为LoadDataType类型;
		public function add(obj:*):void
		{
			if (obj is Array) {
				urlArr = urlArr.concat(obj);
			}else {
				urlArr.push(obj);
			}
		}
		
		private function load():void
		{
			var n = _currIndex + 1;
			if (n > 0 && n < totalFiles)
			{
				_currIndex++;
				start();
			}
		}
		private function onListener(e:Event):void
		{
			dispatchEvent(e);
			switch (e.type)
			{
				case ProgressEvent.PROGRESS :
					//trace(arr[_currIndex].contentPath + " 已经载入: " + arr[_currIndex].percentLoad +"%");
					break;
				case Event.COMPLETE :
					//trace(arr[_currIndex].contentPath + " 载入成功!");
					load();
					break;
				case Event.OPEN:
					//trace(arr[_currIndex].contentPath + " 打开!");
					break;
				case IOErrorEvent.IO_ERROR :
					//trace(arr[_currIndex].contentPath + " 载入出错!");
					load();
					break;
				default :
			}
		}
		/////set/get/////
		public function get index():int { return _currIndex + 1; }
		public function get totalFiles():int { return urlArr.length; }
		public function get percentLoad():Number { return arr[_currIndex].percentLoad; }
		public function get own():LoadData { return arr[_currIndex]; }
	}
	
}