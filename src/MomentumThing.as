package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import com.cheezeworld.math.Vector2D;
	
	public class MomentumThing extends Entity
	{
		 
		 var acceleration:Number = 0;
		 var maxAccel:Number = 5;
		
		 var forward:Vector2D = new Vector2D(0,1);
		 var velocity:Vector2D = new Vector2D(0,0);
		 var angle:Number = 0;
		 var position:Vector2D = new Vector2D();
		
		
		public function MomentumThing(x:Number, y:Number)
		{
			super(x, y);
		}
		
		function Stop():void
		{
			acceleration = 0;
		}
		
		function StopDead():void
		{
			acceleration = 0;
			velocity.x = 0;
			velocity.y = 0;
		}
		
		function rotate(amount:Number)
		{
			if (acceleration != 0)
			{
				angle += amount;
				forward = Vector2D.rotToHeading((180-angle+270)*(Math.PI/180));
			}
		}
		
		override public function update():void
		{
			if (acceleration > maxAccel) acceleration = maxAccel;
			velocity.addTo(forward.multipliedBy(acceleration));
			position.addTo(velocity);
			
		}
		
		public function setx(x:Number):void
		{
			this.x = x;
			position.x = x;
		}
		
		public function sety(y:Number):void
		{
			this.y = y;
			position.y = y;
		}
	}
}