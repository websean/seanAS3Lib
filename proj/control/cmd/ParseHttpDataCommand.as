package proj.control.cmd 
{
	
	
	/**报文解析命令
	 * ...
	 * @author Sean Lee
	 */
	
	import sean.mvc.events.GlobalEvent;
	import sean.mvc.interfaces.ICommand;
	
	public class ParseHttpDataCommand implements ICommand
	{
		private var _serverData:XML;
		
		public function ParseHttpDataCommand() 
		{
			
		}
		
		public function execute(evt:GlobalEvent=null):void
		{
			_serverData = XML(evt.Data);

			if (int(_serverData.@reqTime) > 0)
			{
				//Model.getIns().ReqTime = int(_serverData.@reqTime);
			}

			for each(var node:* in _serverData.children())
			{
				if (node)
				{
					parseEachNode(node);
				}
			}
		}
		
		//节点解析方法
		private function parseEachNode(node:*):void
		{
			var eventName:String = XML(node).@event;
			switch(eventName)
			{
				case "1":
				break;
			}
		}
		
		
		
	}

}