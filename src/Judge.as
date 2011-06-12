package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	public class Judge extends Entity
	{
		private var car1:Car;
		private var car2:Car;
		private var car1score:int;
		private var car2score:int;
		private var text:Text;
		private static var instance:Judge;
		
		Text.size = 48;
		
		public static function getJudge():Judge
		{
			return instance;
		}
		
		public function getScore(number:int):int
		{
			if (number == 1) {
				return car1score;
			} else {
				return car2score;
			}
		}
		
		public function Judge(car1:Car, car2:Car)
		{
			super(512, 20);
			
			instance = this;
			
			this.car1 = car1;
			this.car2 = car2;
			
			text = new Text("0:0");
			text.centerOO();
			graphic = text;
			
			layer = -1;
		}
		
		override public function update():void
		{
			if (car1.collide("endzone1", car1.x, car1.y)) {
				if (car1.doesHaveFlag()) {
					car1.removeFlag();
					car1score += 1;
				}
			}
			
			if (car2.collide("endzone2", car2.x, car2.y)) {
				if (car2.doesHaveFlag()) {
					car2.removeFlag();
					car2score += 1;
				}
			}
			
			text.text = car1score + ":" + car2score;
			text.centerOO();
		}
	}
}