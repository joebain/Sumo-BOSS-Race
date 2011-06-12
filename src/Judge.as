package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import com.cheezeworld.math.Vector2D;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Judge extends Entity
	{
		private var car1:Car;
		private var car2:Car;
		private var car1score:int;
		private var car2score:int;
		private var text:Text;
		private static var instance:Judge;
		private var car2pos:Vector2D;
		private var car1pos:Vector2D;
		private var winScore:int = 5;
		private var level:Level;
		private var gotext:GoText;
		
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
		
		public function Judge(car1:Car, car2:Car, level:Level, gotext:GoText)
		{
			super(512, 20);
			
			instance = this;
			
			this.car1 = car1;
			this.car2 = car2;
			this.level = level;
			this.gotext = gotext;
			
			car1pos = car1.position;
			car2pos = car2.position;
			
			text = new Text("0:0");
			text.centerOO();
			graphic = text;
			
			layer = -1;
			
			car1score = 4;
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
			
			if (car1score == winScore) {
				gotext.say("Player 1 wins");
				level.stop()
			}
			if (car2score == winScore) {
				gotext.say("Player 2 wins");
				level.stop();
			}
			
			if (Input.check(Key.DIGIT_1) || Input.check(Key.DIGIT_2)) {
				level.reset();
				car1score = 0;
				car2score = 0;
			}
		}
	}
}