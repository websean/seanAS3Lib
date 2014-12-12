package sean3d 
{
	
	
	/**6面独立贴图的墙体3D显示对象
	 * ...
	 * @author Sean Lee
	 */
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.primitives.PlaneGeometry;
	
	public class Wall6 extends ObjectContainer3D 
	{
		private var _planeUp:Mesh;
		private var _planeDown:Mesh;
		private var _planeLeft:Mesh;
		private var _planeRight:Mesh;
		private var _planeFront:Mesh;
		private var _planeBack:Mesh;
		
		private var _wallPlanes:Array;
		
		//墙长度
		private var _changdu:int;
		//墙高度
		private var _gaodu:int;
		//墙厚度
		private var _houdu:int;
		
		///构造函数；参数：changdu：墙体长度，gaodu：墙体高度，houdu：墙体厚度；
		public function Wall6(changdu:int = 10,gaodu:int = 10,houdu:int = 10) 
		{
			super();
			_changdu = changdu;
			_gaodu = gaodu;
			_houdu = houdu;
			init();
			
		}
		
		private function init():void
		{
			_planeUp = new Mesh(new PlaneGeometry(_changdu, _houdu));
			_planeDown = new Mesh(new PlaneGeometry(_changdu, _houdu));
			_planeFront = new Mesh(new PlaneGeometry(_changdu, _gaodu));
			_planeBack = new Mesh(new PlaneGeometry(_changdu, _gaodu));
			_planeLeft = new Mesh(new PlaneGeometry(_gaodu, _houdu));
			_planeRight = new Mesh(new PlaneGeometry(_gaodu, _houdu));
			
			_planeUp.x = _changdu / 2;
			_planeUp.y = _gaodu;			
			_planeUp.z = 0;
			_planeUp.geometry.scaleUV(_changdu/_houdu, 1);
			
			_planeDown.x = _changdu / 2;
			_planeDown.y = 0;
			_planeDown.rotationX = 180;
			_planeDown.geometry.scaleUV(_changdu/_houdu, 1);
			
			_planeFront.x = _changdu / 2;
			_planeFront.y = _gaodu / 2;
			_planeFront.z = -_houdu / 2;
			_planeFront.rotationX = -90;
			_planeFront.geometry.scaleUV(_changdu/_gaodu, 1);
			
			_planeBack.x = _changdu / 2;
			_planeBack.y = _gaodu / 2;
			_planeBack.z = _houdu / 2;
			_planeBack.rotationX = 90;
			_planeBack.geometry.scaleUV(_changdu/_gaodu, 1);			
			
			_planeLeft.x = 0;
			_planeLeft.y = _gaodu / 2;
			_planeLeft.rotationZ = 90;
			_planeLeft.geometry.scaleUV(_gaodu / _houdu, 1);
			
			_planeRight.x = _changdu;
			_planeRight.y = _gaodu / 2;
			_planeRight.rotationZ = -90;
			_planeRight.geometry.scaleUV(_gaodu/_houdu, 1);
			
			_wallPlanes = [_planeUp, _planeDown, _planeFront, _planeBack, _planeLeft, _planeRight];
			
			for each(var plane:Mesh in _wallPlanes)
			{
				this.addChild(plane);
			}
		}
		
		///设置墙体贴图材质
		public function SetWallMatieral(m:MaterialBase):void
		{
			for each(var plane:Mesh in _wallPlanes)
			{
				plane.material = m;				
			}
		}
		
		///分别设置墙体每一个面的贴图材质
		public function SetWallMatieralForEachSinglePlane(up_M:MaterialBase = null, down_M:MaterialBase = null, front_M:MaterialBase = null, back_M:MaterialBase = null, left_M:MaterialBase = null, right_M:MaterialBase = null):void		
		{
			if (up_M != null)
			{
				_planeUp.material = up_M;
			}
			
			if (down_M != null)
			{
				_planeDown.material = down_M;
			}
			
			if (front_M != null)
			{
				_planeFront.material = front_M;
			}
			
			if (back_M != null)
			{
				_planeBack.material = back_M;
			}
			
			if (left_M != null)
			{
				_planeLeft.material = left_M;
			}
			
			if (right_M != null)
			{
				_planeRight.material = right_M;
			}
		}
		
		///分别设置墙体每对对立面的贴图材质
		public function SetWallMatieralForEachCouplePlane(upDownM:MaterialBase = null, frontBack_M:MaterialBase = null, leftRight_M:MaterialBase = null):void		
		{
			if (upDownM != null)
			{
				_planeUp.material = upDownM;
				_planeDown.material = upDownM;
			}
			
			if (frontBack_M != null)
			{
				_planeFront.material = frontBack_M;
				_planeBack.material = frontBack_M;
			}
			
			if (leftRight_M != null)
			{
				_planeLeft.material = leftRight_M;
				_planeRight.material = leftRight_M;
			}
		}
		
	}

}