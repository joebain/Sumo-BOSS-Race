package
{
	import flash.utils.getTimer;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Bomb extends Entity
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
		
		public function Bomb(x:Number, y:Number)
		{
			super(x, y);
			graphic = new Image(BOMB);
			startTime = getTimer();
		}
		
		public override function update():void
		{
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
				bomb.startToExplode();
			}
			
			world.collideRectInto("car", xbox, ybox, explosionSize, explosionSize, colliders);
			for each (var car:Car in colliders) {
				car.blast(x,y);
			}
		}
		
		private function explode():void
		{
			
			
			world.remove(this);
		}
	}
}