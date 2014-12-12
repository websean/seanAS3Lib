package map 
{
	import flash.geom.Point;
	import proj.control.GlobalEventDispatcher;
	import proj.modelNew.vo.BuildingVO;
	import proj.modelNew.vo.MapGridVO;
	import proj.modelNew.vo.ProduceVO;
	import proj.utils.NewEventConfig;
	import proj.viewNew.mapScene.MapGrids45Utils;
	import sean.mvc.events.GlobalEvent;
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class MapModel
	{
		
		//网格x轴长度（最大索引值）
		private var _mapX_MaxIndex:int = (23 - 1);
		//网格y轴长度（最大索引值）
		private var _mapY_MaxIndex:int = (26 - 1);
		
		public static const MapGridRect_W:Number = 56;
		public static const MapGridRect_H:Number = 31;
		public static const MapGrid_W:Number = 36;
		public static const MapGrid_H:Number = 22;
		
		///整体网格矩形原点距离沙滩背景原点的距离
		private static var _Between_Ground_And_MapBG_X:Number = 0;// 52;
		private static var _Between_Ground_And_MapBG_Y:Number = 0;// 250;
		
		///网格坐标0，0点的左角点离沙滩背景原点的距离
		public static const Grid_00_Between_Ground_X:Number = 55;
		public static const Grid_00_Between_Ground_Y:Number = 858//608;
		
		//场景上建筑物队列
		private var _buildingVOArr:Array;
		
		//地图数据
		private var _groundMapData:Array;
		private var _MapMathData:Array;
		
		//农田生产信息数组
		private var _cropLandPdVOArr:Array;
		//酿酒屋生产信息数组
		private var _wineMakerPdVOArr:Array;
		//调酒屋生产信息数组
		private var _wineModifyPdVOArr:Array;
		//打工建筑生产信息数组
		private var _workBuildingPdVOArr:Array;
		
		public function MapModel() 
		{
			_groundMapData = new Array();
			_MapMathData = new Array();
		}
		
		///
		public static function get Between_Ground_And_MapBG_X():Number
		{
			return _Between_Ground_And_MapBG_X;
		}
		
		///
		public static function get Between_Ground_And_MapBG_Y():Number
		{
			return _Between_Ground_And_MapBG_Y;
		}
		
		///更新农田生产信息
		public function updateCorpLandProduceInfo(voArr:Array):void
		{
			_cropLandPdVOArr = voArr;
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_CROPLAND_PD_INFO, _cropLandPdVOArr));
		}
		
		///更新某一块农田信息
		public function updateOneCorpLandPDInfo(newvo:ProduceVO):void
		{
			var index:int = -1;
			for each(var vo:ProduceVO in _cropLandPdVOArr)
			{
				if (vo.ID == newvo.ID)
				{
					index = _cropLandPdVOArr.indexOf(vo);
				}
			}
			if (index >= 0)
			{
				_cropLandPdVOArr.splice(index, 1, newvo);
			}
			else
			{
				_cropLandPdVOArr.push(newvo);
			}
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_CROPLAND_PD_INFO, _cropLandPdVOArr));
		}
		
		///获取农田生产信息
		public function getAllCorpLandPDInfo():Array
		{
			return _cropLandPdVOArr;
			
		}		
		
		///获取某一农田生产信息
		public function getOneCorpLandPDInfo(id:int):ProduceVO
		{
			var v:ProduceVO;
			for each(var vo:ProduceVO in _cropLandPdVOArr)
			{
				if (vo.ID == id)
				{
					v = vo;
					break;
				}
			}
			return v;
		}
		
		///更新酿酒屋生产信息
		public function updateWineMakerProduceInfo(voArr:Array):void
		{
			_wineMakerPdVOArr = voArr;
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_WINEMAKER_PD_INFO, _wineMakerPdVOArr));
		}
		
		///更新某一个酿酒屋信息
		public function updateOneWineMakerPDInfo(newvo:ProduceVO):void
		{
			var index:int = -1;
			for each(var vo:ProduceVO in _wineMakerPdVOArr)
			{
				if (vo.ID == newvo.ID)
				{
					index = _wineMakerPdVOArr.indexOf(vo);
				}
			}
			if (index >= 0)
			{
				_wineMakerPdVOArr.splice(index, 1, newvo);
			}
			else
			{
				_wineMakerPdVOArr.push(newvo);
			}
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_WINEMAKER_PD_INFO, _wineMakerPdVOArr));
		}
		
		///获取酿酒屋生产信息
		public function getAllWineMakerPDInfo():Array
		{
			return _wineMakerPdVOArr;
			
		}
		
		///获取某一酿酒屋生产信息
		public function getOneWineMakerPDInfo(id:int):ProduceVO
		{
			var v:ProduceVO;
			for each(var vo:ProduceVO in _wineMakerPdVOArr)
			{
				if (vo.ID == id)
				{
					v = vo;
					break;
				}
			}
			return v;
		}
		
		///更新调酒屋生产信息
		public function updateWineModifyProduceInfo(voArr:Array):void
		{
			_wineModifyPdVOArr = voArr;
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_WINEMODIFY_PD_INFO, _wineModifyPdVOArr));
		}
		
		///更新某一个调酒屋信息
		public function updateOneWineModifyPDInfo(newvo:ProduceVO):void
		{
			var index:int = -1;
			for each(var vo:ProduceVO in _wineModifyPdVOArr)
			{
				if (vo.ID == newvo.ID)
				{
					index = _wineModifyPdVOArr.indexOf(vo);
				}
			}
			if (index >= 0)
			{
				_wineModifyPdVOArr.splice(index, 1, newvo);
			}
			else
			{
				_wineModifyPdVOArr.push(newvo);
			}
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_WINEMODIFY_PD_INFO, _wineModifyPdVOArr));
		}
		
		///获取调酒屋生产信息
		public function getAllWineModifyPDInfo():Array
		{
			return _wineModifyPdVOArr;
			
		}
		
		///获取某一调酒屋生产信息
		public function getOneWineModifyPDInfo(id:int):ProduceVO
		{
			var v:ProduceVO;
			for each(var vo:ProduceVO in _wineModifyPdVOArr)
			{
				if (vo.ID == id)
				{
					v = vo;
					break;
				}
			}
			return v;
		}
		
		///更新所有打工建筑生产信息
		public function updateAllWorkBuildingProduceInfo(voArr:Array):void
		{
			_workBuildingPdVOArr = voArr;
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_WORKBUILDING_PD_INFO, _workBuildingPdVOArr));
		}
		
		///更新某一个打工建筑生产信息
		public function updateOneWorkBuildingPDInfo(newvo:ProduceVO):void
		{
			var index:int = -1;
			for each(var vo:ProduceVO in _workBuildingPdVOArr)
			{
				if (vo.ID == newvo.ID)
				{
					index = _workBuildingPdVOArr.indexOf(vo);
				}
			}
			if (index >= 0)
			{
				_workBuildingPdVOArr.splice(index, 1, newvo);
			}
			else
			{
				_workBuildingPdVOArr.push(newvo);
			}
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_ALL_WORKBUILDING_PD_INFO, _workBuildingPdVOArr));
		}
		
		///获取打工建筑生产信息
		public function getAllWorkBuildingPDInfo():Array
		{
			return _workBuildingPdVOArr;
			
		}
		
		///获取某一打工建筑生产信息
		public function getOneWorkBuildingPDInfo(id:int):ProduceVO
		{
			var v:ProduceVO;
			for each(var vo:ProduceVO in _workBuildingPdVOArr)
			{
				if (vo.ID == id)
				{
					v = vo;
					break;
				}
			}
			return v;
		}
		
		///刷新沙滩地图网格数据
		private function freshGroundMapData():void
		{
			_groundMapData.length = 0;
			_MapMathData.length = 0;
			
			for (var x:int = 0; x <= _mapX_MaxIndex; x++)
			{
				var arr:Array = new Array();
				var mathArr:Array = new Array();
				for (var y:int = 0; y <= _mapY_MaxIndex; y++)
				{
					var vo:MapGridVO = new MapGridVO();
					vo.State = MapGridVO.STATE_FREE;
					
					
					arr.push(vo);
					mathArr.push(MapGridVO.STATE_FREE);
				}
				_groundMapData.push(arr);
				_MapMathData.push(mathArr);
			}
		}
		
		///更新设置沙滩地图网格数据
		private function updateGroundMapData():void
		{
			freshGroundMapData();
			
			for each(var vo:BuildingVO in _buildingVOArr)
			{
				for (var x:int = 0; x < vo.XGrids; x++)
				{
					for (var y:int = 0; y < vo.YGrids; y++)
					{
						if ((vo.Index_X + x) > _mapX_MaxIndex || (vo.Index_Y + y) > _mapY_MaxIndex)
						{
							throw(new Error("后台给的坐标索引超出范围！！！Error！！！ GroundModel >> updateGroundMapData" + "  vo.ID: "+vo.ID));
						}
						(_groundMapData[(vo.Index_X + x)][(vo.Index_Y + y)] as MapGridVO).State = MapGridVO.STATE_USING;
						_MapMathData[(vo.Index_X + x)][(vo.Index_Y + y)] = MapGridVO.STATE_USING;
						if (vo.WalkCross)
						{
							(_groundMapData[(vo.Index_X + x)][(vo.Index_Y + y)] as MapGridVO).State = MapGridVO.STATE_ROAD;
							_MapMathData[(vo.Index_X + x)][(vo.Index_Y + y)] = MapGridVO.STATE_ROAD;
						}
					}
				}
			}
			
		}
		
		///恢复某一建筑区域地图网格数据为空闲
		public function clearGroundMapDataToFree(vo:BuildingVO):void
		{
			for (var x:int = 0; x < vo.XGrids; x++)
			{
				for (var y:int = 0; y < vo.YGrids; y++)
				{
					if ((vo.Index_X + x) > _mapX_MaxIndex || (vo.Index_Y + y) > _mapY_MaxIndex)
					{
						throw(new Error("后台给的坐标索引超出范围！！！Error！！！ GroundModel >> clearGroundMapDataToFree" + "  vo.ID: "+vo.ID));
					}
					
					(_groundMapData[(vo.Index_X + x)][(vo.Index_Y + y)] as MapGridVO).State = MapGridVO.STATE_FREE;
					_MapMathData[(vo.Index_X + x)][(vo.Index_Y + y)] = MapGridVO.STATE_FREE;
				}
			}
		}
		
		///恢复某一建筑区域地图网格数据为已使用
		public function clearGroundMapDataToUsing(vo:BuildingVO):void
		{
			for (var x:int = 0; x < vo.XGrids; x++)
			{
				for (var y:int = 0; y < vo.YGrids; y++)
				{
					if ((vo.Index_X + x) > _mapX_MaxIndex || (vo.Index_Y + y) > _mapY_MaxIndex)
					{
						throw(new Error("后台给的坐标索引超出范围！！！Error！！！ GroundModel >> clearGroundMapDataToFree" + "  vo.ID: "+vo.ID));
					}
					
					(_groundMapData[(vo.Index_X + x)][(vo.Index_Y + y)] as MapGridVO).State = MapGridVO.STATE_USING;
					_MapMathData[(vo.Index_X + x)][(vo.Index_Y + y)] = MapGridVO.STATE_USING;
				}
			}
		}
		
		///
		public function getBuildingVOArr():Array
		{
			return _buildingVOArr;
		}
		
		///
		public function getBuildingVOByID(id:int):BuildingVO
		{
			var bvo:BuildingVO;
			for each(var vo:BuildingVO in _buildingVOArr)
			{
				if (vo.ID == id)
				{
					bvo = vo;
					break;
				}
			}
			
			return bvo;
		}
		
		///
		public function getBuildingVOListByTypeID(typeID:int):Array
		{
			var list:Array = new Array();
			for each(var vo:BuildingVO in _buildingVOArr)
			{
				if (vo.TypeID == typeID)
				{
					list.push(vo);
				}
			}
			return list;
		}
		
		///获取沙滩地图某一网格数据
		public function getGroundMapData(x:uint, y:uint):MapGridVO
		{
			return (_groundMapData[x][y] as MapGridVO);
		}
		
		///获取沙滩地图数据
		public function getGroundMapAllData():Array
		{
			return _groundMapData;
		}
		
		public function MapMathData():Array
		{
			return _MapMathData;
		}
		
		///判断沙滩地图某一网格是否可建造（可用）
		public function checkGroundMapGridCouldUse(x:uint, y:uint):Boolean
		{
			if (x > _mapX_MaxIndex || y > _mapY_MaxIndex)
			{
				trace("输出值超出范围 GroundModel >> checkGroundMapGridCouldUse()");
				return false;
			}
			
			var canUse:Boolean = false;
			var vo:MapGridVO = (_groundMapData[x][y] as MapGridVO);
			if (!vo)
			{
				trace("查找不到对象 GroundModel >> checkGroundMapGridCouldUse()");
				return false;
			}
			if (vo.State == MapGridVO.STATE_FREE)
			{
				canUse = true;
			}
			return canUse;
		}
		
		//设置网格x与y轴长度（最大索引值）
		public function setMap_X_Y_Max(x_max:int, y_max:int):void
		{
			_mapX_MaxIndex = x_max;
			_mapY_MaxIndex = y_max;
			
			_Between_Ground_And_MapBG_X = Grid_00_Between_Ground_X;
			_Between_Ground_And_MapBG_Y = Grid_00_Between_Ground_Y - (MapGridRect_H / 2 * x_max);
			
			MapGrids45Utils.SetBetweenGroundDistance(_Between_Ground_And_MapBG_X, _Between_Ground_And_MapBG_Y);
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent("MapMaxXY_Been_Set"));
		}
		
		public function get MapX_Max():int
		{
			return _mapX_MaxIndex;
		}
		
		public function get MapY_Max():int
		{
			return _mapY_MaxIndex;
		}
		
		///更新建筑物队列
		public function updateBuildingList(arr:Array):void
		{
			_buildingVOArr = arr;
			
			updateGroundMapData();
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_BAR_BUILDING_LIST, _buildingVOArr));
		}
		
		///更新一个建筑物
		public function updateOneBuilding(vo:BuildingVO):void
		{
			var index:int = -1;
			for (var i:int = 0; i < _buildingVOArr.length; i++)
			{
				if ((_buildingVOArr[i] as BuildingVO).ID == vo.ID)
				{
					index = i;
				}
			}
			if (index >= 0 && index < _buildingVOArr.length)
			{
				_buildingVOArr.splice(index, 1);
			}
			_buildingVOArr.push(vo);
			
			updateGroundMapData();
			
			GlobalEventDispatcher.getIns().sendGlobalEvent(new GlobalEvent(NewEventConfig.UPDATE_BAR_ONE_BUILDING, vo));
		}
		
		//获取网格场景坐标（Index_X, Index_Y是网格索引坐标）
		public function getGridGlobalCoordinate(Index_X:int, Index_Y:int):Point
		{
			var cd:Point =  MapGrids45Utils.Compute_45_Type_Global_CP(Index_X, Index_Y, MapGridRect_W, MapGridRect_H, _mapX_MaxIndex, _mapY_MaxIndex, Between_Ground_And_MapBG_X, Between_Ground_And_MapBG_Y);
			
			return cd;
		}
		
		///获取场景坐标（根据实例id）
		public function getBuildingGlobalCoordinate(id:int):Point
		{
			if (_buildingVOArr.length <= 0)
			{
				return null;
			}
			
			var cd:Point;
			var index:int = -1;
			for (var i:int = 0; i < _buildingVOArr.length; i++)
			{
				if ((_buildingVOArr[i] as BuildingVO).ID == id)
				{
					index = i;
					break;
				}
			}
			if (index >= 0 && index < _buildingVOArr.length)
			{
				cd = getBuildingGlobalCoordinateByVO(_buildingVOArr[index] as BuildingVO);
			}
			return cd;
		}
		
		///获取若干空闲网格(arr里装的是point对象)
		public function getFreeGridsOnMap(num:uint=0):Array
		{
			var arr:Array = new Array();
			
			for (var i:int = 0; i < num; i++)
			{
				loop:for (var x:int = 0; x <= _mapX_MaxIndex; x++)
				{
					var x_r:int = int(Math.random() * _mapX_MaxIndex);
					for (var y:int = 0; y <= _mapY_MaxIndex; y++)
					{
						var y_r:int = int(Math.random() * _mapY_MaxIndex);
						var vo:MapGridVO = _groundMapData[x_r][y_r] as MapGridVO;
						if (vo)
						{
							if (vo.State == MapGridVO.STATE_FREE)
							{
								var same:Boolean = false;
								for (var n:int = 0; n < arr.length; n++)
								{
									var p:Point = arr[n] as Point;
									if (p.x == x_r && p.y == y_r)
									{
										same = true;
										break;
									}
								}
								if (!same)
								{
									arr.push(new Point(x_r, y_r));
									break loop;
								}
								
							}
						}
					}
				}
			}
			if (arr.length != num)
			{
				throw(new Error("所要获取的长度和计算长度不一致！！！Error！！！ GroundModel >> getFreeGridsOnMap()"));
			}
			return arr;
		}
		
		///获取场景坐标（根据VO对象）
		public function getBuildingGlobalCoordinateByVO(vo:BuildingVO):Point
		{
			if (!vo)
			{
				return null;
			}
			var cd:Point = MapGrids45Utils.Compute_45_Type_Global_CP(vo.Index_X, vo.Index_Y, MapGridRect_W, MapGridRect_H, _mapX_MaxIndex, _mapY_MaxIndex, Between_Ground_And_MapBG_X, Between_Ground_And_MapBG_Y);
			
			return cd;
		}
		
	}

}