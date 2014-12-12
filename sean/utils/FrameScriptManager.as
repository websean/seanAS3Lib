package sean.utils
{

	import flash.display.MovieClip;

	public class FrameScriptManager
	{

		private var target:MovieClip;
		private var labels:Object;

		public function FrameScriptManager(target:MovieClip)
		{
			this.target = target;
			updateLabels();
		}

		public function setFrameScript(frame:*, funct:Function):void
		{
			var frameNum:uint = getFrameNumber(frame);
			if (frameNum == 0)
			{
				return;
			}
			target.addFrameScript(frameNum-1,funct);
		}
		
		public function getFrameNumber(frame:*):uint
		{
			var frameNum:uint = uint(frame);
			if (frameNum)
			{
				return frameNum;
			}
			var label:String = String(frame);
			if (label == null)
			{
				return 0;
			}
			frameNum = labels[label];
			return frameNum;
		}

		private function updateLabels():void
		{
			var lbls:Array = target.currentLabels;
			labels = {};
			for (var i:uint = 0; i < lbls.length; i++)
			{
				labels[lbls[i].name] = lbls[i].frame;
			}
		}
	}
}