package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class Shield extends Entity
	{
		private var image:Image;
		
		public function Shield(x:Number, y:Number, pic:Class)
		{
			super(x,y);
			
			image = new Image(pic);
			graphic = image;
			layer = 1;
			
			image.centerOrigin();
		}
		
		public function Rotate(angle:Number):void
		{
			image.angle = angle;
		}
	}
}