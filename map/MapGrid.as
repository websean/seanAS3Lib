package map 
{
	
	import proj.modelNew.MapModel;
	import proj.modelNew.NewModel;
	import sean.components.BaseHasMCSprite;
	import sean.utils.DrawClip;
	import sean.utils.DrawStyle;
	
	/**
	 * ...
	 * @author Sean Lee
	 */
	public class MapGrid extends BaseHasMCSprite
	{
		
		public function MapGrid() 
		{
			super("Grid_MC");
			
			initControl();
		}
		
		override protected function supplementInitView():void 
		{
			super.supplementInitView();
			
			//this.graphics.beginFill(0, 1);
			
			
			/*this.graphics.lineStyle(1, 0, 1);
			this.graphics.moveTo(0, MapModel.MapGridRect_H / 2);
			this.graphics.lineTo(MapModel.MapGridRect_W / 2, 0);
			this.graphics.lineTo(MapModel.MapGridRect_W, MapModel.MapGridRect_H / 2);
			this.graphics.lineTo(MapModel.MapGridRect_W / 2, MapModel.MapGridRect_H);
			this.graphics.lineTo(0, MapModel.MapGridRect_H / 2);*/
			
			
			//this.graphics.endFill();
			/*var style:DrawStyle = new DrawStyle();
			style.bgAlpha = 0.5;
			style.bgColor = 0xffffff;
			DrawClip.drawRect(this, 0, 0, 40, 20, style);*/
		}
		
		private function initControl():void
		{
			
		}
		
	}

}