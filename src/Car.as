package
{
	import com.cheezeworld.math.Vector2D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Car extends Entity
	{
		[Embed(source="../assets/shield.png")] private static const SHIELD:Class;
		[Embed(source="../assets/kick.png")] private static const KICK:Class;
		
		private var speed:Number = 1;
		private var slowSpeed:Number = 0.6;
		private var fastSpeed:Number = 1.3;
		private var acceleration:Number = 0;
		private var maxAccel:Number = 5;
		private var rotSpeed:Number = 5;
		private var slowRotSpeed:Number = 3;
		
		var image:Image;
		private var halfSize = 8;
		
		private var forward:Vector2D = new Vector2D(0,1);
		private var velocity:Vector2D = new Vector2D(0,0);
		private var angle:Number = 0;
		private var position:Vector2D = new Vector2D();
		private var blastAccel:Number = 10;
		
		private var shieldGfx:Shield;
		private var shield:Boolean = false;
		
		private var kickGfx:Shield;
		private var kick:Boolean = false;
		
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
			if (shield) {
				acceleration = slowSpeed;
			}
			else if (kick) {
				acceleration = fastSpeed;
			}
			else
			{
				acceleration = speed;
			}
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
		
		function Right():void
		{
			if (kick) {
				rotate(-slowRotSpeed);
			}
			else
			{
				rotate(-rotSpeed);
			}
		}
		
		function Left():void
		{
			if (kick)
			{
				rotate(slowRotSpeed);
			}
			else
			{
				rotate(rotSpeed);
			}
		}
		
		function DropBomb():void
		{
			world.add(new Bomb(x,y));
		}
		
		private function makeShieldGfx():void
		{
			if (!shieldGfx) {
				shieldGfx = new Shield(x,y, SHIELD);
				world.add(shieldGfx);
			}
		}
		
		private function makeKickGfx():void
		{
			if (!kickGfx) {
				kickGfx = new Shield(x,y, KICK);
				kickGfx.Rotate(angle);
				world.add(kickGfx);
			}
		}
		
		function ShieldOn():void
		{
			if (kick) {
				KickOff();
			}
			makeShieldGfx();
			shield = true;
			shieldGfx.visible = true;
		}
		
		function ShieldOff():void
		{
			makeShieldGfx();
			shield = false;
			shieldGfx.visible = false;
		}
		
		function KickOn():void
		{
			if (!shield) {
				makeKickGfx();
				kick = true;
				kickGfx.x = x - 8;
				kickGfx.y = y - 8;
				kickGfx.Rotate(angle+180);
				kickGfx.visible = true;
			}
		}
		
		function KickOff():void
		{
			makeKickGfx();
			kick = false;
			kickGfx.visible = false;
		}
		
		override public function update():void
		{
			if (acceleration > maxAccel) acceleration = maxAccel;
			velocity.addTo(forward.multipliedBy(acceleration));
			position.addTo(velocity);
			
			if (collide("wall", position.x, position.y) || 
				(collide("car", position.x, position.y))) {
				position.x = x;
				position.y = y;
				StopDead();
			} else {
				x = position.x;
				y = position.y;
			}
			
			if (shield) {
				shieldGfx.x = x - 8;
				shieldGfx.y = y - 8;
			}
			if (kick) {
				kickGfx.x = x - 8;
				kickGfx.y = y - 8;
				kickGfx.Rotate(angle+180);
			}
			
			acceleration = 0;
			velocity.multiply(0.7);
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
			if (!shield) {
				var vec:Vector2D = new Vector2D(this.x - x, this.y - y);
				var len:Number = vec.length;
				vec.normalize();
				vec.multiply(blastAccel);
				velocity.addTo(vec);
			}
		}
	}
}