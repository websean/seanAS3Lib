package sean.components 
{
	
	
	/**
	 * ...
	 * @author Sean Lee 20014.03.11
	 */
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class BaseHasMCSprite extends Sprite
	{
		private var _stuff_mc:MovieClip;
		
		private var _currentStuffMCClass_name:String;		
		
		public function BaseHasMCSprite(stuffMCClass_name:String = null) 
		{
			_currentStuffMCClass_name = stuffMCClass_name;
			
			initView(stuffMCClass_name);				
			
		}
		
		///获取库素材MovieClip
		public function getStuffMC():MovieClip
		{
			return _stuff_mc;
		}
		
		///设置库素材MovieClip
		public function addInStuffMC(mc:MovieClip):void
		{
			reSetStuff("");
			_stuff_mc = mc;
			this.x = _stuff_mc.x;
			this.y = _stuff_mc.y;
			_stuff_mc.x = 0;
			_stuff_mc.y = 0;
			addChildAt(_stuff_mc,0);
		}
		
		///重新设定视图
		public function reSetStuff(stuffMCClass_name:String):void
		{
			if (stuffMCClass_name == _currentStuffMCClass_name)
			{
				//return;
			}
			else
			{
				_currentStuffMCClass_name = stuffMCClass_name;
			}
			
			//先清除原有
			if (_stuff_mc)
			{
				_stuff_mc.mouseChildren = false;
				_stuff_mc.mouseEnabled = false;
				if (this.contains(_stuff_mc))
				{
					this.removeChild(_stuff_mc);
				}
			}			
			//再重新初始化
			initView(stuffMCClass_name);
			
		}
		
		private function initView(className:String):void
		{
			if (!className)
			{
				return;
			}
			
			try
			{
				var stuffClass:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;				
				_stuff_mc = new stuffClass();
				addChildAt(_stuff_mc,0);
			}
			catch (e:Error)
			{
				trace("库里找不到对应的类：",className==""?"null name":className,e);
			}
			
			supplementInitView();
			supplementInitControl();
		}
		
		///可以被重写（初始化界面的补充内容）
		protected function supplementInitView():void
		{
			
		}
		
		///可以被重写（初始化控制的补充内容）
		protected function supplementInitControl():void
		{
			
		}
		
		//根据MC名称创建BaseMCBtn
		public function getBaseMCBtnByName(mcName:String):BaseMCButton
		{
			var baseMCBtn:BaseMCButton = new BaseMCButton(null, null, getStuffMC().getChildByName(mcName) as MovieClip );
			if (baseMCBtn)
			{				
				this.getStuffMC().addChild(baseMCBtn);
				
				return baseMCBtn;
			}
			
			return null ;
		}

		//根据名称获取TextField
		public function getTxtByName(nameStr:String , selectable:Boolean = false):TextField
		{
			var gettxt:TextField = getStuffMC().getChildByName(nameStr) as TextField ;
			if (gettxt)
			{
				gettxt.selectable = selectable ;
				return  gettxt ;
			}
			
			return null ;
		}
		
		//根据名称获取MovieClip
		public function getMCByName(nameStr:String , mcmouseChildren:Boolean = true , mcbuttonMode:Boolean = false):MovieClip
		{
			var getmc:MovieClip = getStuffMC().getChildByName(nameStr) as MovieClip;
			if (getmc)
			{
				getmc.mouseChildren = mcmouseChildren;
				getmc.buttonMode = mcbuttonMode;
				return  getmc;
			}
			
			return null;
		}
		
		
	}

}