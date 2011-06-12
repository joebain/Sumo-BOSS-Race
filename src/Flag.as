package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class Flag extends Entity
	{
		[Embed(source="../assets/flag.png")] private static const FLAG:Class; 
		private var image:Image;
		public var owner:Car;
		private var starty:Number;
		private var startx:Number;
		
		public function Flag(x:Number, y:Number)
		{
			super(x, y);
			startx = x;
			starty = y;
			
			layer = 0;
			
			image = new Image(FLAG);
			graphic = image;
			type = "flag";
			collidable = true;
			
			width = 32;
			height = 32;
		}
		
		public function setOwner(car:Car):void
		{
			owner = car;
		}
		
		public override function update():void
		{
			if (owner) {
				x = owner.x - owner.forward.x * 16;
				y = owner.y - owner.forward.y * 16;
				image.scale = 0.5;
			}
			else{
				x = startx;
				y = starty;
				image.scale = 1;
			}
		}
	}
}