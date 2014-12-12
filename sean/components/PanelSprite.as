package sean.components 
{
	
	/**自定义面板容器基类组件
	 * ...
	 * @author Sean Lee
	 */
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import sean.components.BaseHasMCSprite;
	
	public class PanelSprite extends BaseHasMCSprite
	{
		//默认对应素材库类名
		private static const DefaultStuffClassName:String = "Panel_MC";
		
		//内容容器
		protected var _container:Sprite;		
		//内容遮罩
		protected var _containerMasker:Sprite;
		
		//关闭按钮
		protected var _closeBtn:BaseMCButton;
		//白背景
		protected var _whiteBg:MovieClip;
		
		//标题文本
		protected var _title_txt:TextField;
		
		public function PanelSprite(stuffClassName:String=null) 
		{
			var className:String = stuffClassName;
			if (!className)
			{
				className = DefaultStuffClassName;
			}
			super(className);
			
			initControl();
		}
		
		//初始化视图
		override protected function supplementInitView():void 
		{
			super.supplementInitView();
			
			_closeBtn = new BaseMCButton(null, null, super.getStuffMC().getChildByName("close_mc") as MovieClip);			
			super.getStuffMC().addChild(_closeBtn);
			
			_title_txt = super.getStuffMC().getChildByName("title_txt") as TextField;
			_title_txt.selectable = false;
			_title_txt.text = "";
			
		}
		
		override public function get height():Number { return super.getStuffMC().height; }
		
		override public function set height(value:Number):void 
		{
			super.height = value;
		}
		
		override public function get width():Number { return super.getStuffMC().width; }
		
		override public function set width(value:Number):void 
		{
			super.width = value;
		}
		
		//初始化控制
		protected function initControl():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick_handle);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onThisBeAddToStage_handle);
		}
		
		
		//=================================================================================================Handle
		//当单击关闭按钮时处理
		protected function onCloseBtnClick_handle(evt:MouseEvent):void
		{
			
		}
		
		//当被添加到舞台上时处理
		protected function onThisBeAddToStage_handle(evt:Event):void
		{
			
		}
		
	}

}