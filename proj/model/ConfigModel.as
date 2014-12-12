package proj.model 
{
	/**配置文件数据模型
	 * ...
	 * @author Sean Lee
	 */
		
	 
	public class ConfigModel
	{
		
		///配置文件数据
		private static var _configData:XML;
		
		public function ConfigModel() 
		{
			
		}
		
		///设置配置文件数据
		public static function set ConfigData(xml:XML):void
		{
			_configData = xml;
		}
		///获取配置文件数据（只返回克隆数据）
		public static function get ConfigData():XML
		{
			return _configData.copy();
		}
		
		//==========================================================Public Static
		
		
		
	}

}