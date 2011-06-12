package
{
	import com.cheezeworld.math.Vector2D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Car extends MomentumThing
	{
		[Embed(source="../assets/shield.png")] private static const SHIELD:Class;
		[Embed(source="../assets/kick.png")] private static const KICK:Class;
		
		private var speed:Number = 1;
		private var slowSpeed:Number = 0.6;
		private var fastSpeed:Number = 1.3;
		
		private var rotSpeed:Number = 5;
		private var slowRotSpeed:Number = 2;
		
		var image:Image;
		private var halfSize = 8;
		
		private var blastAccel:Number = 10;
		
		private var shieldGfx:Shield;
		private var shield:Boolean = false;
		
		private var kickGfx:Shield;
		private var kick:Boolean = false;
		
		private var bombButtFactor:Number = 3.5;
		private var bombThrowFactor:Number = 20;
		private var hasFlag:Boolean;
		private var myFlag:Flag;
		
		private var xdown:Boolean = false;
		
		var playerNumber:int;
		
		var forwardKey:int;
		var leftKey:int;
		var rightKey:int;
		var backKey:int;
		var boostKey:int;
		var bombKey:int;
		var shieldKey:int;
		private var going:Boolean = false;
		
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
			if (shield || hasFlag) {
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
		
		
		
		function Right():void
		{
			if (kick && !hasFlag) {
				rotate(-slowRotSpeed);
			}
			else
			{
				rotate(-rotSpeed);
			}
		}
		
		function Left():void
		{
			if (kick && !hasFlag)
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
			var bombx:Number = x;
			var bomby:Number = y;
			var bomb:Bomb;
			if (kick) {
				var tox:Number = x + velocity.x * bombThrowFactor;
				var toy:Number = y + velocity.y * bombThrowFactor;  
				bombx += forward.x * 16;
				bomby += forward.y * 16;
				bomb = new Bomb(bombx, bomby);
				bomb.throwTo(forward);
			} else {
				bombx -= forward.x * 16;
				bomby -= forward.y * 16;
				bomb = new Bomb(bombx, bomby);
			}
			world.add(bomb);
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
			if (hasFlag) return;
			
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
				if (!hasFlag)kickGfx.visible = true;
			}
		}
		
		function KickOff():void
		{
			makeKickGfx();
			kick = false;
			kickGfx.visible = false;
		}
		
		function checkKeys():void
		{
			if (Input.check(backKey))
			{
				Stop();
				
			} else {
				Forward();
				
			}
			if (Input.check(leftKey))
			{
				Left();
			}
			if (Input.check(rightKey))
			{
				Right();
			}
			if (Input.check(boostKey))
			{
				KickOn();
			}
			else
			{
				KickOff();
			}
			if (Input.check(shieldKey))
			{
				ShieldOn();
			}
			else
			{
				ShieldOff();
			}
			if (Input.check(bombKey))
			{
				if (!xdown) {
					DropBomb();
					xdown = true;
				}
			}
			else {
				xdown = false;
			}
		}
		
		override public function update():void
		{
			if (!going) return;
			super.update();
			
			var collideX:Entity = collide("wall", position.x, y);
			var collideY:Entity = collide("wall", x, position.y);
			var collideCarX:Entity = collide("car", position.x, y);
			var collideCarY:Entity = collide("car", x, position.y);
			if (!collideY && !collideCarY)
			{
				y = position.y;
			}
			else
			{
				position.y = y;
				velocity.y = 0;
			}
			if (!collideX && !collideCarX) {
				x = position.x;
			}
			else {
				position.x = x;
				velocity.x = 0;
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
			
			var collideCar:Car = collide("car", x + forward.x * 8, y + forward.y + 8) as Car;
			if (collideCar) {
				if (collideCar.doesHaveFlag()) {
					myFlag = collideCar.removeFlag();
					hasFlag = true;
					myFlag.setOwner(this);
				}
			}
			
			var bomb:Entity = collide("bomb", x + forward.x*8, y + forward.y*8);
			if (bomb)
			{
				var mt:Bomb = (bomb as Bomb);
				if (!mt.throwing) {
					if (kick)
					{
						mt.velocity = velocity.multipliedBy(bombButtFactor);
					}
					else
					{
						mt.setx(mt.x + forward.x * 8);
						mt.sety(mt.y + forward.y * 8);
					}
				}
			}
			
			var flag:Flag = collide("flag", x, y) as Flag;
			if (flag && !flag.owner) {
				flag.setOwner(this);
				hasFlag = true;
				myFlag = flag;
			}
			
			acceleration = 0;
			velocity.multiply(0.7);
			image.angle = angle;
			
			checkKeys();
		}
		
		public function blast(x:Number, y:Number):void
		{
			if (!shield) {
				if (hasFlag) {
					myFlag.setOwner(null);
					hasFlag = false;
				}
				var vec:Vector2D = new Vector2D(this.x - x, this.y - y);
				var len:Number = vec.length;
				vec.normalize();
				vec.multiply(blastAccel);
				velocity.addTo(vec);
			}
		}
		
		public function doesHaveFlag():Boolean
		{
			return hasFlag;
		}
		
		public function removeFlag():Flag
		{
			myFlag.setOwner(null);
			hasFlag = false;
			var aFlag:Flag = myFlag;
			myFlag = null;
			return aFlag;
		}
		
		public function go():void
		{
			going = true;
		}
	}
}