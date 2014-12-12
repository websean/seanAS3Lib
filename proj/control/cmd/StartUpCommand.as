package proj.control.cmd 
{
	
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	
	import proj.control.Controller;
	import proj.model.Model;
	import sean.mvc.events.GlobalEvent;
	import proj.view.MrMainDocManager;
	import proj.view.MrPopupWinManager;
	import sean.lib.TipManager;	
	import sean.mvc.interfaces.ICommand;
	import proj.view.SceneManager;
	
	public class StartUpCommand implements ICommand
	{
		
		public function StartUpCommand() 
		{
			
		}
		
		///执行启动
		public function execute(evt:GlobalEvent=null):void
		{
			Model.getIns().startUp();
			Controller.getIns().stratUp();			
			TipManager.getIns().startUp();
			MrMainDocManager.getIns().register(evt.Data);
			
			MrPopupWinManager.getIns().register((evt.Data as Main).getPopupWinContainer());
			MrPopupWinManager.getIns().startUp();
			
			SceneManager.getIns().register((evt.Data as Main).getMainSceneContainer());
			SceneManager.getIns().startUp();
			
			MrMainDocManager.getIns().startUp();
		}
		
	}

}