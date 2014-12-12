package proj.view 
{
	
	
	/**场景管理器
	 * ...
	 * @author Sean Lee
	 */
	
	import proj.view.vj.fx.Pixelator;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import sean.mvc.events.GlobalEvent;
	import sean.mvc.patterns.Mediator;
	
	public class SceneManager extends Mediator
	{
		private static var SM:SceneManager;
		
		private var _sceneContainer:Sprite;
		
		//当前场景
		private var _currentScene:Sprite;
		//将要显示的场景
		private var _newScene:Sprite;
		
		private var _currentSceneBMP:Bitmap;
		private var _newSceneBMP:Bitmap;
		
		//场景切换器
		private var _sceneSwitcher:Pixelator;
		//场景切换目标场景类型id
		private var _targetSceneID:int;
		
		public function SceneManager() 
		{
			super();
			if (SM != null)
			{
				throw(new Error("Singleton Error !!! SceneManager.as"));
			}
		}
		
	
	///获取单例的实例
	public static function getIns():SceneManager
	{
		if (SM == null)
		{
			SM = new SceneManager();
		}
		return SM;
	}
	
	///启动
	public function startUp():void
	{
		
		initControl();
		
		clearScene();
		
	}
	
	private function clearScene():void
	{
		if (_sceneContainer)
		{
			while (_sceneContainer.numChildren > 0)
			{
				_sceneContainer.removeChildAt(0);
			}
		}
	}
		
	
	///注册管理对象
	override public function register(target:DisplayObject):void
	{
		super.register(target);
		
		_sceneContainer = target as Sprite;
		
		if (!_sceneContainer || !(_sceneContainer is Sprite))
		{
			throw("_sceneContainer容器对象错误！！！SceneManager.as");
		}
	}
	
	///切换场景
	public function switchScene(newScene:Sprite):void
	{
		_newScene = newScene;
		
		if (_currentScene && _newScene)
		{
			if (_sceneContainer.contains(_currentScene))
			{
				_sceneContainer.removeChild(_currentScene);
			}
			_sceneContainer.addChild(_newScene);
			
			var stage_w:Number = _sceneContainer.stage.stageWidth;
			var stage_h:Number = _sceneContainer.stage.stageHeight;
			var newBmpd:BitmapData = new BitmapData(stage_w,stage_h);
			newBmpd.draw(_newScene, null, null, null, new Rectangle( -_newScene.x, -_newScene.y, stage_w, stage_h), false);
			
			var currentBmpd:BitmapData = new BitmapData(stage_w,stage_h);
			currentBmpd.draw(_currentScene, null, null, null, new Rectangle( -_currentScene.x, -_currentScene.y, stage_w, stage_h), false);
			
			_currentSceneBMP = new Bitmap(currentBmpd);
			_newSceneBMP = new Bitmap(newBmpd);
			_sceneSwitcher = new Pixelator(_currentSceneBMP, _newSceneBMP, 100);
			_sceneContainer.addChild(_sceneSwitcher);
			_sceneSwitcher.startTransition(Pixelator.PIXELATION_FAST);
			
		}
		else
		{
			if (_newScene)
			{
				clearScene();
				_sceneContainer.addChild(_newScene);
			}
		}
		
		
		//切换结束后
		if (_newScene)
		{
			_currentScene = _newScene;
		}		
		_newScene = null;
	}
	
	//============================================================================================Private
	//初始化控制
	private function initControl():void
	{
		
	}
	
	
	//============================================================================================Handle
		

	}
}