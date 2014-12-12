package sean.components 
{
	
	/**头像装载器
	 * ...
	 * @author Sean Lee
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import sean.utils.SeanUtils;
	
	public class ImgBox extends Sprite
	{
		private var _loader:Loader;
		private var _imgCT:Sprite;
		
		private var _bmpD_W:Number;
		private var _bmpD_H:Number;
		
		private var _beInMiddle:Boolean;
		private var _modifyConsult:DisplayObject;
		
		private var _iconBMP:Bitmap;
		
		///装载器背景
		private var _iconBG:DisplayObject;
		///icon显示信息参照物
		private var _iconConsult:DisplayObject;
		
		public static const EVENT_IconLoadComplete:String = "EVENT_IconLoadComplete";
		
		public function ImgBox(iconBG:DisplayObject = null, iconConsult:DisplayObject = null) 
		{
			_loader = new Loader();			
			
			_imgCT = new Sprite();
			
			addChild(_imgCT);
			
			_iconBG = iconBG;
			_iconConsult = iconConsult;
			if (_iconBG != null)
			{
				addChildAt(_iconBG, 0);
			}
			if (_iconConsult != null)
			{
				_iconConsult.visible = false;
			}
		}
		
		///设置数据并初始化(urlIsBmpDClass表示url是链接还是BitmapData类名,modifyCoordinateInMiddle表示是否调整图片坐标居中,modifyConsult是坐标调整参照物)
		public function setData(url:String, bmpD_W:Number=0, bmpD_H:Number=0, urlIsBmpDClass:Boolean=false, modifyCoordinateInMiddle:Boolean=false, modifyConsult:DisplayObject=null,urlIsMCClass:Boolean = false):void
		{
			while(_imgCT.numChildren > 0)
			{
				if (_imgCT.getChildAt(0) is Bitmap)
				{
					(_imgCT.getChildAt(0) as Bitmap).bitmapData.dispose();
				}
				_imgCT.removeChildAt(0);
			}
			_bmpD_W = bmpD_W;
			_bmpD_H = bmpD_H;
			
			///如果初始化设置了参照物，且所传参数是默认值，使用初始化参照物信息
			if (_iconConsult != null && _bmpD_W == 0 && _bmpD_H == 0)			
			{
				_bmpD_W = _iconConsult.width;
				_bmpD_H = _iconConsult.height;
			}
			
			_beInMiddle = modifyCoordinateInMiddle;
			_modifyConsult = modifyConsult;
			
			if (!urlIsBmpDClass && !urlIsMCClass)
			{
				if (url)
				{
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete_handle);
					_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError_handle);
					
					_loader.load(new URLRequest(url));
				}
				else
				{
					trace("图片地址参数为空！！！ImgBox.as");
				}
			}
			else if(urlIsBmpDClass)
			{
				var bmpdC:Class = ApplicationDomain.currentDomain.getDefinition(url) as Class;
				var bmpd:BitmapData = new bmpdC(0, 0);
				var newbmpD:BitmapData = SeanUtils.getNewBitmapData_WhichScaleSizeByLimit(bmpd, _bmpD_W, _bmpD_H);
				bmpd.dispose();
				_iconBMP = new Bitmap(newbmpD);
				_imgCT.addChild(_iconBMP);
				
				modifyCoordinateByConsult();
				
				dispatchEvent(new Event(EVENT_IconLoadComplete, true));
			}
			else if(urlIsMCClass)
			{
				var MCClass:Class = ApplicationDomain.currentDomain.getDefinition(url) as Class;
				var mc:MovieClip = new MCClass();
				var mc_bmpd:BitmapData = new BitmapData(mc.width, mc.height, true, 0x00000000);
				mc_bmpd.draw(mc, null, null, null, null, true);
				var mc_newbmpD:BitmapData = SeanUtils.getNewBitmapData_WhichScaleSizeByLimit(mc_bmpd, _bmpD_W, _bmpD_H);
				mc_bmpd.dispose();
				_iconBMP = new Bitmap(mc_newbmpD);
				_imgCT.addChild(_iconBMP);
				
				modifyCoordinateByConsult();
				
				dispatchEvent(new Event(EVENT_IconLoadComplete, true));
			}			
			
		}
		
		///直接设置贴图
		public function SetBitmapData(data:BitmapData, bmpD_W:Number=0, bmpD_H:Number=0):void
		{
			if (bmpD_W > 0 || bmpD_H > 0)
			{
				_bmpD_W = bmpD_W;
				_bmpD_H = bmpD_H;
			}
			else
			{
				if (isNaN(_bmpD_W))_bmpD_W = 0;
				if (isNaN(_bmpD_H))_bmpD_H = 0;
			}
			
			if (_bmpD_H==0 || _bmpD_W==0)
			{
				_iconBMP = new Bitmap(data);
				_imgCT.addChild(_iconBMP);
				
			}
			else
			{
				var bmpd:BitmapData = data;
				var newbmpD:BitmapData = SeanUtils.getNewBitmapData_WhichScaleSizeByLimit(bmpd, _bmpD_W, _bmpD_H);
				bmpd.dispose();
				_iconBMP = new Bitmap(newbmpD);
				_imgCT.addChild(_iconBMP);
			}			
			
			modifyCoordinateByConsult();
		}
		
		///获取图片
		public function get IconBMP():Bitmap
		{
			return _iconBMP;
		}
		
		///获取icon背景显示对象
		public function get IconBG():DisplayObject
		{
			return _iconBG;
		}
		
		///设置值对象
		public function SetVO(vo:*):void
		{
			_dataVO = vo;
		}
		private var _dataVO:*;
		///获取值对象
		public function get DataVO():*
		{
			return _dataVO;
		}
		
		///清空图片
		public function removeData():void
		{
			while (_imgCT.numChildren > 0)
			{
				/*if (_imgCT.getChildAt(0) is Bitmap)
				{
					(_imgCT.getChildAt(0) as Bitmap).bitmapData.dispose();
				}*/
				_iconBMP.bitmapData.dispose();
				_imgCT.removeChildAt(0);
			}
			
			_dataVO = null;
		}
		
		//相对于参照物调整显示坐标
		private function modifyCoordinateByConsult():void
		{
			if (_modifyConsult && _beInMiddle)
			{
				this.x = _modifyConsult.x + (_modifyConsult.width - _imgCT.width) / 2;
				this.y = _modifyConsult.y + (_modifyConsult.height - _imgCT.height) / 2;
			}
			
			if (_iconBG != null && _iconConsult != null)
			{
				_imgCT.x = _iconConsult.x + (_iconConsult.width - _imgCT.width) / 2;
				_imgCT.y = _iconConsult.y + (_iconConsult.height - _imgCT.height) / 2;
			}
			else if (_iconBG != null)
			{
				_imgCT.x = _iconBG.x + (_iconBG.width - _imgCT.width) / 2;
				_imgCT.y = _iconBG.y + (_iconBG.height - _imgCT.height) / 2;
			}
		}
		
		//===================================================================================Handle
		//加载成功时处理
		private function onLoadComplete_handle(evt:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete_handle);
			
			if (_bmpD_H==0 || _bmpD_W==0)
			{
				_iconBMP = _loader.content as Bitmap;
				_imgCT.addChild(_iconBMP);
				
			}
			else
			{
				var bmpd:BitmapData = (_loader.content as Bitmap).bitmapData;
				var newbmpD:BitmapData = SeanUtils.getNewBitmapData_WhichScaleSizeByLimit(bmpd, _bmpD_W, _bmpD_H);
				bmpd.dispose();
				_iconBMP = new Bitmap(newbmpD);
				_imgCT.addChild(_iconBMP);
			}			
			
			modifyCoordinateByConsult();
			
			dispatchEvent(new Event(EVENT_IconLoadComplete, true));
		}
		
		//加载失败时处理
		private function onLoadError_handle(evt:IOErrorEvent):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete_handle);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError_handle);
			trace("ImgBox 加载失败！", "/errorID:",evt.errorID, "/type",evt.type, "/text:", evt.text);
			dispatchEvent(evt);
		}
	}

}