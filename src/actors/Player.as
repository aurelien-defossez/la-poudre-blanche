package actors {

	import input.Controller;
	import maps.Map;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
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
		private var _map:Map;

		private var _drugCounter:int

		private var _runTimer:Number;
		/** Each drug consumption increase this counter : use it to make crazy things */
		private var _intoxication:int;

		private var _walkSound:FlxSound;
		private var _runSound:FlxSound;

		public function set collideMap(value:FlxTilemap) : void { _collideMap = value; };

		public function get map() : Map { return _map; };
		public function get drugCounter() : int { return _drugCounter; };
		public function set drugCounter(value:int) : void { _drugCounter = value; };

		public function get runTimer() : Number { return _runTimer; };

		public function Player(inputController:Controller, state:PlayState, map:Map) {
			super();

			_state = state;
			_map = map;
			_drugCounter = map.drug;
			_intoxication = 0;
			_runTimer = 0;
			_inputController = inputController;

			loadGraphic(Assets.HEENOK_TILESET, true, false, 64, 64);

			// Change the player's hit box
			height = 25;
			width = 50;
			offset = new FlxPoint((64 - width) / 2, 64 - height);

			direction = new FlxPoint(1, 0);
			moveThisFrame = false;
			frame = Assets.STANDING_FRAME;

			for (var dir:String in Assets.DIRECTIONS) {
				for (var anim:String in Assets.ANIMATIONS) {
					var key:String = anim + "-" + dir;
					var frames:Array = new Array();
					for each (var f:Number in Assets.ANIMATIONS[anim]) {
						frames.push(f + Assets.DIRECTIONS[dir] * Assets.TOTAL_FRAMES);
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

				if (_runTimer <= 0) {
					_runTimer = 0;
					_state.stopFadeSounds();
				}
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
			else if (_inputController.movementKeyPressed()) {
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
			else if (_inputController.movementKeyPressed()) {
				direction.x = 0;
			}

			if (_drugCounter > 0) {
				// Speed shoot
				if (_inputController.actionA && _drugCounter >= Config.runPrice) {
					FlxG.play(Assets.SNIF, Config.SNIF_VOLUME);
					_intoxication += Config.runIntox;
					_drugCounter -= Config.runPrice;
					_runTimer += Config.runTime;
					_state.spawnHallucination();
					_state.fadeSounds();
				}

				// Ninja powder
				if (_inputController.actionB && _drugCounter >= Config.ninjaPrice) {
					FlxG.play(Assets.POUF, Config.POUF_VOLUME);
					_intoxication += Config.ninjaBombIntox;
					_drugCounter -= Config.ninjaPrice;
					_state.dropBomb(x + width / 2, y + height / 2);
					_state.spawnHallucination();
				}
			}

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
				stop();
			}

			// Check for collision with buildings
			FlxG.collide(_collideMap, this);

			moveThisFrame = false;
			super.update();
		}

		public function stop() : void {
			if (_runSound != null) {
				_runSound.stop();
				_runSound.destroy();
				_runSound = null;
			} else if(_walkSound != null){
				_walkSound.stop();
				_walkSound.destroy();
				_walkSound = null;
			}

			if (direction.x == 1) {
				frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["east"] + Assets.STANDING_FRAME;
			}
			else if (direction.x == -1) {
				frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["west"] + Assets.STANDING_FRAME;
			}
			else if (direction.y == 1) {
				frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["south"] + Assets.STANDING_FRAME;
			}
			else if (direction.y == -1) {
				frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["north"] + Assets.STANDING_FRAME;
			}
			else {
				frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["south"] + Assets.STANDING_FRAME;
			}
		}

		public function changedTile() : Boolean {
			var center:FlxPoint;

			// Do not call this method in update, because it returns a boolean
			// telling if the player has changed tile since the last update,
			// which is used by the game to know which buildings to fade

			if (_tileIndex == null) {
				center = getMidpoint();
				_tileIndex = Utils.getTile(center.x, center.y);
				return true;
			} else {
				var previousTile:Object = {
					i: _tileIndex.i,
					j: _tileIndex.j
				};

				center = getMidpoint();
				_tileIndex = Utils.getTile(center.x, center.y);
				return (_tileIndex.i != previousTile.i || _tileIndex.j != previousTile.j);
			}
		}

		public function getTileIndex() : Object {
			return _tileIndex;
		}

		public function move(): void {
			moveThisFrame = true;

			if (_runTimer > 0) {
				if (_runSound == null) {
					_runSound = FlxG.play(Assets.RUN, Config.RUN_VOLUME, true);
				}
			} else {
				if (_runSound != null) {
					_runSound.stop();
					_runSound.destroy();
					_runSound = null;
				}
				if (_walkSound == null) {
					_walkSound = FlxG.play(Assets.WALK, Config.WALK_VOLUME, true);
				}
			}
		}
	}
}
