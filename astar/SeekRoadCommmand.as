package astar 
{
	
	/**寻路命令（A*算法）
	 * ...
	 * @author Sean Lee
	 */
	
	public class SeekRoadCommmand
	{
		//目标位置的x轴索引坐标
		private var _targetIX:int;
		//目标位置的y轴索引坐标
        private var _targetIY:int;
		//地图数据数组（二维）
		private var _mapDataArray:Array;
		//地图X轴的格子索引长度（以格为单位）
		private var _map_X_gridNum:int;
		//地图Y轴的格子索引长度（以格为单位）
		private var _map_Y_gridNum:int;
		
		//开启队列
		private var unlockList:Array;
		//锁定队列
        private var lockList:Object;
		
		//路径耗费固定值
        public static const BIAS_VALUE:int = 14;
        public static const LINE_VALUE:int = 10;
		
		///参数（mapDataArray：地图数据数组（二维）；map_X_gridNum：地图X轴的格子索引长度；map_Y_gridNum：地图Y轴的格子索引长度）
		public function SeekRoadCommmand(mapDataArray:Array,map_X_gridNum:int,map_Y_gridNum:int) 
		{
			reSetData(mapDataArray, map_X_gridNum, map_Y_gridNum);
		}
		
		///重新设置数据（mapDataArray：地图数据数组（二维）；map_X_gridNum：地图X轴的格子索引长度；map_Y_gridNum：地图Y轴的格子索引长度）
		public function reSetData(mapDataArray:Array,map_X_gridNum:int,map_Y_gridNum:int):void
		{
			_mapDataArray = mapDataArray;
			_map_X_gridNum = map_X_gridNum;
			_map_Y_gridNum = map_Y_gridNum;
			createRoad();
		}
		
		//为地图上的每个格子重新设定状态值
        private function createRoad():void
		{
            for (var i:int = 0; i < _map_X_gridNum * _map_Y_gridNum; i ++)
			{                
                var ix:int = i % _map_X_gridNum;
                var iy:int = Math.floor(i / _map_X_gridNum);
				
				var state:StateVO = new StateVO();
				try
				{
					state.value = int(_mapDataArray[ix][iy]);
				}
				catch (e:Error)
				{
					throw(new Error("输入的地图纵横向总格数与实际不符！！！SeekRoadCommmand.as"));
				}
                
                
                switch(state.value)
				{
					//表示此点有障碍
                    case StateVO.HAVE_THING:
                    
                    break;
                    
					//表示此点无路（不通）
					case StateVO.IMPASSE_VALUE:
                    
                    break;
                    
					//表示此点是操控对象
					case StateVO.MAIN_VALUE:
                    
                    break;
                }
				
				///转换地图单元数据为新的值对象StateVO，便于对比和搜索。
                _mapDataArray[ix][iy] = state;
            }
        }
		
		///开始寻路
        public function seekRoad(currentIX:int, currentIY:int, targetIX:int, targetIY:int):Array
		{
           if (targetIX >= _mapDataArray.length)
			{
				throw(new Error("地图X轴的格子索引长度 ------超出范围！！！"));
			}
			_targetIX = targetIX;
			_targetIY = targetIY;
			
            //判断目标点是不是有障碍，或者是不是死路
            if (_mapDataArray[_targetIX][_targetIY].isThing || _mapDataArray[_targetIX][_targetIY].isWalk)
			{
                return new Array;
            }
			
            //寻路初始化
            var path:Array = new Array();
            unlockList = new Array();
            lockList = new Object();
            
            //初始标记
            var ix:int = currentIX;
            var iy:int = currentIY;
            
            //创建开始标记
            var sign:SignVO = new SignVO(ix,iy,0,0,null);
            lockList[ix + "_" + iy] = sign;
            
            while (true)
			{
				//生成八个方向的标记开启
				//addUnlockList(createSign(ix + 1,iy - 1,true ,sign));
				addUnlockList(createSign(ix + 1,iy    ,false,sign));
				//addUnlockList(createSign(ix + 1,iy + 1,true ,sign));
				//addUnlockList(createSign(ix - 1,iy + 1,true ,sign));
				addUnlockList(createSign(ix    ,iy + 1,false,sign));
				addUnlockList(createSign(ix - 1,iy    ,false,sign));
				//addUnlockList(createSign(ix - 1,iy - 1,true ,sign));
				addUnlockList(createSign(ix    ,iy - 1,false,sign));
				
				//判断开启列表是否已经为空
				if (unlockList.length == 0)
				{
					break;
				}
				
				//从开启列表中取出h值最低的标记
				unlockList.sortOn("f",Array.NUMERIC);
				sign = unlockList.shift();
				lockList[sign.ix + "_" + sign.iy] = sign;
				ix = sign.ix;
				iy = sign.iy;
				
				//判断是否找出路径
			   if (ix == _targetIX && iy == _targetIY)
			   {
					while (sign != null)
					{
						path.push(sign.getSign());
						sign = sign.p;
					}
					break;
				}
            }
            
            sign = null;
            
            return path.reverse();
        }
        
        //添加到开启标记列表
        private function addUnlockList(sign:SignVO):void
		{
            if (sign)
			{
                unlockList.push(sign);
                unlockList[sign.ix + "_" + sign.iy] = sign;
            }
        }
         
        //生成标记
        private function createSign(ix:int, iy:int, p:Boolean, _p:SignVO):SignVO
		{
			//是否出格
			if (ix < 0 || iy < 0 || ix >= _map_X_gridNum || iy >= _map_Y_gridNum)
			{
				return null;
			}
            
            //是否有障碍物
            if (_mapDataArray[ix][iy].isThing)
			{
                return null;
            }
            
            //是否已经加入关闭标记列表
            if (lockList[ix + "_" + iy])
			{
				return null;
            }
            
            //是否已经加入开启标记列表
            if (unlockList[ix + "_" + iy])
			{
                return null;
            }
            
            //判断当斜着走的时候，它的上下或者左右是否有障碍物
            if (p)
			{
                if (_mapDataArray[_p.ix][iy].isThing || _mapDataArray[ix][_p.iy].isThing)
				{
                    return null;
                }
            }
            
            var cx:Number = Math.abs(_targetIX - ix);
            var cy:Number = Math.abs(_targetIY - iy);
            return new SignVO(ix,iy,
                                    p ? BIAS_VALUE : LINE_VALUE,
                                    (cx + cy) * 10,
                                    _p);
        }
		
	}

}