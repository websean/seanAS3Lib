package astar
{
	
    /**记录格子状态值的值对象
	* ...
	* @author Sean Lee
	*/
	
    public class StateVO
	{
        public var value:int = 0;
		
        //state状态参数表示:			
		///有障碍物
        public static const HAVE_THING:int = 1;
		///路不通及为无路
        public static const IMPASSE_VALUE:int = 2;
		///操作对象点
        public static const MAIN_VALUE:int = 8;
		
        public function StateVO()
		{
        
        }
		
        //获取是否障碍
        public function get isThing():Boolean
		{
            return value == HAVE_THING;
        }
        
        //获取是否死路
        public function get isWalk():Boolean
		{
            return value == IMPASSE_VALUE;
        }
        
        //重写toString
        public function toString():String
		{
            return value.toString();
        }
        
    }
    
}