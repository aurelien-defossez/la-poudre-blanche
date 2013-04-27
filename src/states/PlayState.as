package states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class PlayState extends FlxState 
	{
		private var _tilemap:FlxTilemap;
		
		private var _player:FlxSprite;
		
		public function PlayState() 
		{
			
		}
		
		public override function create() : void
		{
			var map:String = "0,0,0,0,1,0,0\n" +
							 "0,0,0,0,0,1,0\n" +
							 "0,0,0,0,0,0,0\n" +
							 "0,0,0,1,0,1,0\n" +
							 "0,0,0,0,0,1,0"; 
			
			_tilemap = new FlxTilemap();
			_tilemap.loadMap(map, Assets.DEBUG_TILESET);
			add(_tilemap);
			
			_player = new FlxSprite(FlxG.width / 2 - 10, FlxG.height / 2 - 10);
			_player.makeGraphic(20, 20);
			add(_player);
		}
		
		public override function update() : void
		{
			if (FlxG.keys.pressed("UP")) {
				_player.y -= 2;
			}else if (FlxG.keys.pressed("DOWN")) {
				_player.y += 2;
			}
			
			if (FlxG.keys.pressed("LEFT")) {
				_player.x -= 2;
			}else if (FlxG.keys.pressed("RIGHT")) {
				_player.x += 2;
			}
			
			FlxG.collide(_tilemap, _player);
		}
	}

}