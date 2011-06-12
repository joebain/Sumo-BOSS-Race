package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Text;
	
	import flash.utils.getTimer;
	
	public class GoText extends Entity
	{
		private var startTime:int;
		private var startTimer:int;
		
		private var gotext:Text;
		private var starting:Boolean = true;
		private var player2:Car;
		private var player1:Car;
		
		Text.size = 300;
		
		public function GoText(player1:Car, player2:Car)
		{
			super(512, 384);
			
			this.player1 = player1;
			this.player2 = player2;
			
			startTime = flash.utils.getTimer();
			
			gotext = new Text("Ready");
			gotext.centerOO();
			graphic = gotext;
			layer = -1;
		}
		
		override public function update():void
		{
			if (starting) {
				startTimer = flash.utils.getTimer() - startTime;
				
				if (startTimer > 3000) {
					player1.go();
					player2.go();
					starting = false;
					visible = false;
				}
				else if (startTimer > 2000) {
					gotext.text = "Go";
					gotext.centerOO();
				}
				else if (startTimer > 1000) {
					gotext.text = "Set";
					gotext.centerOO();
				} else {
					gotext.text = "Ready";
					gotext.centerOO();
				}
			}
		}
		
		public function say(s:String):void
		{
			Text.size = 300;
			gotext = new Text(s);
			graphic = gotext;
			visible = true;
			gotext.centerOO();
			
		}
		
		public function reset():void
		{
			starting = true;
			startTime = flash.utils.getTimer();
			visible = true;
			
		}
	}
}