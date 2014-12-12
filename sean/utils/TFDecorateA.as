package sean.utils 
{
	
	/**A型文本装饰器
	 * ...
	 * @author Sean Lee
	 */
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TFDecorateA
	{
		
		public function TFDecorateA() 
		{
			
		}
		
		//默认样式修饰。（单行"宋体12号字"动态不可编辑1像素发光样式）
		public static function setDefaultStyle(tf:TextField, textColor:Number = 0, glowColor:Number = 0xffffff):void
		{
			tf.selectable = false;
			tf.wordWrap = false;
			tf.defaultTextFormat = new TextFormat("宋体", 12, textColor);
			var filter:GlowFilter = new GlowFilter(glowColor, 1, 2, 2, 10, 1, false, false);
			tf.filters = [filter];
		}
		
	}

}