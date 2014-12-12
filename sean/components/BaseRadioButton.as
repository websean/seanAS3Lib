package sean.components 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.VideoEvent;
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class BaseRadioButton extends BaseMCButton 
	{
		private var _selected_mc:MovieClip;
		
		private var _selected:Boolean = false;
		
		///构造函数。label：标签文字；stuffClassName：按钮素材类名；button_MC：按钮对象，如果此值不为空，前两项值即可忽略。
		public function BaseRadioButton(Label:String=null, stuffClassName:String=null, button_MC:MovieClip=null) 
		{
			super(Label, stuffClassName, button_MC);
			
			_selected_mc = _stuffMC.getMCByName("selected_mc");
			_selected_mc.visible = _selected;
			_stuffMC.addEventListener(MouseEvent.CLICK, onBtnClick_handle);
		}
		
		///设置选中状态
		public function SetSelected(selected:Boolean):void
		{
			_selected = selected;
			if (_selected)
			{
				_selected_mc.visible = true;
			}
			else
			{
				_selected_mc.visible = false;
			}
		}
		
		///获得选中状态
		public function GetSelectedState():Boolean
		{
			return _selected;
		}
		
		
		//=============================================================handle
		//单击时处理
		private function onBtnClick_handle(evt:MouseEvent):void
		{
			SetSelected(!_selected);
		}
		
		
	}

}