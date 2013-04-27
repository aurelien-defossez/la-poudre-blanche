package actors {

	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	public class Cop extends FlxSprite {

		private var _collideMap:FlxTilemap;
		private var _player:FlxSprite;

		private var copPath:FlxPath;
		private var lastPathUpdate:Number = 2;

		public function Cop(collideMap:FlxTilemap, player:FlxSprite) {
			_collideMap = collideMap;
			_player = player
			super(FlxG.width / 2 + 120, FlxG.height / 2 + 170);
			makeGraphic(20, 20);
		}

		public override function update() : void {
			// prepare cop start and end position
			var pathStart:FlxPoint = new FlxPoint(
				x + width / 2,
				y + height / 2
			);
			var pathEnd:FlxPoint = new FlxPoint(
				_player.x + _player.width / 2,
				_player.y + _player.height / 2
			);

			lastPathUpdate = lastPathUpdate + FlxG.elapsed;

			if (canSeePlayer(pathStart, pathEnd) && lastPathUpdate > 0.5) {
				lastPathUpdate = 0;
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

			super.update();
		}

        public override function draw() : void {
            super.draw();

            if (Debug.drawCopPaths && copPath) {
                copPath.drawDebug();
            }
        }

		public function canSeePlayer(start:FlxPoint, end:FlxPoint) : Boolean {
			return _collideMap.ray(start, end);
		}
	}
}
