package actors {

	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;

	import maps.Map;

	public class Cop extends FlxSprite {

		public var direction:FlxPoint;

		private var _collideMap:FlxTilemap;
		private var _map:Map;
		private var _player:Player;
		private var _currentAnimation:String;

		private var copPath:FlxPath;
		private var lastPathUpdate:Number = 2;
		private var chasingPlayer:Boolean = false;
		private var notChasingPlayerSince:Number = 0;

		private var _bombTimer:Number;
		private var _currentDirection:uint = FlxObject.RIGHT;

		public function get currentDirection() : uint { return _currentDirection; };
		public function get isUnderBombEffect() : Boolean { return _bombTimer > 0; };

		public function Cop(collideMap:FlxTilemap, map:Map, player:Player) {
			_player = player;
			_collideMap = collideMap;
			_map = map;

			_bombTimer = 0;

			loadGraphic(Assets.GERARD_TILESET, true, false, 64, 64)

			direction = new FlxPoint(1, 0);
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
			if (_bombTimer > 0) {
				// Bombed : do crazy stuff or nothing
				_bombTimer -= FlxG.elapsed;

				stopMoving();
				chasingPlayer = false;
			}
			else {
				lastPathUpdate += FlxG.elapsed;

				if (lastPathUpdate > Config.copPathFindingPeriod) {
					lastPathUpdate -= Config.copPathFindingPeriod;

					var squaredDistanceToPlayer:Number = (_player.x - x) * (_player.x - x) + (_player.y - y) * (_player.y - y);
					if (squaredDistanceToPlayer < Config.copMinSquaredDistanceToPlayerToDetect) {
						// prepare cop start and end position
						var pathStart:FlxPoint = getMidpoint();
						var pathEnd:FlxPoint = _player.getMidpoint();

						if (canSeePlayer(pathStart, pathEnd)) {
							copPath = _collideMap.findPath(pathStart, pathEnd);
							if (copPath) {
								chasingPlayer = true;
								followPath(copPath);
							}
						}
					}
				}

				if (pathSpeed == 0) {
					// Stop cop when end of path is reached
					stopMoving();
					var goToTile:FlxPoint;

					if (chasingPlayer) {
						chasingPlayer = false;

						// find the next destination
						goToTile = getNextCrossOrWallInDirection(_currentDirection);
					}
					else {
						// not chasing a player and not moving
						// start moving in a random direction
						var directions:Array = new Array(
							FlxObject.UP,
							FlxObject.DOWN,
							FlxObject.LEFT,
							FlxObject.RIGHT
						);
						var dir:uint = Math.floor(Math.random() * 4);

						// find the next destination
						goToTile = getNextCrossOrWallInDirection(directions[dir]);
					}

					// go to the next intersection or wall
					var tile:FlxPoint = Utils.getWorldMidpoint(goToTile.y, goToTile.x);
					copPath = _collideMap.findPath(getMidpoint(), tile);
					if (copPath) {
						followPath(copPath);
					}
				}
			}

			if (velocity.x != 0 || velocity.y != 0) {
				var animationMovement:String = "run";
				if (chasingPlayer) {
					animationMovement = "run";
				}
				if (pathAngle > 45 && pathAngle <= 135) {
					play(animationMovement + "-east");
					_currentDirection = FlxObject.RIGHT;
				}
				else if (pathAngle <= -45 && pathAngle > -135) {
					play(animationMovement + "-west");
					_currentDirection = FlxObject.LEFT;
				}
				else if (pathAngle > -45 && pathAngle <= 45) {
					play(animationMovement + "-north");
					_currentDirection = FlxObject.UP;
				}
				else if (pathAngle > 135 || pathAngle <= -135) {
					play(animationMovement + "-south");
					_currentDirection = FlxObject.DOWN;
				}
			}
			else {
				if (_currentDirection == FlxObject.RIGHT) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["east"] + Assets.STANDING_FRAME;
				}
				else if (_currentDirection == FlxObject.LEFT) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["west"] + Assets.STANDING_FRAME;
				}
				else if (_currentDirection == FlxObject.UP) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["north"] + Assets.STANDING_FRAME;
				}
				else if (_currentDirection == FlxObject.DOWN) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["south"] + Assets.STANDING_FRAME;
				}
			}

			super.update();
		}

		public function getNextCrossOrWallInDirection(dir:uint) : FlxPoint {
			var start:FlxPoint = getMidpoint();
			var startTile:Object = Utils.getTile(start.x, start.y);
			start.x = startTile.j;
			start.y = startTile.i;

			var directionVec:FlxPoint = new FlxPoint(0, 0);

			if (dir == FlxObject.UP) {
				directionVec.y = -1;
			}
			if (dir == FlxObject.DOWN) {
				directionVec.y = 1;
			}
			if (dir == FlxObject.LEFT) {
				directionVec.x = -1;
			}
			if (dir == FlxObject.RIGHT) {
				directionVec.x = 1;
			}

			var finalPoint:FlxPoint = null;
			var found:Boolean = false;

			while (!found) {
				var tile:Number = _map.at(start.y, start.x);

				if (tile) {
					finalPoint = start;
					found = true;
					continue;
				}

				var next:FlxPoint = new FlxPoint(
					start.x + directionVec.x,
					start.y + directionVec.y
				);

				var nextTile:Number = _map.at(next.y, next.x);
				if (nextTile) {
					finalPoint = start;
					found = true;
					continue;
				}
				var adjTile1:Number;
				var adjTile2:Number;

				if (directionVec.x == 0) {
					adjTile1 = _map.at(next.y, next.x + 1);
					adjTile2 = _map.at(next.y, next.x - 1);
				}
				else if (directionVec.y == 0) {
					adjTile1 = _map.at(next.y + 1, next.x);
					adjTile2 = _map.at(next.y - 1, next.x);
				}

				if (!adjTile1 || !adjTile2) {
					finalPoint = next;
					found = true;
					continue;
				}

				start = next;
			}

			return finalPoint;
		}

		public function stopMoving() : void {
			if (copPath) {
				copPath = null;
				stopFollowingPath(true);
			}
			velocity.x = 0;
			velocity.y = 0;
		}

        public override function draw() : void {
            super.draw();

            if (Debug.drawCopPaths && copPath) {
                copPath.drawDebug();
            }
        }

		public override function play(animation:String, force:Boolean = false) : void {
			if (force || animation == _currentAnimation) {
				super.play(animation, force);
			}

			_currentAnimation = animation;
		}

		public function getCenter() : FlxPoint {
			return new FlxPoint(
				x + width / 2,
				y + height / 2
			);
		}

		public function canSeePlayer(start:FlxPoint, end:FlxPoint) : Boolean {
			return _collideMap.ray(start, end);
		}

		public function takeBomb() : void {
			_bombTimer = Config.ninjaBombTime;

			// Stop previous movement
			velocity.x = 0;
			velocity.y = 0;
		}
	}
}
