package actors {

	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	public class Cop extends FlxSprite {

		public var direction:FlxPoint;
		public var patrolOrigin:FlxPoint;

		private var _collideMap:FlxTilemap;
		private var _player:Player;
		private var _currentAnimation:String;

		private var copPath:FlxPath;
		private var lastPathUpdate:Number = 2;
		private var chasingPlayer:Boolean = false;
		private var notChasingPlayerSince:Number = 0;

		private var _bombTimer:Number;
		private var _currentDirection:uint;

		public function get currentDirection() : uint { return _currentDirection; };

		public function Cop(collideMap:FlxTilemap, player:Player, x:Number, y:Number) {
			_player = player;
			_collideMap = collideMap;

			super(x, y);
			patrolOrigin = new FlxPoint(x, y);
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

				// Stop cop when end of path is reached
				if (pathSpeed == 0) {
					stopMoving();
				}
			}

			if (velocity.x != 0 || velocity.y != 0) {
				if (pathAngle > 45 && pathAngle <= 135) {
					play("run-east");
					_currentDirection = FlxObject.RIGHT;
				}
				else if (pathAngle <= -45 && pathAngle > -135) {
					play("run-west");
					_currentDirection = FlxObject.LEFT;
				}
				else if (pathAngle > -45 && pathAngle <= 45) {
					play("run-north");
					_currentDirection = FlxObject.UP;
				}
				else if (pathAngle > 135 || pathAngle <= -135) {
					play("run-south");
					_currentDirection = FlxObject.DOWN;
				}
			}
			else {
				if (pathAngle > 45 && pathAngle <= 135) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["east"] + Assets.STANDING_FRAME;
				}
				else if (pathAngle <= -45 && pathAngle > -135) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["west"] + Assets.STANDING_FRAME;
				}
				else if (pathAngle > -45 && pathAngle <= 45) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["north"] + Assets.STANDING_FRAME;
				}
				else if (pathAngle > 135 || pathAngle <= -135) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["south"] + Assets.STANDING_FRAME;
				}
			}

			super.update();
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
