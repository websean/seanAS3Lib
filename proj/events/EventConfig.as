package proj.events 
{
	
	/**事件名集合
	 * ...
	 * @author Sean Lee
	 */
	public class EventConfig
	{
		
		public function EventConfig() 
		{
			
		}

		///提示框确定
		public static const POPUP_MSG_WIN_OK_HANDLE:String = "POPUP_MSG_WIN_OK_HANDLE";
		///提示框取消
		public static const POPUP_MSG_WIN_CANCEL_HANDLE:String = "POPUP_MSG_WIN_CANCEL_HANDLE";
		
		//======================主场景操作=============================================
		///请求切换不同主人的场景
		public static const REQ_SWITCH_OTHER_MASTER_SCENE:String = "REQ_SWITCH_OTHER_MASTER_SCENE";
		///切换不同主人的场景完成
		public static const SWITCH_OTHER_MASTER_SCENE_COMPLETE:String = "SWITCH_OTHER_MASTER_SCENE_COMPLETE";
		
		
		
		
		//======================主场景数据更新=============================================
		///获得用户信息初始化事件名
		public static const UPDATE_USER_INFO:String = "UPDATE_USER_INFO";
		///更新场景主人信息事件名
		public static const UPDATE_SCENE_MASTER_INFO:String = "UPDATE_SCENE_MASTER_INFO";
		///更新好友列表数据
		public static const UPDATE_FRIENDS_LIST_DATA:String = "UPDATE_FRIENDS_LIST_DATA";
		
		
		
		
	}

}