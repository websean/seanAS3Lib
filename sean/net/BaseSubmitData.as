package sean.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname BaseSubmitData
	 * @methods
	 * ///////公共属性/////////
	 * method():String				设置/获取提交数据的方式;
	 * serverUrl():String			设置/获取服务的url地址;
	 * urlVars():URLVariables		设置/获取请求服务地址的变量参数;
	 * 
	 * ///////公共方法/////////
	 * getData():URLVariables			//获取提交后的返回值(普通的字符串数据);
	 * send(urlStr:String = "", val:URLVariables = null)			//提交数据(如果后面的参数省略，则公共属性里设置的值为使用对象;
	 * sendRequest(request:URLRequest)						//提交数据(所有数据均组织到此参数中来提交数据);
	 * 
	 * ////////公共事件/////////////
	 * Event.COMPLETE							//所有事件参考flash.events里对应的事件;
	 * Event.OPEN
	 * ProgressEvent.PROGRESS
	 * SecurityErrorEvent.SECURITY_ERROR
	 * TTPStatusEvent.HTTP_STATUS
	 * IOErrorEvent.IO_ERROR
	 */
	public class BaseSubmitData	extends EventDispatcher {
		protected var loader:URLLoader;
		protected var requestUrl:URLRequest;
		protected var _data:Object;
		
		protected var _serverUrl:String;		
		protected var _urlVars:URLVariables;
		protected var _method:String = URLRequestMethod.POST;
		
		public static const SUBMIT_SUCCESS:String = "submit_success";
		
		public function BaseSubmitData():void
		{
			
		}
		
		public function send(urlStr:String = "", val:URLVariables = null):void
		{
			if (val != null)
			{
				_urlVars = val;
			}
			if (urlStr != "")
			{
				_serverUrl = urlStr;
			}
			requestUrl = new URLRequest(_serverUrl);
			requestUrl.data = _urlVars;
			requestUrl.method = _method;	
			sendRequest(requestUrl);
		}
		
		public function sendRequest(request:URLRequest):void
		{
			loader = new URLLoader();
			configureListeners(loader);
			try
			{
                loader.load(request);
            }
			catch (error:Error)
			{
                trace("无法提交数据!");
            }
		}
		
		protected function configureListeners(dispatcher:IEventDispatcher):void
		{
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        protected function completeHandler(e:Event):void
		{
			_data = URLLoader(e.target);
			dispatchEvent(e);
			dispatchEvent(new Event(SUBMIT_SUCCESS));
        }

        protected function openHandler(e:Event):void
		{
            //trace("openHandler: " + e);
			dispatchEvent(e);
        }

        protected function progressHandler(e:ProgressEvent):void
		{
           // trace("progressHandler loaded:" + e.bytesLoaded + " total: " + e.bytesTotal);
			dispatchEvent(e);
        }

        protected function securityErrorHandler(e:SecurityErrorEvent):void
		{
            //trace("securityErrorHandler: " + e);
			dispatchEvent(e);
        }

        protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
            //trace("httpStatusHandler: " + e);
			dispatchEvent(e);
        }

        protected function ioErrorHandler(e:IOErrorEvent):void
		{
            //trace("ioErrorHandler: " + e);
			dispatchEvent(e);
        }
		
		public function getData():String
		{
			return _data.data;
		}
		
		//////需要重写的函数/////
		public function getVarsData():URLVariables
		{
			return null;
		}
		
		public function getJsonData():*
		{
			return null;
		}
		
		///////set/get////////	
		public function get method():String { return _method; }		
		public function set method(value:String):void
		{
			_method = value;
		}
		
		public function get serverUrl():String { return _serverUrl; }		
		public function set serverUrl(value:String):void
		{
			_serverUrl = value;
		}
		
		public function get urlVars():URLVariables { return _urlVars; }		
		public function set urlVars(value:URLVariables):void
		{
			_urlVars = value;
		}
	}
}