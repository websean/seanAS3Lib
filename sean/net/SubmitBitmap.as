package sean.net
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.adobe.serialization.json.*;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname SaveBitmap
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * sendBitmap(urlStr:String, varsStr:String, bmap:BitmapData):void				//提交BitmapData数据;
	 * getVarsData():URLVariables			//获取提交后的返回值(URLVariables格式的数据);
	 * getJsonData():*						//获取提交后的返回值(Json格式的数据);
	 * send(urlStr:String = "", val:URLVariables = null):void			//被重写为空,即此方法不起作用;
	 * 
	 * ////////公共事件/////////////
	 * 
	 * eg.
		var s:SubmitBitmap = new SubmitBitmap();
		var bitmapData:BitmapData = new BitmapData(100, 100, true, 0xff0000);
		var varsStr:String = "?t=file&user=lzdk2003";
		s.sendBitmap(urlStr, varsStr, bitmapData)
		s.addEventListener(BaseSubmitData.SUBMIT_SUCCESS, onComplete);
		
		function onComplete(e:Event):void{
			trace("complete=", e);
			trace(s.getJsonData().Status);
		}
	 */
	public class SubmitBitmap extends BaseSubmitData
	{
		private var _normalData:URLVariables;
		private var _jsonData:*;
		private var jpgStream:ByteArray
		
		public function SubmitBitmap():void
		{
			super();
		}
		
		public function sendBitmap(urlStr:String, varsStr:String, bmap:BitmapData, type:String = "jpg"):void
		{
			var _encoderType:*;
			if (type == "jpg") {
				jpgStream = (new JPGEncoder()).encode(bmap);
			} else if (type == "png"){
				jpgStream = PNGEncoder.encode(bmap);
			} else {
				return;
			}
			var str:String = urlStr + varsStr;
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			requestUrl = new URLRequest(str);
			requestUrl.requestHeaders.push(header);
			requestUrl.data = jpgStream;
			requestUrl.method = _method;	
			sendRequest(requestUrl);
		}
		override public function send(urlStr:String = "", val:URLVariables = null):void {
			//;
		}
		
		override public function getVarsData():URLVariables {
			_normalData = new URLVariables(_data.data);
			return _normalData;
		}
		
		override public function getJsonData():*{
			_jsonData = JSON.decode(_data.data);
			return _jsonData;
		}
		
	}
}