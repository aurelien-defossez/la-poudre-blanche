package actors {

	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	public class Cop extends FlxSprite {

		private var collideMap:FlxTilemap;
		private var player:FlxSprite;

		private var copPath:FlxPath;
		private var lastPathUpdate:Number = 2;

		public function Cop(collideMap:FlxTilemap, player:FlxSprite) {
			this.collideMap = collideMap;
			this.player = player
			super(FlxG.width / 2 + 120, FlxG.height / 2 + 170);
			makeGraphic(20, 20);
		}

		public override function update() : void {
			lastPathUpdate = lastPathUpdate + FlxG.elapsed;
			if (canSeePlayer() && lastPathUpdate > 2) {
				lastPathUpdate = 0;
				// prepare player start and end position
				var pathStart:FlxPoint = new FlxPoint(x, y);
				var pathEnd:FlxPoint = new FlxPoint(
					player.x + player.width / 2,
					player.y + player.height / 2
				);

				// create & follow path
				copPath = collideMap.findPath(pathStart, pathEnd);
				if (copPath) {
					followPath(copPath);
				}
			}

			// Stop player when end of path reached
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

		public function canSeePlayer() : Boolean {
			return true;
		}
	}
}
