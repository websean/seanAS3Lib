package proj.model
{
	/**
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.events.EventDispatcher;
	
	public class Model extends EventDispatcher
	{
		private static var M:Model;
		
		///加载素材地址
		public static var LoaderUrl:String;
		///访问服务器地址
		public static var ServerUrl:String;

		///上次请求时间
		public var ReqTime:int;
		///用户id
		public var Uid:int;
		///用户name
		public var UName:String;
		
		public function Model() 
		{
			if (M != null)
			{
				throw(new Error("Singleton Error !!! Model Singleton already constructed! Model.as"));
			}
		}
		
		///获取实例（单例）
		public static function getIns():Model
		{
			if (M == null)
			{
				M = new Model();
			}
			return M;
		}
		
		///启动
		public function startUp():void
		{
			
		}
		
		
	}

}