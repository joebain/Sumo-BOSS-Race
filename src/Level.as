package
{
	import com.cheezeworld.entity.Entity;
	
	import flash.utils.ByteArray;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	
	public class Level extends World
	{
		private var tileSpacing:int = 16;
		
		[Embed(source="../assets/background.png")]
		private static const BG:Class;
		
		[Embed(source="../assets/vignette.png")]
		private static const VG:Class;
		
		public function Level(map:Class)
		{
			loadLevel(map);
			
			addGraphic(new Image(BG), 100);
			addGraphic(new Image(VG), 0);
		}
		
		private function loadLevel(xml:Class):void
		{
			var ba:ByteArray = new xml;
			var levelString:String = ba.readUTFBytes(ba.length);
			var xmlData:XML = new XML(levelString);
			
			// load the walls
			
			var wallString:String = xmlData.walls[0].text();
			
			var y:int = 0;
			var x:int = 0;
			for (var i:int; i < wallString.length; ++i)
			{
				var s:String = wallString.charAt(i);
				switch (s)
				{
					case '1':
						add(new Wall(x*tileSpacing,y*tileSpacing));
						break;
						
					case'\n':
						x = -1;
						++y;
						break;
				}
				++x;
			}
			
			// load the players
			var xmlPlayer:XML = xmlData.actors.player1[0];
			var player1:Car = new Player1(xmlPlayer.attribute("x"), xmlPlayer.attribute("y"));
			add(player1);
			
			xmlPlayer = xmlData.actors.player2[0];
			var player2:Car = new Player2(xmlPlayer.attribute("x"), xmlPlayer.attribute("y"));
			add(player2);
		}
	}
}