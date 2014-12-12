package sean.net
{
	import flash.net.URLVariables;
	import com.adobe.serialization.json.*;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname SubmitData
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * getVarsData():URLVariables			//获取提交后的返回值(URLVariables格式的数据);
	 * getJsonData():*						//获取提交后的返回值(Json格式的数据);
	 * 
	 * ////////公共事件/////////////
	 * 
	 * eg.
		var urlStr:String = "http://127.0.0.1/index.aspx";
		var s:SubmitData = new SubmitData();
		
		var val:URLVariables = new URLVariables();
		val.t = "login";
		val.user = "lzdk2003";
		val.pwd = "xxxx";
		
		s.send(urlStr,val);
		s.addEventListener(BaseSubmitData.SUBMIT_SUCCESS, onComplete);
		
		function onComplete(e:Event):void{
			trace("complete=", e);
			trace(s.getJsonData().Status);
		}
	 */
	public class SubmitData extends BaseSubmitData
	{
		private var _normalData:URLVariables;
		private var _jsonData:*;
		
		public function SubmitData():void
		{
			super();
		}
		
		override public function getVarsData():URLVariables
		{
			_normalData = new URLVariables(_data.data);
			return _normalData;
		}
		
		override public function getJsonData():*
		{
			_jsonData = JSON.decode(_data.data);
			return _jsonData;
		}
	}
}