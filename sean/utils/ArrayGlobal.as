package sean.utils
{
	
	/**
	 * ...
	 * @author Sean Lee 2009.11.30
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 *
	 * @classname ArrayGlobal
	 * 与显示对象无关的公共方法;
	 * @methods
	 * ///////公共属性/////////
	 * 
	 * ///////公共方法/////////
	 * orderSearch(arr:Array, key:*);				//数组顺序找法; 从arr数组中查找数据key, 返回数组下标;
	 * binarySearch(arr:Array, key:uint);			//数组二分查找法; 从arr数组中查找数据key, 返回数组下标;
	 * arrayRandSort(targetArray:Array);			//数组随机排序算法;
	 * 
	 * ////////公共事件/////////////
	 * 
	 */
	public class ArrayGlobal
	{
		
		//数组顺序找法;
		///从arr数组中查找数据key, 返回数组下标;
		public static function orderSearch(arr:Array, key:*):int
		{
			arr.forEach(callback);
			var n:int;
			function callback(element:*, i:int, arr:Array):void
			{
				if (element == key)
				{
					n = i + 1;
					return;
				}
			}
			return (n > 0) ? n - 1 : -1;
		}
		
		//数组二分查找法;
		///从arr数组中查找数据key, 返回数组下标;
		public static function binarySearch(arr:Array, key:*):int
		{
			var low:int, mid:int, high:int;
			low = 0;
			high = arr.length - 1;
			while (low<=high){
				//mid = (low + high) / 2;用下面那句可以解决low + high可能溢出问题;
				mid = low + (high - low) / 2;
				if(arr[mid] < key)
					low = mid + 1;
				else if(arr[mid] > key)
					high = mid - 1;
				else
					return mid;
			}
			return -1;
		}
		
		///数组随机排序算法;
		public static function arrayRandSort(targetArray:Array):Array
		{
			var arrayLength:Number=targetArray.length;
			//先创建一个正常顺序的数组
			var tempArray1:Array=[];
			for (var i = 0; i < arrayLength; i++)
			{
				tempArray1[i]=i;
			}
			//再根据上一个数组创建一个随机乱序的数组
			var tempArray2:Array=[];
			for (var j = 0; j < arrayLength; j++)
			{
				//从正常顺序数组中随机抽出元素
				tempArray2[j]=tempArray1.splice(Math.floor(Math.random() * tempArray1.length),1);
			}
			//最后创建一个临时数组存储 根据上一个乱序的数组从targetArray中取得数据
			var tempArray3:Array=[];
			for (var k = 0; k < arrayLength; k++)
			{
				tempArray3[k]=targetArray[tempArray2[k]];
			}
			//返回最后得出的数组
			return tempArray3;
		}
		
	}
	
}