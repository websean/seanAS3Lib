package sean.lib 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	import sean.mvc.events.GlobalEvent;
	
	/**图片池管理类
	 * ...
	 * @author Sean Lee
	 */
	public class PicPool extends EventDispatcher 
	{
		///单张图加载完成
		public static const EVENT_SINGLE_PIC_LOAD_COMPLETE:String = "PicPool_EVENT_SINGLE_PIC_LOAD_COMPLETE";
		
		private static var PP:PicPool;
		//通用队列
		private var _list:Vector.<PPVO>;
		//队列池
		private var _listDictionary:Dictionary;
		
		public function PicPool(arg:PicPoolForSingleton) 
		{
			if (PP != null)
			{
				throw(new Error("Singleton Error!!! PicPool.as"));
			}
			
			_listDictionary = new Dictionary();
			_list = new Vector.<PPVO>();			
		}
		
		///获得单例的实例对象
		public static function getInstance():PicPool
		{
			if (PP == null)
			{
				PP = new PicPool(new PicPoolForSingleton());
			}
			
			return PP;
		}
		
		///检查池内是否有url对应的图片
		public function CheckPicInPool(url:String, key:String = null):Boolean
		{
			var has:Boolean = false;
			
			var vo:PPVO = findVO(url, key);
			if (vo != null)
			{
				has = true;
			}
			
			return has;
		}
		
		///注入拷贝的图片到池中
		public function CloneAndFillIn(url:String, bmpd:BitmapData, key:String = null):void
		{
			var bd:BitmapData = bmpd.clone();
			var list:Vector.<PPVO> = getList(key);
			var vo:PPVO = findVO(url, key);
			if (vo == null)
			{
				vo = new PPVO();
				vo.URL = url;
				list.push(vo);
			}
			else
			{
				vo.RemoveBMPD();
			}			
			vo.BMPD = bmpd.clone();
			
		}
		
		///获取池内链接对应包含该url的图片数据（key：图片存放的队列对应的key，如果不传，则从通用队列里取）
		public function GetBitmapDataClone(url:String, key:String = null):BitmapData
		{
			var bmpd:BitmapData = null;
			
			var list:Vector.<PPVO> = getList(key);
			
			for (var i:int = 0; i < list.length; i++)
			{
				var vo:PPVO = list[i] as PPVO;
				if (vo.URL == url)
				{
					bmpd = vo.BMPD.clone();
					break;
				}
			}
			
			return bmpd;
		}
		
		///清空key对应队列
		public function ClearPool(key:String = null):void
		{
			var list:Vector.<PPVO> = getList(key);
			
			while (list.length > 0)
			{
				list.pop();
			}
		}
		
		///移除key对应队列
		public function RemovePool(key:String = null):void
		{
			if (key == null) return;
			ClearPool(key);
			delete _listDictionary[key];
		}
		
		///清空和移除所有队列
		public function RemoveAll():void
		{
			ClearPool();
			_listDictionary = new Dictionary();
		}
		
		//检索值对象
		private function findVO(url:String, key:String = null):PPVO
		{
			var ppvo:PPVO;
			var list:Vector.<PPVO> = getList(key);
			for (var i:int = 0; i < list.length; i++)
			{
				var vo:PPVO = list[i] as PPVO;
				if (vo.URL == url)
				{
					ppvo = vo;
					break;
				}
			}
			return ppvo;
		}
		
		//获取图片队列
		private function getList(key:String = null):Vector.<PPVO>
		{
			var list:Vector.<PPVO> = key == null?_list:_listDictionary[key];
			
			if (list == null)
			{
				list = new Vector.<PPVO>();
				_listDictionary[key] = list;
			}
			
			return list;
		}
		
		//=====================================================================================Handle		
		
		
	}

}


import flash.display.BitmapData;

class PicPoolForSingleton
{
	
}

class PPVO
{
	public var URL:String;
	public var BMPD:BitmapData;
	
	public function PPVO()
	{
		
	}
	
	///销毁
	public function Destory():void
	{
		RemoveBMPD();
		URL = null;
	}
	
	///清除位图数据
	public function RemoveBMPD():void
	{
		if (BMPD != null)
		{
			BMPD.dispose();
		}
	}
	
}