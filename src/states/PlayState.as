package states
{
	import actors.ElephantHallucination;
	import actors.GhostAnimation;
	import actors.Player;
	import actors.Ponycorn;
	import flash.text.CSMSettings;
	import input.KeyboardController;
	import maps.Map;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import sets.Building;
	import animations.NinjaAnimation
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
		/** Hallucinations blocking the player */
		private var _hallucinations:FlxGroup;
		private var _spawnedHallucinations:Array;

		/** Buildings*/
		private var _buildings:Array;

		/** The input controller */
		private var _inputController:KeyboardController;
		
		private var _randomMachine:RandomMachine;
		
		public function PlayState() {
		}

		public override function create() : void {
			_randomMachine = new RandomMachine(Math.random());
			
			// The input controller
			_inputController = new KeyboardController();

			// The player
			_player = new Player(_inputController, this);
			// The bad cop (or is it the good one?)
			_cop = new Cop(_collideMap, _player);
			
			loadLevel(0);

			// Create the buildings
			_buildingBasements = new FlxGroup();
			_buildingRoofs = new FlxGroup();
			
			var buildingSprites:Vector.<Class> = new Vector.<Class>();
			buildingSprites.push(Assets.BUILDING_1);
			buildingSprites.push(Assets.BUILDING_2);
			buildingSprites.push(Assets.HOUSE_1);
			buildingSprites.push(Assets.GARDEN);
			buildingSprites.push(Assets.SKYLINE_GREEN);
			
			//buildingSprites.push(Assets.HOUSE_LEFT);
			buildingSprites.push(Assets.HOUSE_MIDDLE);
			//buildingSprites.push(Assets.HOUSE_RIGHT);
			
			// Temporary: Purple skyline is the disco club
			//buildingSprites.push(Assets.SKYLINE_PURPLE);

			_buildings = new Array();
			
			for (var row:int = 0; row < _map.nRows; row++ ) {
				_buildings[row] = new Array();
				
				for (var col:int = 0; col < _map.nCols; col++ ) {
					if (_map.at(row, col) == 1) {
						var sprite:Class;
						
						if (row == _map.target.x && col == _map.target.y) {
							sprite = Assets.SKYLINE_PURPLE;
						} else {
							sprite = buildingSprites[_randomMachine.nextMax(buildingSprites.length)];
						}
						_buildings[row][col] = new Building(col, row, _buildingBasements, _buildingRoofs, sprite);
					}
				}
			}
			
			_cops = new FlxGroup();
			_cops.add(_cop);
			
			_actors = new FlxGroup();
			_actors.add(_player);
			_actors.add(_cops);
			
			_hallucinations = new FlxGroup();
			
			// Add elements to the states
			// The input controller first
			add(_inputController);

			// The background part
			add(_backgroundTilemap);
			add(_collideMap);
			add(_buildingBasements);
			// The actors (player, cops, unicorns...)
			add(_actors);
			add(_hallucinations);

			// And the buildings roofs
			add(_buildingRoofs);
			
			// HUD
			add(new Hud(_player));
		}
		
		public function loadLevel(mapId:int) : void {
			_map = new Map();
			_map.load(Config.levels[mapId]);
			
			// Background tilemap
			_backgroundTilemap = new FlxTilemap();
			_backgroundTilemap.loadMap(_map.roadMap, Assets.ROAD_TILESET, Config.tileSize, Config.tileSize, FlxTilemap.AUTO, 0, 1, 2);

			// Collision tilemap
			_collideMap = new FlxTilemap();
			_collideMap.loadMap(_map.collisionMap, Assets.DEBUG_TILESET, Config.tileSize, Config.tileSize);
			
			// Move player
			_player.x = (_map.player.x + 0.3) * Config.tileSize
			_player.y = (_map.player.y + 0.25) * Config.tileSize
			
			// Apply maps
			_player.collideMap = _collideMap;
			_cop.collideMap = _collideMap;

			// Make the camera follow the player
			FlxG.camera.follow(_player);
			_backgroundTilemap.follow();
			
			// Create the hallucination array
			_spawnedHallucinations = new Array();
			var i:int;
			var j:int;
			for (i = 0;  i < _map.nRows; i++) {
				_spawnedHallucinations[i] = new Array();
				
				for (j = 0;  j < _map.nCols; j++) {
					_spawnedHallucinations[i][j] = null;
				}
			}
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
			
			// Only the player can collide with it's hallicinations
			FlxG.collide(_player, _hallucinations);
			
			// Hallicination array update
			var x:int;
			var y:int = 0;
			for (y = 0; y < _map.nCols; y++) {
				for (x = 0; x < _map.nRows; x++) {
					if (_spawnedHallucinations[x][y] != null && !(_spawnedHallucinations[x][y] as FlxObject).alive) {
						_spawnedHallucinations[x][y] = null;
					}
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
		
		public function spawnHallucination() : void {
			// Get a random road tile
			var tx:int = -1;
			var ty:int = -1;
			
			// Fill an array of possible spawn tiles
			var possibleTiles:Vector.<FlxPoint> = new Vector.<FlxPoint>();
			
			var distance:int = 2;
			var playerMidPoint:FlxPoint = _player.getMidpoint();
			var tile:Object = Utils.getTile(playerMidPoint.x, playerMidPoint.y);
			var startX:int = Math.max(0, tile.j - distance);
			var startY:int = Math.max(0, tile.i - distance);
			var endX:int = Math.min(_map.nCols, tile.j + distance + 1);
			var endY:int = Math.min(_map.nRows, tile.i + distance + 1);
			for (var i:int = startY; i <  endY; i++ ) {
				for (var j:int = startX; j <  endX; j++ ) {
					if (_map.at(i, j) == 0 && (i != tile.i || j != tile.j) && _spawnedHallucinations[i][j] == null) {
						possibleTiles.push(new FlxPoint(j, i));
					}
				}
			}
			
			if(possibleTiles.length > 0 ) {
				// Spawn a random hallucination
				var randomTile:FlxPoint = possibleTiles[_randomMachine.nextMax(possibleTiles.length)];
				trace("Spawned at : [" +randomTile.x + "," + randomTile.y + "]");
				var x:int = randomTile.x * Config.tileSize;
				var y:int = randomTile.y * Config.tileSize;
				var hallucination:FlxSprite;
				
				if (_randomMachine.nextMinMax(0,100) > 50) {
					hallucination = new ElephantHallucination(x, y);
				} else {
					hallucination = new GhostAnimation(x, y);
				}
				
				_spawnedHallucinations[randomTile.y][randomTile.x] = hallucination;
				_hallucinations.add(hallucination);
			}
		}
		
		public function dropBomb(x:int, y:int) : void {
			// The bomb is dropped at the given location
			
			// Add the animation
			_actors.add(new NinjaAnimation(x, y));
			 
			// Check for nearby cops
			for (var i:int = 0; i < _cops.length; i++) {
				var cop:Cop = _cops.members[i];
				
				var distance:Number = FlxU.getDistance(new FlxPoint(x, y), new FlxPoint(cop.x, cop.y));
				if (distance < Config.ninjaBombRadius) {
					// The cop is hit by the bomb
					cop.takeBomb();
					
					// The pony is placed according to the cop direction
					var dir:uint = cop.currentDirection;
					var x:int = cop.x;
					var y:int = cop.y;
					
					var pony:Ponycorn = new Ponycorn(0, 0);
					if (dir ==FlxObject.UP) {
						// up
						y = cop.y - pony.height;
					} else if (dir == FlxObject.DOWN) {
						y = cop.y + cop.height;
						// down
					} else if (dir == FlxObject.LEFT) {
						// left
						x = cop.x - pony.width;
					} else {
						// right
						x = cop.x + cop.width;
					}
					
					pony.x = x;
					pony.y = y;
					_actors.add(pony);
				}
			}
		}
	}
}
