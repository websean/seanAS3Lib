package sean.air 
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**本地文件读写操作
	 * ...
	 * @author Sean Lee
	 */
	public class LocalFile 
	{
		
		public function LocalFile() 
		{
			
		}
		
		private var _fileContentStr:String;
		///对外方法写本地文件（文本）（自选保存路径）（fileName:文件名, fileContent:文本文件字符串内容）
		public function WriteTXTFile(fileName:String, fileContent:String):void
		{
			var file:File = File.desktopDirectory.resolvePath(fileName);
			file.addEventListener(Event.SELECT, onFilePathSelcted_handle);
			file.browseForSave("保存");
			_fileContentStr = fileContent;
		}
		
		//直接写本地文件（同步写入）（单个）
		private function writeSingleFile(file:File, fileContent:String):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(fileContent);
			fileStream.close();
		}
		
		//保存文件的路径选择完毕时处理
		private function onFilePathSelcted_handle(evt:Event):void
		{
			var file:File = evt.currentTarget as File;
			file.removeEventListener(Event.SELECT, onFilePathSelcted_handle);
			writeSingleFile(file, _fileContentStr);
		}
		
	}

}