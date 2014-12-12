package sean.net.loadData
{
	
	/**
	 * ...
	 * @author Sean Lee 2009.12.03
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname LoadDataType
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class LoadDataType extends Object
	{
		private var _url:String = "";
		private var _kind:String = "";
		
		public function LoadDataType(urlSTr:String = "", kindStr:String = ""):void
		{
			_url = urlSTr;
			_kind = kindStr;
		}
		
		public function toString():String
		{
			return "LoadDataType->\n[ url=" + _url + ", kind=" + _kind + " ]";
		}
		
		public function get url():String { return _url; }		
		public function set url(value:String):void {
			_url = value;
		}
		
		public function get kind():String { return _kind; }		
		public function set kind(value:String):void
		{
			_kind = value;
		}
	}
	
}