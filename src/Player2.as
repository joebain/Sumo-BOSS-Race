package
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;

	public class Player2 extends Car
	{
		[Embed(source="../assets/player2.png")] private static const PLAYER_2_IMAGE:Class;
		
		public function Player2(x:Number, y:Number)
		{
			graphic = new Image(PLAYER_2_IMAGE);
			super(x,y);
			
			forwardKey = null;
			leftKey = Key.J;
			rightKey = Key.L;
			backKey = Key.K;
			boostKey = Key.N;
			bombKey = Key.M;
			shieldKey = Key.B;
			
			playerNumber = 2;
		}
	}
}