package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	
	import test.Game;


//[SWF(frameRate="60",width="1000",height="600")]
	[SWF(frameRate="60",backgroundColor="#FF2F3D")]
	public class Main extends Sprite
	{
		private var myStarling:Starling;
		
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			setTimeout(initApp,100);
		}
		/**INIT*/
		private function initApp():void
		{
			myStarling = new Starling(Game,stage);
			myStarling.showStats=true;
			myStarling.start();
		}
	}
}