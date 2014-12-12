package sean3d
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class SLoadEvent3D extends Event 
	{
		///3D资源全部加载完毕时的事件名
		public static const EVENT_ASSET_LOAD_COMPLETE:String = "AssetLoadEvent3D_EVENT_ASSET_LOAD_COMPLETE";
		///3D资源全部加载完毕且队列中为空时的事件名
		public static const EVENT_ALL_LIST_ASSET_LOAD_COMPLETE:String = "AssetLoadEvent3D_EVENT_ALL_LIST_ASSET_LOAD_COMPLETE";
		
		private var _meshList:Array;
		private var _URL:String;
		public function SLoadEvent3D(type:String, meshList:Array = null, url:String = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			
			_meshList = meshList;
			_URL = url;
			super(type, bubbles, cancelable);
			
		}
		
		public function get MeshList():Array
		{
			return _meshList;
		}
		
		public function get URL():String
		{
			return _URL;
		}
		
		public override function clone():Event 
		{ 
			return new SLoadEvent3D(type, _meshList, _URL, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AssetLoadEvent3D", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}

}