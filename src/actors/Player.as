package actors {

	import input.Controller;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import states.PlayState;

	public class Player extends FlxSprite {

		public var direction:FlxPoint;
		private var moveThisFrame:Boolean;

		private var _collideMap:FlxTilemap;
		private var _inputController:Controller;
		private var _tileIndex:Object;
		private var _state:PlayState;
		
		private var _drugCounter:int
		
		private var _runTimer:Number;
		/** Each drug consumption increase this counter : use it to make crazy things */
		private var _intoxication:int;
		
		private const DIRECTIONS:Object = {
			south: 0,
			north: 1,
			east: 2,
			west: 3
		};

		private const ANIMATIONS:Object = {
			walk: [0, 1, 2, 3],
			run: [4, 1, 3, 5]
		}

		private const TOTAL_FRAMES:Number = 7;
		private const STANDING_FRAME:Number = 6;
		
		public function get drugCounter() : int { return _drugCounter; };
		public function set drugCounter(value:int) : void { _drugCounter = value; };
		
		public function get runTimer() : Number { return _runTimer; };
		
		public function Player(collideMap:FlxTilemap, inputController:Controller, state:PlayState, i:Number, j:Number) {
			super(j * Config.tileSize, i * Config.tileSize);
			
			_state = state;
			_drugCounter = Config.baseDrugCounter;
			_intoxication = 0;
			_runTimer = 0;
			_collideMap = collideMap;
			_inputController = inputController;

			loadGraphic(Assets.HEENOK_TILESET, true, false, 64, 64)

			direction = new FlxPoint(1, 0);
			moveThisFrame = false;
			frame = STANDING_FRAME;

			for (var dir:String in DIRECTIONS) {
				for (var anim:String in ANIMATIONS) {
					var key:String = anim + "-" + dir;
					var frames:Array = new Array();
					for each (var f:Number in ANIMATIONS[anim]) {
						frames.push(f + DIRECTIONS[dir] * TOTAL_FRAMES);
					}

					addAnimation(key, frames, 10, true);
				}
			}
		}

		public override function update() : void {
			// Update position
			var speed:int = 0;
			if (_runTimer > 0) {
				_runTimer -= FlxG.elapsed;
				speed = Config.playerRunSpeed;
			} else {
				_runTimer = 0;
				speed = Config.playerWalkSpeed;
			}
			
			if (_inputController.up) {
				direction.y = -1;
				move();
			}
			else if (_inputController.down) {
				direction.y = 1;
				move();
			}
			else {
				direction.y = 0;
			}

			if (_inputController.left) {
				direction.x = -1;
				move();
			}
			else if (_inputController.right) {
				direction.x = 1;
				move();
			}
			else {
				direction.x = 0;
			}

			if (_drugCounter > 0) {
				// Speed shoot
				if (_inputController.actionA) {
					_drugCounter--;
					_runTimer += Config.runTime;
				}
				
				// Ninja powder
				if (_inputController.actionB)
				{
					_drugCounter--;
					_state.dropBomb(x, y);
				}
			}
			
			// Check for collision with buildings
			FlxG.collide(_collideMap, this);

			if (moveThisFrame) {
				x = x + direction.x * speed;
				y = y + direction.y * speed;

				if (direction.x == 1) {
					play("walk-east");
				}
				else if (direction.x == -1) {
					play("walk-west");
				}
				else if (direction.y == 1) {
					play("walk-south");
				}
				else if (direction.y == -1) {
					play("walk-north");
				}
			}
			else {
				if (direction.x == 1) {
					frame = TOTAL_FRAMES * DIRECTIONS["south"] + STANDING_FRAME;
				}
				else if (direction.x == -1) {
					frame = TOTAL_FRAMES * DIRECTIONS["north"] + STANDING_FRAME;
				}
				else if (direction.y == 1) {
					frame = TOTAL_FRAMES * DIRECTIONS["east"] + STANDING_FRAME;
				}
				else if (direction.y == -1) {
					frame = TOTAL_FRAMES * DIRECTIONS["west"] + STANDING_FRAME;
				}
				else {
					frame = TOTAL_FRAMES * DIRECTIONS["south"] + STANDING_FRAME;
				}
			}

			moveThisFrame = false;
			super.update();
		}

		public function changedTile() : Boolean {
			// Do not call this method in update, because it returns a boolean
			// telling if the player has changed tile since the last update,
			// which is used by the game to know which buildings to fade

			if (_tileIndex == null) {
				var center:FlxPoint = getCenter();
				_tileIndex = Utils.getTile(center.x, center.y);
				return true;
			} else {
				var previousTile:Object = {
					x: _tileIndex.x,
					y: _tileIndex.y
				};

				_tileIndex = Utils.getTile(x, y);

				return (_tileIndex.x == previousTile.x && _tileIndex.y == previousTile.y);
			}
		}

		public function getCenter() : FlxPoint {
			return new FlxPoint(
				x + width / 2,
				y + height / 2
			);
		}

		public function getTileIndex() : Object {
			return _tileIndex;
		}

		public function move(): void {
			moveThisFrame = true;
		}
	}
}
