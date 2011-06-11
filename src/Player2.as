package
{
	import net.flashpunk.graphics.Image;

	public class Player2 extends Car
	{
		[Embed(source="../assets/player2.png")] private static const PLAYER_2_IMAGE:Class;
		
		public function Player2(x:Number, y:Number)
		{
			graphic = new Image(PLAYER_2_IMAGE);
			super(x,y);
		}
	}
}