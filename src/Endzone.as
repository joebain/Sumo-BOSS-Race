package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Endzone extends Entity
	{
		[Embed(source="../assets/endzone1.png")]private static const ENDZONE1:Class;
		[Embed(source="../assets/endzone2.png")]private static const ENDZONE2:Class;
		
		private var image:Image;
		
		public function Endzone(x:Number, y:Number, owner:int)
		{
			super(x, y);
			collidable = true;
			width = 32;
			height = 32;
			
			layer = 4;
			
			if (owner == 1) {
				image = new Image(ENDZONE1);
				type="endzone1";
			} else {
				image = new Image(ENDZONE2);
				type = "endzone2";
			}
			graphic = image;
		}
	}
}