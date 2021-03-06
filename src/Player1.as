package
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class Player1 extends Car
	{
		[Embed(source="../assets/player1.png")] private static const PLAYER_1_IMAGE:Class;
		
		public function Player1(x:Number, y:Number)
		{
			graphic = new Image(PLAYER_1_IMAGE);
			super(x,y);
			
			forwardKey = null;
			leftKey = Key.LEFT;
			rightKey = Key.RIGHT;
			backKey = Key.DOWN;
			boostKey = Key.Z;
			bombKey = Key.X;
			shieldKey = Key.C;
			
			playerNumber = 1;
		}
	}
}