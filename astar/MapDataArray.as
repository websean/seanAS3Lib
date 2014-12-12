package astar
{
	
    /**（A*算法）地图数据二维数组
	 * ...
	 * @author Sean Lee
	 */
	
    public dynamic class MapDataArray extends Array
	{    
		
		//数组中一维的长度，及地图中x轴的格子索引长度
		private var _x_num:int
		
        public function MapDataArray(X_Num:int)
		{
			_x_num = X_Num;
            init();
        }
         
        //初始化
        private function init():void
		{
            for (var i:int = 0; i < _x_num; i ++)
			{
                push(new Array(0));
            }
        }
		
    }
	
}