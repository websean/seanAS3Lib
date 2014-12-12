package sean.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 *
	 * @classname Global
	 * 与显示对象无关的公共方法;
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * traceStr(str:String);			//输出调试值;
	 * getUrlVars(s:String);			//获取url参数变量值;
	 * openWin(url:String, target:String="_blank", behind:Boolean=false);		//打开链接地址, url:链接地址, target:窗口方式, behind:是否为背投打开;
	 * runJs(s:String);			//运行在flash里写js函数;
	 * formatString(str:String, type:String="");			//各种类型的正则表达式匹配;
	 * trim(str:String);		//删除str的前导后导空格;
	 * replace(str:String, t1:String, t2:String);			//将str里所有的字符t1替换为t2(注:t1得为正则里的非特殊字符);
	 * strLen(str:String);				//求字符串长度(全角字符长度为2);
	 * replaceToSpace(str:String);		//将换页符/制表符/回车符/换行符替换为空格;
	 * TowPointAngle(x1:Number, y1:Number, x2:Number, y2:Number):int;			//求两点之间的角度(0~360);
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class Global
	{
		
		///输出调试值;
		public static function traceStr(str:*):void
		{
			trace(str);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("g.flashDebug.trace", str.toString());
				}
				catch (e)
				{
					trace("注意: (此错误在flash环境下可忽略!)>> " + e);
				}
			}
		}
		//在flash里写js函数并运行; 
		/*eg.
		var abc:XML = <script><![CDATA[
			function aa(){return "abc is String";};
			return aa();
			]]></script>;
		Global.runJs(abc);
		*/
		public static function runJs(s:String):*
		{
			if (ExternalInterface.available)
			{
				return ExternalInterface.call("eval", "(function(){" + s +";return;})()");
			}
			return;
		}
		
		///获取url参数变量值;
		public static function getUrlVars(s:String):String
		{
			if (ExternalInterface.available)
			{
				return ExternalInterface.call("g.getUrlVars", s);
			}
			return "";
		}
		
		///打开链接地址, url:链接地址, target:窗口方式, behind:是否为背投打开;
		public static function openWin(url:String, target:String = "_blank", behind:Boolean = false):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("g.openWin", url, target, behind);
			}
		}
		
		///各种类型的正则表达式匹配;
		public static function formatString(str:String, type:String = ""):String
		{
			var regExp:RegExp = /\s+/g;
			str=str.replace(regExp,"");
			switch (type) {
				case "cellphone" :
					regExp = /^(1[3|5]\d{9})$/;
					if (!regExp.test(str)) { return ""; }
					break;
				case "email" :
					regExp = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
					if (!regExp.test(str)) { return ""; }
					break;
				case "number" :
					regExp = /^[0-9]/;
					if (!regExp.test(str)) { return ""; }
					break;
				case "years" :
					regExp = /^(19[0-9][0-9]\d{0})$|(200[0-8]\d{0})$/;
					if (!regExp.test(str)) { return ""; }
					break;
				case "months" :
					regExp = /^([1-9]\d{0})$|^(0[1-9]\d{0})$|^(1[0-2]\d{0})$/;
					if (!regExp.test(str)) { return ""; }
					break;
				case "days" :
					regExp = /^([1-9]\d{0})$|^(0[1-9]\d{0})$|^([1-2][0-9]\d{0})$|^(3[0-1]\d{0})$/;
					if (!regExp.test(str)) { return ""; }
					break;
				case "url" :
					regExp = /^http|https|ftp:\/\/[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
					if (!regExp.test(str)) { return ""; }
				default :
			}
			return str;
		}
		
		///删除str的前导后导空格;
		public static function trim(str:String):String
		{
			return str.replace(/(^\s*)|(\s*$)/g, "");
		}
		
		///将str里所有的字符t1替换为t2;
		///注:t1得为正则里的非特殊字符;
		public static function replace(str:String, t1:String, t2:String):String
		{			
			var myPattern:RegExp = new RegExp(t1,"g");
			return str.replace(myPattern, t2);
		}
		
		///求字符串长度全角字符长度为2;
		public static function strLen(str:String):int
		{
			return str.replace(/[^\uFF00-\uFFFF]/g,"aa").length;
		}
		
		///将换页符/制表符/回车符/换行符替换为空格;
		public static function replaceToSpace(str:String):String
		{
			return str.replace(/[\f\n\r\t]/g," ")
		}
		
		///求两点之间的角度(0~360);
		public static function TowPointAngle(x1:Number, y1:Number, x2:Number, y2:Number):int
		{
			var t:Number = (y1-y2)/(x1-x2);
			var a:Number = Math.atan(t) * 180 / Math.PI;
			
			if (x1 < x2)
			{
				a = 180 + a;
			}
			else if (y1 < y2)
			{
				a = 360 + a;
			}
			return int(a);
		}
		
		///强制触动flash player的垃圾回收机制
		public static function GC():void
		{
			try
			{
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			}
			catch (e:Error){ }
		}
		
	}
}