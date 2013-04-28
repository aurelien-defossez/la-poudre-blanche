package states
{
	import actors.Player;
	import actors.Ponycorn;
	import flash.text.CSMSettings;
	import input.KeyboardController;
	import maps.Map;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import sets.Building;

	import actors.Cop;
	import actors.Player;

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
		private var _cops:FlxGroup;
		/** All actors are stored in this group, player included */
		private var _actors:FlxGroup;

		/** Buildings*/
		private var _buildings:Array;

		/** The input controller */
		private var _inputController:KeyboardController;
		
		public function PlayState() {
		}

		public override function create() : void {
			// The input controller
			_inputController = new KeyboardController();

			// The player
			_player = new Player(_inputController, this, 1.5, 3.5);
			// The bad cop (or is it the good one?)
			_cop = new Cop(_player);
			
			loadLevel(new Map(11, 14));

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

			_buildings = new Array();
			
			for (var row:int = 0; row < _map.nRows; row++ ) {
				_buildings[row] = new Array();
				
				for (var col:int = 0; col < _map.nCols; col++ ) {
					if (_map.at(row, col) == 1) {
						var sprite:Class = buildingSprites[randomMachine.nextMax(buildingSprites.length)];
						_buildings[row][col] = new Building(col, row, _buildingBasements, _buildingRoofs, sprite);
					}
				}
			}
			
			_cops = new FlxGroup();
			_cops.add(_cop);
			
			_actors = new FlxGroup();
			_actors.add(_player);
			_actors.add(_cops);
			
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
			
			// HUD
			add(new Hud(_player));
		}
		
		public function loadLevel(map:Map) : void {
			_map = map;
			
			// Background tilemap
			_backgroundTilemap = new FlxTilemap();
			_backgroundTilemap.loadMap(_map.getRoadMap(), Assets.ROAD_TILESET, Config.tileSize, Config.tileSize, FlxTilemap.AUTO, 0, 1, 2);

			// Collision tilemap
			_collideMap = new FlxTilemap();
			_collideMap.loadMap(_map.getCollisionMap(), Assets.DEBUG_TILESET, Config.tileSize, Config.tileSize);
			
			// Apply maps
			_player.collideMap = _collideMap;
			_cop.collideMap = _collideMap;

			// Make the camera follow the player
			FlxG.camera.follow(_player);
			_backgroundTilemap.follow();
		}

		public override function update() : void {
			super.update();

			var i:int;
			var j:int;
			var changedTile:Boolean = _player.changedTile();

			// Update buildings manually
			for (i = 0; i < _map.nRows; i++) {
				for (j = 0; j < _map.nCols; j++) {
					var building:Building = getBuilding(i, j);

					if (building) {
						building.update();

						if (changedTile) {
							building.alpha = 1;
						}
					}
				}
			}

			if (changedTile) {
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
			var row:Array = _buildings[i];

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
		
		public function dropBomb(x:int, y:int) : void {
			// The bomb is dropped at the given location
			
			
			// Spawn the ponycorn
			_actors.add(new Ponycorn(x, y));
			 
			// Check for nearby cops
			for (var i:int = 0; i < _cops.length; i++) {
				var cop:Cop = _cops.members[i];
				
				var distance:Number = FlxU.getDistance(new FlxPoint(x, y), new FlxPoint(cop.x, cop.y));
				if (distance < Config.ninjaBombRadius) {
					// The cop is hit by the bomb
					cop.takeBomb();
				}
			}
		}
	}
}
