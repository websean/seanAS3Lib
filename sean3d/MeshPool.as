package sean3d 
{
	import away3d.entities.Mesh;
	import flash.utils.Dictionary;
	/**3d模型池
	 * ...
	 * @author Sean Lee
	 */
	public class MeshPool 
	{
		public static var MP:MeshPool;
		
		//通用队列
		private var _list:Vector.<MPVO>;
		//队列池
		private var _listDictionary:Dictionary;
		
		
		//默认key值
		public static const KeyName:String = "defaultKey_value";
		
		public function MeshPool(arg:MeshPoolForSingleton) 
		{
			if (MP != null)
			{
				throw(new Error("MeshPool Singleton Error!!!"));
			}
			
			_list = new Vector.<MPVO>();
		}
		
		public static function getInst():MeshPool
		{
			if (MP == null)
			{
				MP = new MeshPool(new MeshPoolForSingleton());
			}
			
			return MP;
		}
		
		///检查池内是否有url对应的Mesh模型
		public function CheckInPool(url:String, key:String = KeyName):Boolean
		{
			var has:Boolean = false;
			
			var vo:MPVO = findVO(url, key);
			if (vo != null)
			{
				has = true;
			}
			
			return has;
		}
		
		///注入拷贝的Mesh模型到池中
		public function CloneAndFillIn(url:String, meshList:Array, key:String = KeyName):void
		{
			var meshes:Array = (meshList == null)?null:meshList.concat();
			var list:Vector.<MPVO> = getList(key);
			var vo:MPVO = findVO(url, key);
			if (vo == null)
			{
				vo = new MPVO();
				vo.URL = url;
				list.push(vo);
			}
			else
			{
				vo.RemoveMESH();
			}			
			vo.MESHList = meshes;
			
		}
		
		///获取池内链接对应包含该url的Mesh模型队列数据（key：模型存放的队列对应的key，如果不传，则从通用队列里取）
		public function GetMeshClone(url:String, key:String = KeyName):Array
		{
			var meshes:Array = new Array();
			var meshList:Array;
			
			var list:Vector.<MPVO> = getList(key);
			
			for (var i:int = 0; i < list.length; i++)
			{
				var vo:MPVO = list[i] as MPVO;
				if (vo.URL == url)
				{
					meshList = vo.MESHList;
					break;
				}
			}
			
			if (meshList != null)
			{
				for each(var mesh:Mesh in meshList)
				{
					var m:Mesh = mesh.clone() as Mesh;
					meshes.push(m);
				}
			}
			
			return meshes;
		}
		
		///清空key对应队列
		public function ClearPool(key:String = KeyName):void
		{
			var list:Vector.<MPVO> = getList(key);
			
			while (list.length > 0)
			{
				list.pop();
			}
		}
		
		///移除key对应队列
		public function RemovePool(key:String = KeyName):void
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
		
		//获取key值对应的Mesh队列
		private function getList(key:String = KeyName):Vector.<MPVO>
		{
			var list:Vector.<MPVO> = ((key == KeyName)?_list:_listDictionary[key]);
			
			if (list == null)
			{
				list = new Vector.<MPVO>();
				_listDictionary[key] = list;
			}
			
			return list;
		}
		
		//检索值对象
		private function findVO(url:String, key:String = KeyName):MPVO
		{
			var mpvo:MPVO;
			var list:Vector.<MPVO> = getList(key);
			for (var i:int = 0; i < list.length; i++)
			{
				var vo:MPVO = list[i] as MPVO;
				if (vo.URL == url)
				{
					mpvo = vo;
					break;
				}
			}
			return mpvo;
		}
		
	}

}


import away3d.entities.Mesh;

class MeshPoolForSingleton
{
	
}

class MPVO
{
	public var URL:String;
	public var MESHList:Array;
	
	public function MPVO()
	{
		
	}
	
	///销毁
	public function Destory():void
	{
		RemoveMESH();
		URL = null;
	}
	
	///清除模型数据
	public function RemoveMESH():void
	{
		if (MESHList != null && MESHList.length > 0)
		{
			for each(var m:Mesh in MESHList)
			{
				m.dispose();
			}			
		}
	}
	
}