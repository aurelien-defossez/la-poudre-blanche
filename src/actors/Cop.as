package actors {

	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	public class Cop extends FlxSprite {

		public var direction:FlxPoint;

		private var _collideMap:FlxTilemap;
		private var _player:Player;
		private var _currentAnimation:String;

		private var copPath:FlxPath;
		private var lastPathUpdate:Number = 2;

		private var _bombTimer:Number;
		private var _currentDirection:uint;

		public function get currentDirection() : uint { return _currentDirection; };

		public function Cop(collideMap:FlxTilemap, player:Player) {
			_player = player
			_collideMap = collideMap;

			super(1.5 * Config.tileSize, 1.5 * Config.tileSize);
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

				if (copPath) {
					copPath = null;
					stopFollowingPath(true);
				}
				velocity.x = 0;
				velocity.y = 0;
			} else {
				// prepare cop start and end position
				var pathStart:FlxPoint = getCenter();
				var pathEnd:FlxPoint = _player.getCenter();

				lastPathUpdate = lastPathUpdate + FlxG.elapsed;

				if (lastPathUpdate > Config.copPathFindingPeriod && canSeePlayer(pathStart, pathEnd)) {
					lastPathUpdate -= Config.copPathFindingPeriod;
					copPath = _collideMap.findPath(pathStart, pathEnd);
					if (copPath) {
						followPath(copPath);
					}
				}

				// Stop cop when end of path is reached
				if (pathSpeed == 0) {
					if (copPath) {
						copPath = null;
						stopFollowingPath(true);
					}
					velocity.x = 0;
					velocity.y = 0;
				}
			}
			
			if (velocity.x > 0 || velocity.y > 0) {
				if (pathAngle > 45 && pathAngle <= 135) {
					play("walk-east");
				_currentDirection = FlxObject.RIGHT;
				}
				else if (pathAngle > 135 || pathAngle <= -135) {
					play("walk-south");
				_currentDirection = FlxObject.DOWN;
				}
				else if (pathAngle < -35 && pathAngle > -135) {
					play("walk-west");
				_currentDirection = FlxObject.LEFT;
				}
				else if (pathAngle > -45 || pathAngle <= 45) {
					play("walk-north");
				_currentDirection = FlxObject.UP;
				}
			}
			else {
				if (pathAngle > 45 && pathAngle <= 135) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["east"] + Assets.STANDING_FRAME;
				}
				else if (pathAngle > 135 || pathAngle <= -135) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["south"] + Assets.STANDING_FRAME;
				}
				else if (pathAngle < -45 && pathAngle > -135) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["west"] + Assets.STANDING_FRAME;
				}
				else if (pathAngle > -45 || pathAngle <= 45) {
					frame = Assets.TOTAL_FRAMES * Assets.DIRECTIONS["north"] + Assets.STANDING_FRAME;
				}
			}

			super.update();
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
