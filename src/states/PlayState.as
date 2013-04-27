package states
{
	import input.KeyboardController;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;

	import actors.Cop;

	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class PlayState extends FlxState {
		/** The road background tilemap */
		private var _backgroundTilemap:FlxTilemap;
		/** The collision tilemap (building basements) */
		private var _collideMap:FlxTilemap;
		/** The building roofs */
		private var _buildingRoofs:FlxGroup;
		/** The building basements */
		private var _buildingBasements:FlxGroup;

		/** The player */
		private var _player:FlxSprite;
		/** The cop */
		private var _cop:Cop;
		/** All actors are stored in this group, player included */
		private var _actors:FlxGroup;

		/** The input controller */
		private var _inputController:KeyboardController;

		public function PlayState() {
		}

		public override function create() : void {
			// The input controller
			_inputController = new KeyboardController();

			// TODO Build this string map procedurally
			var roadMap:String = "0,0,0,0,0,0,0\n" +
								 "0,0,0,0,1,0,0\n" +
								 "0,1,1,1,1,1,0\n" +
								 "0,0,1,0,1,0,0\n" +
								 "0,1,1,1,1,1,0\n" +
								 "0,1,0,1,0,1,0\n" +
								 "0,1,0,1,0,1,0\n" +
								 "0,1,1,1,1,1,0\n" +
								 "0,0,0,0,0,0,0";

			// The collision map is defined by the read map
			var collisionMap:String = roadMap.split("0").join("a");
			collisionMap = collisionMap.split("1").join("0");
			collisionMap = collisionMap.split("a").join("1");

			// Background tilemap
			_backgroundTilemap = new FlxTilemap();
			_backgroundTilemap.loadMap(roadMap, Assets.ROAD_TILESET, 128, 128, FlxTilemap.AUTO, 0, 1, 2);

			// Collision tilemap
			_collideMap = new FlxTilemap();
			_collideMap.loadMap(collisionMap, Assets.DEBUG_TILESET, 128, 128);

			// The player
			_player = new FlxSprite(140, 140);
			_player.makeGraphic(20, 20);

			_cop = new Cop(_collideMap, _player);

			// Make the camera follow the player
			FlxG.camera.follow(_player);
			_backgroundTilemap.follow();

			// Create the buildings
			_buildingBasements = new FlxGroup();
			_buildingRoofs = new FlxGroup();

			var data:Array = collisionMap.split(",");
			var mapWidth:int = _collideMap.width;
			for (var i:uint = 0; i < data.length; i++) {

			}

			_actors = new FlxGroup();
			_actors.add(_player);
			_actors.add(_cop);

			// Add elements to the states
			// The input controller first
			add(_inputController);

			// The background part
			add(_backgroundTilemap);
			add(_collideMap);

			// The actors (player, cops, unicorns...)
			add(_actors);

			// And the buildings roofs
			add(_buildingRoofs);
		}

		public override function update() : void{
			super.update();

			var speed:int = 2;
			if (_inputController.up) {
				_player.y -= speed;
			}
			else if (_inputController.down) {
				_player.y += speed;
			}

			if (_inputController.left) {
				_player.x -= speed;
			}
			else if (_inputController.right) {
				_player.x += speed;
			}

			FlxG.collide(_collideMap, _player);
		}
	}
}
