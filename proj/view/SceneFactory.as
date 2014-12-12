package proj.view 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class SceneFactory 
	{
		private static var SF:SceneFactory;
		
		private var _sceneList:Vector.<BaseScene>;
		
		public function SceneFactory() 
		{
			if (SF != null)
			{
				throw(new Error("Singleton Error! SceneFactory"));
			}
			_sceneList = new Vector.<BaseScene>();
		}
		
		public static function getIns():SceneFactory
		{
			if (SF == null)
			{
				SF = new SceneFactory();
			}
			
			return SF;
		}
		//待机场景
		public static const TYPE_StandBy:String = "Scene_TYPE_StandBy";
		//捕鱼场景
		public static const TYPE_CatchFish:String = "Scene_TYPE_CatchFish";
		
		public function getScene(type:String):BaseScene
		{
			var scene:BaseScene;
			scene = findSceneByType(type);
			if (scene == null)
			{
				switch(type)
				{
					case TYPE_StandBy:					
						scene = new BaseScene(type);
					break;
					
					case TYPE_CatchFish:					
						scene = new BaseScene(type);
					break;
				}
				_sceneList.push(scene);
			}			
			return scene;
		}
		
		private function findSceneByType(type:String):BaseScene
		{
			for each(var s:BaseScene in _sceneList)
			{
				if (s.Type == type)
				{
					return s;
				}
			}
			return null;
		}
		
	}

}