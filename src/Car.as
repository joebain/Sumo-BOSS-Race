package
{
	import com.cheezeworld.math.Vector2D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Car extends Entity
	{
		private var speed:Number = 0.1;
		private var acceleration:Number = 0;
		private var maxAccel:Number = 5;
		private var rotSpeed:Number = 5;
		
		var image:Image;
		private var halfSize = 8;
		
		private var forward:Vector2D = new Vector2D(0,1);
		private var velocity:Vector2D = new Vector2D(0,1);
		private var angle:Number = 0;
		private var position:Vector2D = new Vector2D();
		
		public function Car(x:Number, y:Number)
		{
			super(x, y);
			position.x = x;
			position.y = y;
			
			image = graphic as Image;
			image.originX = halfSize;
			image.originY = halfSize;
			
			collidable = true;
			width = 16;
			height = 16;
			type = "car";
			layer = 1;
		}
		
		function Forward():void
		{
			acceleration += speed;
			
			//x = position.x;
			//y = position.y;
		}
		
		function Stop():void
		{
			acceleration = 0;
			//velocity.x = 0;
			//velocity.y = 0;
		}
		
		function StopDead():void
		{
			acceleration = 0;
			velocity.x = 0;
			velocity.y = 0;
		}
		
		function Right():void
		{
			rotate(-rotSpeed);
		}
		
		function Left():void
		{
			rotate(rotSpeed);
		}
		
		function DropBomb():void
		{
			world.add(new Bomb(x,y));
		}
		
		override public function update():void
		{
			if (acceleration > maxAccel) acceleration = maxAccel;
			velocity = forward.multipliedBy(acceleration);
			position.addTo(velocity);
			
			if (collide("wall", position.x, position.y) || 
				(collide("car", position.x, position.y))) {
				position.x = x;
				position.y = y;
				Stop();
			} else {
				x = position.x;
				y = position.y;
			}
		}
		
		private function rotate(amount:Number)
		{
			if (acceleration != 0)
			{
				angle += amount;
				image.angle = angle;
				forward = Vector2D.rotToHeading((180-angle+270)*(Math.PI/180));
			}
		}
		
		public function blast(x:Number, y:Number):void
		{
			var vec:Vector2D = new Vector2D(x - this.x, y - this.y);
			var len:Number = vec.length;
			vec.normalize();
			forward.addTo(vec.multipliedBy(1/len));
			acceleration = forward.length;
			forward.normalize();
		}
	}
}