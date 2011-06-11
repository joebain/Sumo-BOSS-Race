package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="1024", height="768")]
	public class SumoBOSSRace extends Engine
	{
		[Embed(source="../Level1.oel", mimeType="application/octet-stream")]
		private static const LEVEL_1: Class;
		
		public function SumoBOSSRace()
		{
			super(1024, 768, 60, false);
			
			FP.world = new Level(LEVEL_1);
		}
		
		override public function init():void
		{
		}
	}
}