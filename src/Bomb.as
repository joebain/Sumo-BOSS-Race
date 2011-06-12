package
{
	import flash.utils.getTimer;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import com.cheezeworld.math.Vector2D;
	
	public class Bomb extends MomentumThing
	{
		[Embed(source="../assets/bomb.png")]
		private static const BOMB:Class;
		
		[Embed(source="../assets/explosion.png")]
		private static const EXPLODE:Class;
		
		private var startTime:int;
		private var durationToStart:int = 1000;
		private var durationToExplode:int = 1200;
		private var explosionSize:Number = 100;
		private var exploding:Boolean = false;
		private var startThrowTime:int;
		var throwing:Boolean = false;
		private var throwSpeed:Number = 10;
		private var timeForThrow:Number = 250;
		private var throwDir:Vector2D;
		private var image:Image;
		
		public function Bomb(x:Number, y:Number)
		{
			super(x, y);
			image = new Image(BOMB);
			graphic = image;
			startTime = getTimer();
			
			position.x = x;
			position.y = y;
			width = 16;
			height = 16;
			
			type = "bomb";
		}
		
		public override function update():void
		{
			if (throwing) {
				var throwTime:int = getTimer() - startThrowTime;
				if (throwTime > timeForThrow) {
					throwing = false;
					image.scale = 1;
				} else {
					setx(x + throwDir.x*throwSpeed);
					sety(y + throwDir.y*throwSpeed);
				}
			}
			else {
				super.update();
				if (!exploding) {
					x = position.x;
					y = position.y;
				} else {
					if (collide("wall", position.x, position.y)) {
						position.x = x;
						position.y = y;
						StopDead();
					}
					position.x = x;
					position.y = y;
				}
				velocity.multiply(0.95);
			}
			
			
			var duration:int = getTimer() - startTime; 
			if (duration > durationToStart && !exploding) {
				startToExplode();
			} else if (duration > durationToExplode) {
				explode();
			}
			
			if (duration > durationToStart*0.5 && Math.random() * durationToExplode < duration) {
				graphic.visible = !graphic.visible;
			}
		}
		
		private function startToExplode():void
		{
			if (exploding) return;
			
			var image:Image = new Image(EXPLODE);
			image.originX = 8;
			image.originY = 8;
			image.centerOO();
			explosionSize = image.width;
			graphic = image;
			exploding = true;
			
			var colliders:Array = new Array;
			var xbox:Number = x - explosionSize * 0.5 + 8;
			var ybox:Number = y - explosionSize * 0.5 + 8;
			world.collideRectInto("bomb", xbox, ybox, explosionSize, explosionSize, colliders);
			for each (var bomb:Bomb in colliders) {
				if (bomb != this) bomb.startToExplode();
			}
			colliders = new Array;
			world.collideRectInto("car", xbox, ybox, explosionSize, explosionSize, colliders);
			for each (var car:Car in colliders) {
				car.blast(x,y);
			}
		}
		
		function throwTo(dir:Vector2D) {
			startThrowTime = flash.utils.getTimer();
			throwDir = dir.copy();
			throwing = true;
			image.scale = 1.5;
		}
		
		private function explode():void
		{
			world.remove(this);
		}
	}
}