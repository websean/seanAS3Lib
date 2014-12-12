package sean.components 
{
	
	
	/**选择型按钮基本型
	 * ...
	 * @author Sean Lee
	 */
	import flash.display.MovieClip;
	import flash.events.Event;
	import sean.components.BaseHasMCSprite;
	
	public class BaseToggleButton extends BaseMCButton
	{
		protected const FRAME_TOGGLE:String = "toggle";
		
		private var _toggle:Boolean = false;
		
		public static const EVENT_TOGGLE_CHANGED:String = "EVENT_TOGGLE_CHANGED";
		
		///构造函数。label：标签文字；stuffClassName：按钮素材类名；button_MC：按钮对象，如果此值不为空，前两项值即可忽略。
		public function BaseToggleButton(label:String=null, stuffClassName:String=null, button_MC:MovieClip=null)  
		{
			super(label, stuffClassName, button_MC);
			
			
		}
		
		///设置选中状态
		public function SetToggle(toggle:Boolean):void
		{
			_toggle = toggle;
			if (toggle)
			{
				_stuffMC.getStuffMC().gotoAndStop(FRAME_TOGGLE);
				removeControl();
				_stuffMC.getStuffMC().buttonMode = false;
				this.mouseChildren = false;
				this.mouseEnabled = false;
			}
			else
			{
				_stuffMC.getStuffMC().gotoAndStop(FRAME_UP);
				addControl();
				_stuffMC.getStuffMC().buttonMode = true;
				this.mouseChildren = true;
				this.mouseEnabled = true;
			}
			
			this.dispatchEvent(new Event(EVENT_TOGGLE_CHANGED));
		}
		
		///获得选中状态
		public function GetToggleState():Boolean
		{
			return _toggle;
		}
		
		
		
	}

}