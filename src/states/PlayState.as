package states
{
	import actors.Player;
	import input.KeyboardController;
	import maps.Map;
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
		private var _map:Map;

		/** The building roofs */
		private var _buildingRoofs:FlxGroup;
		/** The building basements */
		private var _buildingBasements:FlxGroup;

		/** The player */
		private var _player:Player;
		/** The cop */
		private var _cop:Cop;
		/** All actors are stored in this group, player included */
		private var _actors:FlxGroup;
		
		/** Buildings*/
		private var _buildings:FlxGroup;
		private var _buildingByCoordinate:Array;
		
		/** The input controller */
		private var _inputController:KeyboardController;

		public function PlayState() {
		}

		public override function create() : void {
			// The input controller
			_inputController = new KeyboardController();

			// TODO Build this string map procedurally
			_map = new Map(20, 20);
			
			// Background tilemap
			_backgroundTilemap = new FlxTilemap();
			_backgroundTilemap.loadMap(_map.getRoadMap(), Assets.ROAD_TILESET, Config.tileSize, Config.tileSize, FlxTilemap.AUTO, 0, 1, 2);

			// Collision tilemap
			_collideMap = new FlxTilemap();
			_collideMap.loadMap(_map.getCollisionMap(), Assets.DEBUG_TILESET, Config.tileSize, Config.tileSize);

			// The player
			_player = new Player(_collideMap, _inputController, 2.5, 3.5);
			
			// The bad cop (or is it the good one?)
			_cop = new Cop(_collideMap, _player);

			// Make the camera follow the player
			FlxG.camera.follow(_player);
			_backgroundTilemap.follow();

			// Create the buildings
			_buildingBasements = new FlxGroup();
			_buildingRoofs = new FlxGroup();
			
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
			_buildingByCoordinate = new Array();
			
			for (var row:int = 0; row < _map.nRows; row++ ) {
				_buildingByCoordinate[row] = new Array();
				
				for (var col:int = 0; col < _map.nCols; col++ ) {
					if (_map.at(row, col) == 1) {
						var sprite:Class = buildingSprites[randomMachine.nextMax(buildingSprites.length)];
						var building:Building = new Building(col, row, _buildingBasements, _buildingRoofs, sprite);
						_buildings.add(building);
						_buildingByCoordinate[row][col] = building;
					}
				}
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
			add(_buildingBasements);
			// The actors (player, cops, unicorns...)
			add(_actors);

			// And the buildings roofs
			add(_buildingRoofs);
		}

		public override function update() : void {
			super.update();

			var i:int;
			var j:int;
			
			// Update buildings manually
			for (i = 0; i < _buildings.length; i++) {
				_buildings.members[i].update();
			}
			
			// Compute player position (in tiles)
			if (_player.changedTile()) {
				// Reset buildings alpha
				for (i = 0; i < _buildings.length; i++) {
					_buildings.members[i].alpha = 1;
				}
				
				var playerPosition:Object = _player.getTileIndex();
				
				// Fade tiles to the left (and the current tile)
				i = playerPosition.i;
				j = playerPosition.j;
				while(j > 0 && getBuilding(i, j) == null) {
					fadeTile(i, j);
					--j;
				}
				
				// Fade tiles to the right
				j = playerPosition.j + 1;
				while(j < _map.nCols - 1 && getBuilding(i, j) == null) {
					fadeTile(i, j);
					++j;
				}
				
				// Fade tiles to the top
				i = playerPosition.i - 1;
				j = playerPosition.j;
				while(i > 0 && getBuilding(i, j) == null) {
					fadeTile(i, j);
					--i;
				}
				
				// Fade tiles to the bottom
				i = playerPosition.i + 1;
				while (i < _map.nRows - 1 && getBuilding(i, j) == null) {
					fadeTile(i, j);
					++i;
				}
			}
		}
		
		private function getBuilding(i:Number, j:Number) : Building {
			var row:Array = _buildingByCoordinate[i];
			
			return (row) ? row[j] : null;
		}
		
		private function fadeTile(i:Number, j:Number) : void {
			// Fade building below the tile
			var building:Building = getBuilding(i + 1, j);
			if (building != null) {
				building.alpha = Config.buildingAlpha;
			}
			
			// Fade building really below the tile
			building = getBuilding(i + 2, j);
			if (building != null) {
				building.alpha = Config.buildingAlpha;
			}
		}
			
		private function manageBuildingRoof(player:FlxBasic, roof:FlxBasic) : void {
			var building:FlxSprite = roof as FlxSprite;
			if (building != null) {
				building.alpha = Config.buildingAlpha;
			}
		}
		
	}
}
