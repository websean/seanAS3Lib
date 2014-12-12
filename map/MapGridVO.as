package map 
{
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class MapGridVO
	{
		public static const STATE_FREE:int = 0;
		public static const STATE_USING:int = 1;
		public static const STATE_SHUT_DOWN:int = 2;
		public static const STATE_ROAD:int = 3;
		
		//网格状态：0，空闲；1，被占用；2，禁用；3，行走穿透。
		public var State:int;
		
		public function MapGridVO() 
		{
			
		}
		
		
	}

}