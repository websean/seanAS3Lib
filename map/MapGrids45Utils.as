package map
{
	
	/**45°视角型网格地图菱形型算法类
	 * 
	 *    /\
         /    \
         \    /
           \/
	 * 
	 * 
	 * ...
	 * 
	 * @author Sean Lee
	 */
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class MapGrids45Utils
	{
		//网格状态：0，空闲；1，被占用；2，禁用；3，可行走穿越。
		public static const STATE_FREE:int = 0;
		public static const STATE_USING:int = 1;
		public static const STATE_SHUT_DOWN:int = 2;
		public static const STATE_ROAD:int = 3;
		
		public static const MapGridRect_W:Number = 56;
		public static const MapGridRect_H:Number = 31;
		public static const MapGrid_W:Number = 36;
		public static const MapGrid_H:Number = 22;
		
		///网格装饰界面原点距离沙滩背景原点的距离
		private static var Between_Ground_And_MapBG_X:Number = 0;//52;
		private static var Between_Ground_And_MapBG_Y:Number = 0;//250;
		
		public function MapGrids45Utils() 
		{
			
		}
		
		///设置网格装饰界面原点距离沙滩背景原点的距离
		public static function SetBetweenGroundDistance(B_X:Number, B_Y:Number):void
		{
			Between_Ground_And_MapBG_X = B_X;
			Between_Ground_And_MapBG_Y = B_Y;
		}
		
		///构建地图网格（parallel型（平行）网格地图<上下边平行型>，索引坐标从0，0点开始）（gridsContainer是网格显示对象的容器；gridsArr是网格显示对象二维队列；MapData是网格地图数据<二维数组>）
		public static function buildMap_PType_Grids(gridsContainer:Sprite, gridsArr:Array, MapX_Max:int, MapY_Max:int, MapData:Array):void
		{
			while (gridsContainer.numChildren > 0)
			{
				gridsContainer.removeChildAt(0);
			}
			
			while (gridsArr.length > 0)
			{
				gridsArr.pop();
			}
			
			for (var x:int = 0; x < MapX_Max; x++)
			{
				var xRay_arr:Array = new Array();
				for (var y:int = 0; y < MapY_Max; y++)
				{					
					var grid:MapGrid = new MapGrid();
					grid.x = x * MapGrid_W + (MapGridRect_W - MapGrid_W) * ((MapY_Max - 1) - y);// + Grid_Padding_H * x;
					
					grid.y = y * MapGridRect_H;// + Grid_Padding_V * y;
					
					gridsContainer.addChild(grid);
					
					try
					{
						var mapVO:Object = MapData[x][y] as Object;
					}
					catch (e:Error)
					{
						
					}
					if (mapVO["State"] == STATE_SHUT_DOWN)
					{
						grid.visible = false;
					}
					xRay_arr.push(grid);
				}
				gridsArr.push(xRay_arr);
			}
			
		}
		
		///构建地图网格（45°型菱形网格地图<竖状菱形型>，索引坐标从0，0点开始）（gridsContainer是网格显示对象的容器；gridsArr是网格显示对象二维队列；MapData是网格地图数据<二维数组>）
		public static function buildMap_45Type_Grids(gridsContainer:Sprite, gridsArr:Array, MapX_Max:int, MapY_Max:int, MapData:Array):void
		{
			while (gridsContainer.numChildren > 0)
			{
				gridsContainer.removeChildAt(0);
			}
			
			while (gridsArr.length > 0)
			{
				gridsArr.pop();
			}
			
			for (var x:int = 0; x <= MapX_Max; x++)
			{
				var xRay_arr:Array = new Array();
				for (var y:int = 0; y <= MapY_Max; y++)
				{					
					var grid:MapGrid = new MapGrid();
					
					var cp:Point = Compute_45_Type_Global_CP(x, y, MapGridRect_W, MapGridRect_H, MapX_Max, MapY_Max);
					
					grid.x = cp.x;
					grid.y = cp.y;
					
					gridsContainer.addChild(grid);
					
					try
					{
						var mapVO:Object = MapData[x][y] as Object;
						if (mapVO["State"] == STATE_SHUT_DOWN)
						{
							grid.visible = false;
						}
					}
					catch (e:Error)
					{
						
					}					
					xRay_arr.push(grid);
				}
				gridsArr.push(xRay_arr);
			}
			
		}
		
		///（算法）计算45°型菱形网格地图上某一对应网格位置全局坐标（场景坐标）
		public static function Compute_45_Type_Global_CP(index_X:int, index_Y:int, rect_W:Number, rect_H:Number, Max_X:int, Max_Y:int, excursion_X:Number = 0, excursion_Y:int = 0):Point
		{
			var cp:Point = new Point();
			cp.x = index_X * (rect_W / 2) + index_Y * (rect_W / 2) + excursion_X;
			cp.y = index_Y * (rect_H / 2) + (Math.abs(index_X - Max_X) * (rect_H / 2)) + excursion_Y;
			return cp;
		}
		
		///刷新地图上显示对象深度
		public static function freshDPODeepOnMap(Items:Array, itemContainer:DisplayObjectContainer):void
		{
			var newArr:Array = new Array();
			
			for each(var item:DisplayObject in Items)
			{
				var index:int = -1;
				for (var i:int = 0; i < newArr.length; i++)
				{
					if (item.y < (newArr[i] as DisplayObject).y)
					{
						index = i;
						break;
					}
					else if(item.y == (newArr[i] as DisplayObject).y)
					{
						if (item.x <= (newArr[i] as DisplayObject).x)
						{
							index = i;
							break;
						}
					}
				}
				
				if (index >= 0)
				{
					newArr.splice(index, 0, item);
				}
				else
				{
					newArr.push(item);
				}				
			}
			
			var newItems:Array = newArr.concat();
			while (newArr.length > 0)
			{
				newArr.pop();
			}
			
			for(var n:int = 0; n < newItems.length; n++)
			{
				if (itemContainer.contains(newItems[n] as DisplayObject))
				{
					itemContainer.addChild(newItems[n] as DisplayObject)
				}
			}
			
		}
		
		///根据容器坐标获得索引坐标（上下边平行菱形型）（MapX_Max与MapY_Max分别是网格x与y轴长度（最大索引值））
		public static function getIndexCDByCD_P_Type(cd_x:Number, cd_y:Number, MapX_Max:int, MapY_Max:int):Point
		{
			var coord_p:Point = new Point(0, 0);
			//标注0的地方是网格横向与竖向之间间隔值
			var index_x:int = int(Math.floor((cd_x - (MapY_Max * MapGridRect_H - cd_y) * Math.tan(Math.PI / 4)) / (MapGrid_W + 0)));
			var index_y:int = int(Math.ceil(cd_y / (MapGridRect_H + 0)) - 1);			
			//trace("索引坐标[x,y]：", index_x, index_y);
			if (index_x >=0 && index_y >=0)
			{
				if (index_x >= MapX_Max)
				{
					//index_x = Model.getIns().getGroundModel().MapX_Max() - 1;
				}
				if (index_y >= MapY_Max)
				{
					//index_y = Model.getIns().getGroundModel().MapY_Max() - 1;
				}
				coord_p.x = index_x;
				coord_p.y = index_y;
			}
			else
			{
				coord_p.x = index_x;
				coord_p.y = index_y;
			}
			
			
			return coord_p;
		}
		
		///根据网格容器坐标获得索引坐标（45°菱形型）（MapX_Max与MapY_Max分别是网格x与y轴长度（最大索引值））
		public static function getIndexCDByCD_45_Type(cd_x:Number, cd_y:Number, MapX_Max:int, MapY_Max:int):Point
		{
			//00点网格索引坐标
			var origin_p:Point = Compute_45_Type_Global_CP(0, 0, MapGridRect_W, MapGridRect_H, MapX_Max, MapY_Max);
			//网格弧度
			var grid_radian:Number = Math.atan2(MapGridRect_H / 2, MapGridRect_W / 2) * 2;			
			//对象点与00点网格连接线弧度
			var coord_radian:Number = Math.atan2((cd_y - (origin_p.y + MapGridRect_H / 2)), (cd_x - origin_p.x));			
			//对象点到X边映射弧度
			var dist_X_radian:Number = grid_radian / 2 + coord_radian;
			//对象点到Y边映射弧度
			var dist_Y_radian:Number = grid_radian / 2 - coord_radian;
			//对象点与00点网格之间的距离
			var distance:Number = Math.sqrt(cd_x * cd_x + (cd_y - (origin_p.y + MapGridRect_H / 2)) * (cd_y - (origin_p.y + MapGridRect_H / 2)));
			//网格边长
			var gridLength:Number = Math.sqrt((MapGridRect_W / 2) * (MapGridRect_W / 2) + (MapGridRect_H / 2) * (MapGridRect_H / 2));
			//对象点到X边映射距离X边原点长度
			var X_length:Number = distance * Math.cos(dist_X_radian) - distance * Math.sin(dist_X_radian) / Math.tan(grid_radian);
			//对象点到Y边映射距离Y边原点长度
			var Y_length:Number = distance * Math.cos(dist_Y_radian) - distance * Math.sin(dist_Y_radian) / Math.tan(grid_radian);
			
			var index_X:int = Math.floor(X_length / gridLength);
			var index_Y:int = Math.floor(Y_length / gridLength);
			
			var coord_p:Point = new Point(index_X, index_Y);
			//trace("索引坐标[x,y]：", index_X, index_Y);
			return coord_p;
		}
		
		///根据坐标判断当前网格是否可摆放（可用）（x:int, y:int是索引坐标，MapData是网格地图数据<二维数组>）
		public static function judgeGridIsValuable(x:int, y:int, MapData:Array, forWalk:Boolean = false):Boolean
		{
			var valuable:Boolean = false;
			
			if (x < 0)
			{
				return valuable;
			}
			
			if (y < 0)
			{
				return valuable;
			}
			
			if (x >= MapData.length)
			{
				
				trace("参数x 超出队列长度！judgeGridIsValuable  Error！X：" + x);
				return false;
			}
			
			try
			{
				var vo:Object = MapData[x][y] as Object;
			}
			catch (e:Error)
			{
				return false;
			}
			
			if (vo)
			{
				if (vo["State"] == STATE_FREE)
				{
					valuable = true;
				}
				if (forWalk)
				{
					if (vo["State"] == STATE_ROAD)
					{
						valuable = true;
					}
				}
			}
			
			return valuable;
		}
		
		///判断道具是否满足摆放条件（coord_x:int, coord_y:int是索引坐标，MapData是网格地图数据<二维数组>）
		public static function judgeBuildingCanPutOn(bVO:Object, coord_x:int, coord_y:int, MapData:Array):Boolean
		{
			var can:Boolean = true;
			
			for (var x:int = 0; x < bVO["XGrids"]; x++)
			{
				var add_x:int = x;
				for (var y:int = 0; y < bVO["YGrids"]; y++)
				{
					var add_y:int = y;
					var gridIsFree:Boolean = judgeGridIsValuable((coord_x + add_x), (coord_y + add_y), MapData);
					if (!gridIsFree)
					{
						can = false;
						return can;
					}
				}
			}
			
			return can;
		}
		
	}

}