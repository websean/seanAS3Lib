package sean.utils
{
	import flash.net.SharedObject;
	import jdhcn.global.Cookie;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname CookieSingle
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * getInstance():CookieSingle					//获取此单例类的实例方法;
	 * setParam(name:String = "jdhcn", timeOut:uint = 24 * 3600):void				//name表示cookie的文件名, timeOut表示cookie有效时间(默认文件名为jdhcn.sol, 路径为根路径, cookie有效期为24小时);
	 * put(key:String, value:*):void				//将数据写入cookie;
	 * get(key:String):Object						//读取与key对应的cookie值;
	 * remove(key:String):void						//删除与key对应的cookie值;
	 * clear():void									//清除所有的cookie数据;
	 * clearTimeOut():void							//清除过期的cooie数据;
	 * contains(key:String):Boolean					//检测对应key的cookie值是否存在;
	 * 
	 * ////////公共事件/////////////
	 * 
	 * eg.
		var obj:Object={};
		obj.id = "1112123";
		obj.name = "名字";
		CookieSingle.getInstance().setParam("songs", 30);
		CookieSingle.getInstance().put("history", obj);
		CookieSingle.getInstance().clearTimeOut();
		trace(CookieSingle.getInstance().contains("history"));
	 */
	public class CookieSingle
	{
		private static var _instance:CookieSingle;
		private static var _cookie:Cookie;
		
		public function CookieSingle(oneClass:OneClass):void
		{
			if (oneClass == null)
			{
				throw new Error("此类为单例类, 请使用getInstance()获取实例");
			}
		}
		
		public static function getInstance():CookieSingle
		{
			if (_instance == null)
			{
				_instance = new CookieSingle(new OneClass());
				_cookie = new Cookie();
			}
			return _instance;
		}
		public function setParam(name:String = "jdhcn", timeOut:uint = 24 * 3600):void
		{
			_cookie = new Cookie(name, timeOut);
		}
		
		public function put(key:String, value:*):void
		{
			_cookie.put(key, value);
		}
		
		public function get(key:String):Object
		{
			return _cookie.get(key);
		}
		
		public function remove(key:String):void
		{
			_cookie.remove(key);
		}
		
		public function clear():void
		{
			_cookie.clear();
		}
		
		public function clearTimeOut():void
		{
			_cookie.clearTimeOut();
		}
		
		public function contains(key:String):Boolean
		{
			return _cookie.contains(key);
		}
		
		
	}
}

class OneClass{}