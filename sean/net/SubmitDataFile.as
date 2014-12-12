package sean.net
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.FileReference;
	import com.adobe.serialization.json.*;
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * 
	 * @classname SubmitDataFile
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * getVarsData():URLVariables			//获取提交后的返回值(URLVariables格式的数据);
	 * getJsonData():*						//获取提交后的返回值(Json格式的数据);
	 * 
	 * ////////公共事件/////////////
	 * Event.CANCEL							//所有事件参考flash.events里对应的事件;
	 * Event.SELECT				
	 * DataEvent.UPLOAD_COMPLETE_DATA
	 * 
	 * eg.
		var urlStr:String = "http://127.0.0.1/index.aspx";
		sub_btn.addEventListener(MouseEvent.CLICK, onClick);
		var fileRef:FileReference;
		var s:SubmitDataFile = new SubmitDataFile();
		var val:URLVariables = new URLVariables();
		val.t = "unregsign";
		val.user = "lzdk2003";
		val.pwd = "111111";
		//trace(val);
		onBrowseHandler();

		function onClick(e:MouseEvent):void{
			s.fileRef = fileRef;
			s.send(urlStr,val);
			s.addEventListener(BaseSubmitData.SUBMIT_SUCCESS, onComplete);
		}

		function onComplete(e:Event):void{
			trace("complete=", e);
			trace(s.getJsonData().Status);
		}

		function onBrowseHandler():void {
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onSelectFileHandler, false,0, true);
			try {
				fileRef.browse([new FileFilter("Images", "*.png;*.gif;*.jpg;*.bmp")]);
			} catch (e:Error) {
				trace("browse failed");
			}
		}
		function onSelectFileHandler(e:Event):void {
			trace("fileName=", FileReference(e.target).name);
		}
	 */
	public class SubmitDataFile extends BaseSubmitData
	{
		protected var _fileRef:FileReference;
		
		private var _normalData:URLVariables;
		private var _jsonData:*;
		
		public function SubmitDataFile():void
		{
			super();
		}
		
		override public function sendRequest(request:URLRequest):void
		{	
			configureListeners(_fileRef);
			try
			{
                _fileRef.upload(request, "file");
            }
			catch (error:Error)
			{
                trace("无法提交数据!");
            }
		}
		
		override protected function configureListeners(dispatcher:IEventDispatcher):void
		{
			super.configureListeners(dispatcher);
			dispatcher.addEventListener(Event.CANCEL, cancelHandler);
            dispatcher.addEventListener(Event.SELECT, selectHandler);
            dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
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
		
		override protected function completeHandler(e:Event):void
		{
			dispatchEvent(e);
		}
		
		protected function cancelHandler(e:Event):void
		{
            //trace("cancelHandler: " + e);
			dispatchEvent(e);
        }
		
		protected function selectHandler(e:Event):void
		{
            //var file:FileReference = FileReference(e.target);
			//trace("selectHandler: name=" + file.name + " URL=" + uploadURL.url);
            //file.upload(uploadURL);
			dispatchEvent(e);
        }
		
		protected function uploadCompleteDataHandler(e:DataEvent):void
		{
            //trace("uploadCompleteData: " + e);
			_data = e;
			dispatchEvent(e);
			dispatchEvent(new Event(SUBMIT_SUCCESS));
        }
		
		///////set/get/////////
		
		public function get fileRef():FileReference { return _fileRef; }		
		public function set fileRef(value:FileReference):void
		{
			_fileRef = value;
		}
		
		
	}
}