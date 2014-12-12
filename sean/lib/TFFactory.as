package sean.lib 
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	/**文本工厂
	 * ...
	 * @author Sean Lee
	 */
	public class TFFactory 
	{
		
		public function TFFactory() 
		{
			
		}
		
		///为文本添加描边滤镜，mbColor：描边颜色；
		public static function TF_Add_Filter_MiaoBian(tf:TextField, mbColor:Number = 0):void		
		{
			var fs:Array = tf.filters;
			fs.push(new GlowFilter(mbColor, 1, 2, 2, 10, 1));
			tf.filters = fs;
		}
		
	}

}