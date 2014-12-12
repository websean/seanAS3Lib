package sean3d
{
	
	/**AWay3d 模型加载控件
	 * ...
	 * @author Sean Lee
	 */
	/*
	 * 示例
	 * _assetLoader = new SLoader3D();
		_assetLoader.addEventListener(SLoadEvent3D.EVENT_ASSET_LOAD_COMPLETE, onAssetAllComplete_handle);
		_assetLoader.Load3D("assets/books.3DS");
		_assetLoader.Load3D("assets/guizi1.awd");
		
		private var M:ObjectContainer3D = new ObjectContainer3D();		
		private function onAssetAllComplete_handle(evt:SLoadEvent3D):void
		{
			var meshList:Array = evt.MeshList;
			for each(var m:Mesh in meshList)
			{
				m.material = new ColorMaterial(0, 0.5);
				M.addChild(m);
				
			}
			M.scale(1);
			M.y = 100;
			M.x = 500;
			M.z = -800;
			_view.scene.addChild(M);
		}
	*/
	
	
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.Parsers;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class SLoader3D extends EventDispatcher
	{
		private var _awdLoader:URLLoader;
		private var _loader3D:Loader3D;
		private var _meshList:Array;
		private var _fileFormat:String;
		private var _loadRunning:Boolean = false;
		private var _loadList:Array;
		private var _currentURL:String;
		private var _mPool:MeshPool;
		
		public function SLoader3D() 
		{
			init();
		}
		
		private function init():void
		{
			_loadList = new Array();
			_loadRunning = false;
			_mPool = MeshPool.getInst();
		}
		
		//调整加载状态（是否加载处理中）
		private function modifyLoadRunningState(loadRunning_State:Boolean):void
		{
			_loadRunning = loadRunning_State;
			
			if (!_loadRunning) loadNext();
			
			if (!_loadRunning && _loadList.length == 0)
			{
				this.dispatchEvent(new SLoadEvent3D(SLoadEvent3D.EVENT_ALL_LIST_ASSET_LOAD_COMPLETE));
			}
		}
		
		//加载队列中的下一个
		private function loadNext():void
		{
			if (!_loadRunning && _loadList.length > 0)
			{
				Load3D(_loadList.shift());
			}
		}
		
		///加载3d模型文件（awd格式，3ds格式）
		public function Load3D(url:String, key:String = null):void
		{			
			if (_loadRunning)
			{
				_loadList.push(url);
				return;
			}
			
			var k:String = (key == null)?MeshPool.KeyName:key;
			var has:Boolean = _mPool.CheckInPool(url, k);
			if (has)
			{
				var meshList:Array = _mPool.GetMeshClone(url, k);
				this.dispatchEvent(new SLoadEvent3D(SLoadEvent3D.EVENT_ASSET_LOAD_COMPLETE, meshList.concat(), url));
				return;
			}
			
			modifyLoadRunningState(true);
			_currentURL = url;
			_awdLoader = new URLLoader();
			_awdLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_fileFormat = url.substring(url.length - 3);
			switch (_fileFormat)
			{
                case "AWD": 
                case "awd": 
				case "3ds": 
				case "3DS":
				case "obj": 
				case "OBJ":
                    _awdLoader.addEventListener(Event.COMPLETE, parse3DAsset, false, 0, true);
                break;
			}
			_awdLoader.addEventListener(ProgressEvent.PROGRESS, load3dAssetProgress, false, 0, true);
            _awdLoader.load(new URLRequest(url));
		}
		
		///解析awd格式数据
		private function parse3DAsset(evt:Event):void
		{
			_meshList = new Array();
			///两种方法解析数据，一种是用Loader3D；另一种是用AssetLibrary；
			
			var loader3d:Loader3D = new Loader3D(false);
            loader3d.addEventListener(AssetEvent.ASSET_COMPLETE, onEachAssetReadComplete, false, 0, true);
            loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceReadAll, false, 0, true);
			switch(_fileFormat)
			{
				case "AWD": 
                case "awd":
					loader3d.loadData(_awdLoader.data, null, null, new AWD2Parser());
					break;
				case "3DS":
				case "3ds":
					loader3d.loadData(_awdLoader.data, null, null, new Max3DSParser(false));
					break;
				case "OBJ":
				case "obj":
					loader3d.loadData(_awdLoader.data, null, null, new OBJParser());
					break;
			}			
			_awdLoader.removeEventListener(ProgressEvent.PROGRESS, load3dAssetProgress);
            _awdLoader.removeEventListener(Event.COMPLETE, parse3DAsset);
            _awdLoader = null;
			
			/*switch(_fileFormat)
			{
				case "AWD": 
                case "awd":
					AssetLibrary.enableParser(AWD2Parser);
					break;
				case "3DS":
				case "3ds":
					AssetLibrary.enableParser(Max3DSParser);
					break;
				case "OBJ":
				case "obj":
					AssetLibrary.enableParser(OBJParser);
					break;
			}
			//Parsers.enableAllBundled();
			//AssetLibrary.enableParser(AWD2Parser);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onEachAssetReadComplete);
            AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceReadAll);
			AssetLibrary.loadData(_awdLoader.data);*/
            
            
		}
		
		//awd加载进度侦听处理
        private function load3dAssetProgress(e:ProgressEvent):void
		{
            var P:int = int(e.bytesLoaded / e.bytesTotal * 100);
            if (P != 100)
			{
				//log('Load : ' + P + ' % | ' + int((e.bytesLoaded / 1024) << 0) + ' ko\n');
			}
            else
			{
	           
			}
        }
		
		//资源每一项数据读取加载完毕时处理
		private function onEachAssetReadComplete(evt:AssetEvent):void
		{
			if (evt.asset.assetType == AssetType.MESH)
			{
				var mesh:Mesh = evt.asset as Mesh;
				_meshList.push(mesh);
			}
			else if (evt.asset.assetType == AssetType.MATERIAL)
			{
				
			}
			else if (evt.asset.assetType == AssetType.TEXTURE)
			{
				
			}
			else if (evt.asset.assetType == AssetType.ANIMATION_NODE)
			{
				
			}
		}
		
		//资源数据全部读取完毕时处理
		private function onResourceReadAll(e:LoaderEvent):void
		{
			this.dispatchEvent(new SLoadEvent3D(SLoadEvent3D.EVENT_ASSET_LOAD_COMPLETE, _meshList.concat(), _currentURL));
			_mPool.CloneAndFillIn(_currentURL, _meshList);
			while (_meshList.length > 0)
			{
				_meshList.pop();
			}
			
			var loader3d:Loader3D = e.target as Loader3D;
            loader3d.removeEventListener(AssetEvent.ASSET_COMPLETE, onEachAssetReadComplete);
            loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceReadAll);
			/*AssetLibrary.removeEventListener(AssetEvent.ASSET_COMPLETE, onEachAssetReadComplete);
            AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceReadAll);*/
			
			modifyLoadRunningState(false);
			
			
		}
		
		
	}

}