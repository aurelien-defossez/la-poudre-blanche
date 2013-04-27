package actors {

	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	public class Cop extends FlxSprite {

		public var direction:FlxPoint;

		private var _collideMap:FlxTilemap;
		private var _player:Player;

		private var copPath:FlxPath;
		private var lastPathUpdate:Number = 2;

		private var _bombTimer:Number;

		public function Cop(collideMap:FlxTilemap, player:Player) {
			_collideMap = collideMap;
			_player = player

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

			if (pathAngle > 45 && pathAngle <= 135) {
				play("walk-east");
			}
			else if (pathAngle > 135 && pathAngle <= 225) {
				play("walk-south");
			}
			else if (pathAngle > 225 && pathAngle <= 315) {
				play("walk-west");
			}
			else if (pathAngle > 315 || pathAngle <= 45) {
				play("walk-north");
			}

			super.update();
		}

        public override function draw() : void {
            super.draw();

            if (Debug.drawCopPaths && copPath) {
                copPath.drawDebug();
            }
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
