/* 
 * @author Sean Lee 2009.11.30  
 * @playerversion flash player 9    
 * @asversion 3.0   
 * @version 0.5   
 */
/*************************  
/////////////////////////@Sean Lee 2009.11.30//////////////////////////////
eg.

var so:Cookie = new Cookie("song");
var obj:Object={};
obj.id = "1112123";
obj.name = "名字";
so.put("history", obj);
trace(so.get("history").id);
trace(so.get("history").name);

////////////////////////////////////////////////////////////////////////////////////
 	//构造函数;name设置cookie名称,timeOut设置超时时间毫秒(24 * 60 * 60< * 1000> 表示24小时);
Cookie(name:String = "jdhcn", timeOut:uint=3600);

	//清除超时内容;
clearTimeOut();

	//设置/获取超时值;
setTimeOut();
getTimeOut();

	//设置/获取名称;
setName();
getName();

	//清除Cookie所有值;
clear();

	//添加Cookie值;key设置cookie属性名,value对应key的值;
put(key:String, value:*);

	//删除Cookie值;
remove(key:String);

	//获取Cookie值; 
get(key:String);

	//Cookie值是否存在;
contains(key:String);
 /////////////////////////////Sean Lee 2009.11.30////////////////////////
********************/
package sean.utils
{
	import flash.net.SharedObject;

	public class Cookie {
		private var _time:uint;
		private var _name:String;
		private var _so:SharedObject;

		public function Cookie(name:String = "jdhcn", timeOut:uint = 24 * 3600) {
			this._name = name;
			this._time = timeOut;
			init();
		}
		private function init():void {
			this._so = SharedObject.getLocal(_name, "/");
		}
		//清除超时内容;    
		public function clearTimeOut():void {
			if(_time>0){
			var obj:* = _so.data.cookie;
			if (obj == undefined) {
				return;
			}
			for (var key:String in obj) {
				if (obj[key] != undefined && obj[key].time != undefined && isTimeOut(obj[key].time)) {
					delete obj[key];
				}
			}
			_so.data.cookie = obj;
			_so.flush();
			}
		}
		private function isTimeOut(time:Number):Boolean {
			var today:Date = new Date();
			return (time + _time*1000) < today.getTime();
		}
		//设置/获取超时值;    
		public function getTimeOut():uint {	return _time; }
		public function setTimeOut(value:uint):void { 
			_time = value; 
			init();
		}
		//设置/获取名称;  
		public function getName():String { return _name; }
		public function setName(value:String):void { 
			_name = value; 
			init();
		}
		//清除Cookie所有值;    
		public function clear():void {
			_so.clear();
		}
		//添加Cookie值    
		public function put(key:String, value:*):void {
			var today:Date = new Date();
			key = "k_"+key;
			value.time = today.getTime();
			if (_so.data.cookie == undefined) {
				var obj:Object = {};
				obj[key] = value;
				_so.data.cookie = obj;
			} else {
				_so.data.cookie[key] = value;
			}
			_so.flush();
		}
		//删除Cookie值;    
		public function remove(key:String):void {
			if (contains(key)) {
				delete _so.data.cookie["k_" + key];
				_so.flush();
			}
		}
		//获取Cookie值;    
		public function get(key:String):Object {
			return contains(key) ? _so.data.cookie["k_" + key] : null;
		}
		//Cookie值是否存在;    
		public function contains(key:String):Boolean {
			key = "k_" + key;
			return _so.data.cookie != undefined && _so.data.cookie[key] != undefined;
		}
	}
}