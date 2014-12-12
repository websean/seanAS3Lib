package sean.components 
{
	import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
	
	/**以图形为基本元素的按钮
	 * ...
	 * @author Sean Lee
	 */
	
	/* 
		[Embed(source = "/../ui/fresh.png")]
		private var FreshBMP:Class;
		[Embed(source = "/../ui/fresh_over.png")]
		private var FreshOverBMP:Class;
		var _freshBtn:ImgButton = new ImgButton(new FreshBMP(), new FreshOverBMP());
	*/
	public class ImgButton extends Sprite 
	{
		///通常状态图
		private var _upBMP:Bitmap;
		///鼠标移进状态图
		private var _overBMP:Bitmap;
		///鼠标按下状态图
		private var _downBMP:Bitmap;
		///按钮禁用状态图
		private var _disableBMP:Bitmap;
		
		private var _available:Boolean = true;
		
		public function ImgButton(upBMP:Bitmap, overBMP:Bitmap = null, downBMP:Bitmap = null, disableBMP:Bitmap = null)
		{
			super();
			_upBMP = upBMP;
			if (overBMP != null)
			{
				_overBMP = overBMP;
				this.addChild(_overBMP);
				_overBMP.visible = false;
			}
			
			if (downBMP != null)
			{
				_downBMP = downBMP;
				this.addChild(_downBMP);
				_downBMP.visible = false;
			}
			
			if (disableBMP != null)
			{
				_disableBMP = disableBMP;
				this.addChild(_disableBMP);
				_disableBMP.visible = false;
			}
			
			
			this.addChild(_upBMP);
			
			
			Available = true;
		}
		
		//添加侦听
		private function addControl():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, onThisRollOver_handle);
			this.addEventListener(MouseEvent.ROLL_OUT, onThisRollOut_handle);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onThisMouseDown_handle);
			this.addEventListener(MouseEvent.MOUSE_UP, onThisMouseUp_handle);
		}
		
		//移除侦听
		private function removeControl():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, onThisRollOver_handle);
			this.removeEventListener(MouseEvent.ROLL_OUT, onThisRollOut_handle);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onThisMouseDown_handle);
			this.removeEventListener(MouseEvent.MOUSE_UP, onThisMouseUp_handle);
		}
		
		///设置按钮可用状态
		public function set Available(isAvailable:Boolean):void
		{
			_available = isAvailable;
			if (isAvailable)
			{
				this.buttonMode = true;
				addControl();
				
				if (_overBMP)
				{
					_overBMP.visible = false;
				}
				if (_downBMP)
				{
					_downBMP.visible = false;
				}
				_upBMP.visible = true;
			}
			else
			{
				this.buttonMode = false;
				removeControl();
				
				if (_disableBMP)
				{
					if (_overBMP)
					{
						_overBMP.visible = false;
					}
					if (_downBMP)
					{
						_downBMP.visible = false;
					}
					_upBMP.visible = false;
					_disableBMP.visible = true;
				}
			}
		}
		
		//============================================================Handle
		//鼠标移进时处理
		private function onThisRollOver_handle(evt:MouseEvent):void
		{
			if (_overBMP)
			{
				_overBMP.visible = true;
				if (_downBMP)
				{
					_downBMP.visible = false;
				}
				_upBMP.visible = false;
			}
		}
		
		//鼠标移出时处理
		private function onThisRollOut_handle(evt:MouseEvent):void
		{
			if (_overBMP)
			{
				_overBMP.visible = false;
			}
			if (_downBMP)
			{
				_downBMP.visible = false;
			}
			_upBMP.visible = true;
		}
		
		//鼠标按下时处理
		private function onThisMouseDown_handle(evt:MouseEvent):void
		{
			
			if (_downBMP)
			{
				_downBMP.visible = true;
				_upBMP.visible = false;
				if (_overBMP)
				{
					_overBMP.visible = false;
				}
			}
			
		}
		
		//鼠标弹起时处理
		private function onThisMouseUp_handle(evt:MouseEvent):void
		{
			_upBMP.visible = true;
			if (_overBMP)
			{
				_overBMP.visible = false;
			}
			if (_downBMP)
			{
				_downBMP.visible = false;
			}
		}
		
	}

}