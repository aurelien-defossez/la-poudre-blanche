package states
{
	import input.KeyboardController;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import sets.Building;

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
		
		/** Buildings*/
		private var _buildings:FlxGroup;
		/** Player detect box (for line of sight) */
		private var _hBox:FlxSprite;
		private var _vBox:FlxSprite;
		
		/** The input controller */
		private var _inputController:KeyboardController;

		public function PlayState() {
		}

		public override function create() : void {
			// The input controller
			_inputController = new KeyboardController();

			// TODO Build this string map procedurally
			var roadMap:String = Debug.defaultMap;

			// The collision map is defined by the read map
			var collisionMap:String = roadMap.split("0").join("a");
			collisionMap = collisionMap.split("1").join("0");
			collisionMap = collisionMap.split("a").join("1");

			// Background tilemap
			_backgroundTilemap = new FlxTilemap();
			_backgroundTilemap.loadMap(roadMap, Assets.ROAD_TILESET, Config.tileSize, Config.tileSize, FlxTilemap.AUTO, 0, 1, 2);

			// Collision tilemap
			_collideMap = new FlxTilemap();
			_collideMap.loadMap(collisionMap, Assets.DEBUG_TILESET, Config.tileSize, Config.tileSize);

			// The player
			_player = new FlxSprite(2.5 * Config.tileSize, 3.5 * Config.tileSize);
			_player.makeGraphic(20, 20);

			_cop = new Cop(_collideMap, _player);

			// Make the camera follow the player
			FlxG.camera.follow(_player);
			_backgroundTilemap.follow();

			// Create the buildings
			_buildingBasements = new FlxGroup();
			_buildingRoofs = new FlxGroup();
			
			// Ease the use of map data
			var mapData:Array = new Array();
			var rows:Array = collisionMap.split("\n");
			for (var row:int = 0; row < rows.length; row++) {
				mapData[row] = rows[row].split(",");
			}
			
			var randomMachine:RandomMachine = new RandomMachine(0 /*Math.random() * 5000000*/);
			var buildingSprites:Vector.<Class> = new Vector.<Class>();
			buildingSprites.push(Assets.BUILDING_1);
			buildingSprites.push(Assets.BUILDING_2);
			buildingSprites.push(Assets.HOUSE_1);
			//buildingSprites.push(Assets.HOUSE_LEFT);
			buildingSprites.push(Assets.HOUSE_MIDDLE);
			//buildingSprites.push(Assets.HOUSE_RIGHT);
			buildingSprites.push(Assets.GARDEN);
			buildingSprites.push(Assets.SKYLINE_GREEN);
			buildingSprites.push(Assets.SKYLINE_PURPLE);
			
			_buildings = new FlxGroup();
			for (row = 0; row < mapData.length; row++ ) {
				for (var col:int = 0; col < mapData[row].length; col++ ) {
					if (mapData[row][col] == 1) {
						var sprite:Class = buildingSprites[randomMachine.nextMax(buildingSprites.length)];
						var building:Building = new Building(col, row, _buildingBasements, _buildingRoofs, sprite);
						_buildings.add(building);
					}
				}
			}
			
			_actors = new FlxGroup();
			_actors.add(_player);
			_actors.add(_cop);

			_hBox = new FlxSprite(0, 0);
			_hBox.makeGraphic(128 + 128 * 4, 128, 0x55ff0000);
			_hBox.x = _player.x + _player.width / 2 - _hBox.width / 2;
			_hBox.y = _player.y + _player.height / 2 - _hBox.height / 2;
			_hBox.visible = false;
			
			_vBox = new FlxSprite(0, 0);
			_vBox.makeGraphic(128, 128 + 128 * 4, 0x55ff0000);
			_vBox.x = _player.x + _player.width / 2 - _vBox.width / 2;
			_vBox.y = _player.y + _player.height / 2 - _vBox.height / 2;
			_vBox.visible = false;
			
			// Add elements to the states
			// The input controller first
			add(_inputController);

			// The background part
			add(_backgroundTilemap);
			add(_collideMap);
			add(_buildingBasements);
			// The actors (player, cops, unicorns...)
			add(_actors);

			// And the buildings roofs
			add(_buildingRoofs);
			
			add(_hBox);
			add(_vBox);
		}

		public override function update() : void{
			super.update();

			viewRoutine();
			
			var speed:int = Config.playerWalkSpeed;
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
		
		private function viewRoutine() : void {
			for (var i:int = 0; i < _buildings.length; i++) _buildings.members[i].alpha = 1;
			
			FlxG.overlap(_vBox, _buildings, manageBuildingRoof);
			FlxG.overlap(_hBox, _buildings, manageBuildingRoof);
			
			_hBox.x = _player.x + _player.width / 2 - _hBox.width / 2;
			_hBox.y = _player.y + _player.height / 2 - _hBox.height / 2;
			_vBox.x = _player.x + _player.width / 2 - _vBox.width / 2;
			_vBox.y = _player.y + _player.height / 2 - _vBox.height / 2;
		}
			
		private function manageBuildingRoof(player:FlxBasic, roof:FlxBasic) : void {
			var building:FlxSprite = roof as FlxSprite;
			if (building != null)
			{
				building.alpha = Config.buildingAlpha;
			}
		}
		
	}
}
