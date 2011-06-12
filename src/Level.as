package
{
	import net.flashpunk.Entity;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class Level extends World
	{
		private var tileSpacing:int = 16;
		
		[Embed(source="../assets/background.png")]
		private static const BG:Class;
		
		[Embed(source="../assets/vignette.png")]
		private static const VG:Class;
		
		private var player2:Car;
		private var player1:Car;
		private var text:GoText;
		
		
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
			for (var i:int = 0; i < wallString.length; ++i)
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
			player1 = new Player1(xmlPlayer.attribute("x"), xmlPlayer.attribute("y"));
			add(player1);
			
			xmlPlayer = xmlData.actors.player2[0];
			player2 = new Player2(xmlPlayer.attribute("x"), xmlPlayer.attribute("y"));
			add(player2);
			
			// go text
			text = new GoText(player1, player2);
			add(text);
			
			//end zones
			wallString = xmlData.endzone1[0].text();
			
			y = 0;
			x = 0;
			for (var i:int = 0; i < wallString.length; ++i)
			{
				var s:String = wallString.charAt(i);
				switch (s)
				{
					case '1':
						add(new Endzone(x*tileSpacing*2,y*tileSpacing*2,1));
						break;
					
					case'\n':
						x = -1;
						++y;
						break;
				}
				++x;
			}
			
			wallString = xmlData.endzone2[0].text();
			
			y = 0;
			x = 0;
			for (var i:int = 0; i < wallString.length; ++i)
			{
				var s:String = wallString.charAt(i);
				switch (s)
				{
					case '1':
						add(new Endzone(x*tileSpacing*2,y*tileSpacing*2,2));
						break;
					
					case'\n':
						x = -1;
						++y;
						break;
				}
				++x;
			}
			
			//the flag
			xmlPlayer = xmlData.actors.flag[0];
			var flag:Flag = new Flag(xmlPlayer.attribute("x"), xmlPlayer.attribute("y"));
			add(flag);
			
			//judge
			add(new Judge(player1, player2));
		}
	}
}