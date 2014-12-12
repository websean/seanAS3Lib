package sean.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * JDHCN组件的 GlobalJS 类
	 * @classname GlobalJS
	 * 与显示对象无关的公共方法;
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * getUrl(value:String):String			//获取地址栏url字符串中参数值的部分(默认是href的值, eg.value为hostname则返回localhost);
	 * getUrlVars():Object					//获取地址栏url参数对象值;
	 * openWin(url, target:String="_blank", behind:Boolean=false):void				//打开链接地址, url:链接地址, target:窗口方式, behind:是否为背投打开;
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class GlobalJS
	{
		
		///获取地址栏url字符串中参数值的部分(默认是href的值, eg.value为hostname则返回localhost);
		public static function getUrl(value:String = "href"):String
		{
			return getJsStr(value.toLowerCase());
		}
		
		///获取地址栏url字条串;
		public static function getHref():String
		{
			return getJsStr("href");
		}
		
		///获取地址栏url的协议部分(eg.http:);
		public static function getProtocol():String
		{
			return getJsStr("protocol");
		}
		
		///获取地址栏url的获取主机名称和端口号(eg.localhost:8080);
		public static function getHost():String
		{
			return getJsStr("host");
		}
		
		///获取地址栏url获取主机名称(eg.localhost);
		public static function getHostname():String
		{
			return getJsStr("hostname");
		}
		
		///获取地址栏url的端口号(eg.8080);
		public static function getPort():String
		{
			return getJsStr("port");
		}
		
		///获取地址栏url的路径部分(就是文件地址, eg./web/index.html);
		public static function getPathname():String
		{
			return getJsStr("pathname");
		}
		
		///获取地址栏url的锚点(eg.#imhere);
		public static function getHash():String
		{
			return getJsStr("hash");
		}
		
		private static function getJsStr(value:String):String
		{
			var jsStr:String = "(function (){var a=document.location." + value + "; return a;})()";
			var str:String = "";
			if (ExternalInterface.available)
			{
				str = String(ExternalInterface.call("eval", jsStr));
			}
			return str;
		}
		
		//获取地址栏url参数对象值(eg.?item=1&tab=2);
		public static function getUrlVars():Object
		{
			var obj:URLVariables = new URLVariables();
			var jsStr:String = "(function (){var a=document.location.search; if(a=='') return 'hasItem=false'; return a.substr(1)+'&hasItem=true';})()";
			var str:String = "";
			if (ExternalInterface.available)
			{
				str = String(ExternalInterface.call("eval", jsStr));
				if (str == "null")
				{
					str = "hasItem=false";
				}
				obj.decode(str);
			}
			return obj;
		}
		
		//打开链接地址, url:链接地址, target:窗口方式, behind:是否为背投打开;
		public static function openWin(url, target:String = "_blank", behind:Boolean = false):void
		{
			var open:XML = <script><![CDATA[
			function aa(url,t,behind){if(!url)return;if(!t)t='_blank';f='toolbar=yes,menubar=yes,location=yes,directories=yes,status=yes,resizable=yes,scrollbars=yes';			var win=window.open(url,t,f);if(win!=null){if(behind){win.blur();win.opener.focus();}}}
			]]></script>;
			
			if (ExternalInterface.available)
			{
				ExternalInterface.call(open, url, target, behind);
			}
		}
		
	}
}