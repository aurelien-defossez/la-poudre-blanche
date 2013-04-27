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
		private var _backgroundTilemap:FlxTilemap;
		private var _collideMap:FlxTilemap;
		
		private var _player:FlxSprite;
		
		public function PlayState() 
		{
			
		}
		
		public override function create() : void
		{
			var roadMap:String = "0,0,0,0,0,0,0\n" +
								 "0,1,1,1,1,1,0\n" +
								 "0,0,1,0,1,0,0\n" +
								 "0,1,1,1,1,1,0\n" +
								 "0,1,0,1,0,1,0\n" +
								 "0,1,0,1,0,1,0\n" +
								 "0,1,1,1,1,1,0\n" +
								 "0,0,0,0,0,0,0";
							 
			var collisionMap:String = roadMap.split("0").join("a");
			collisionMap = collisionMap.split("1").join("0");
			collisionMap = collisionMap.split("a").join("1");
			
			_backgroundTilemap = new FlxTilemap();
			_backgroundTilemap.loadMap(roadMap, Assets.ROAD_TILESET, 128, 128, FlxTilemap.AUTO, 0, 1, 2);
			add(_backgroundTilemap);
			
			_collideMap = new FlxTilemap();
			_collideMap.loadMap(collisionMap, Assets.DEBUG_TILESET, 128, 128);
			add(_collideMap);
			
			_player = new FlxSprite(FlxG.width / 2 - 10, FlxG.height / 2 - 10);
			_player.makeGraphic(20, 20);
			add(_player);
		
			_backgroundTilemap.follow();
			FlxG.camera.follow(_player);
		}
		
		public override function update() : void
		{
			super.update();
			
			var speed:int = 2;
			if (FlxG.keys.pressed("UP")) {
				_player.y -= speed;
			}else if (FlxG.keys.pressed("DOWN")) {
				_player.y += speed;
			}
			
			if (FlxG.keys.pressed("LEFT")) {
				_player.x -= speed;
			}else if (FlxG.keys.pressed("RIGHT")) {
				_player.x += speed;
			}
			
			FlxG.collide(_collideMap, _player);
		}
	}

}