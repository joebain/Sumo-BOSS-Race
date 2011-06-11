package
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class Player1 extends Car
	{
		[Embed(source="../assets/player1.png")] private static const PLAYER_1_IMAGE:Class;
		
		private var xdown:Boolean = false;
		
		public function Player1(x:Number, y:Number)
		{
			graphic = new Image(PLAYER_1_IMAGE);
			super(x,y);
		}
		
		override public function update():void
		{
			super.update();
			if (Input.check(Key.Z))
			{
				Forward();
			} else {
				Stop();
			}
			if (Input.check(Key.LEFT))
			{
				Left();
			}
			if (Input.check(Key.RIGHT))
			{
				Right();
			}
			if (Input.check(Key.X))
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
	}
}