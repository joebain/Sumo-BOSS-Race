package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Wall extends Entity
	{
		[Embed(source="../assets/wall.png")]
		private const image:Class;
		
		public function Wall(x:Number, y:Number)
		{
			super(x, y);
			
			graphic = new Image(image);
			collidable = true;
			type="wall";
			width = 16;
			height = 16;
			layer = 2;
		}
	}
}