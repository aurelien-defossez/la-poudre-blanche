package actors
{
    import org.flixel.FlxG;
    import org.flixel.FlxPath;
    import org.flixel.FlxPoint;
    import org.flixel.FlxSprite;
    import org.flixel.FlxTilemap;

    public class Cop extends FlxSprite
    {
        private var collideMap:FlxTilemap;
        private var player:FlxSprite;

        private var copPath:FlxPath;

        public function Cop(CollideMap:FlxTilemap, Player:FlxSprite)
        {
            collideMap = CollideMap;
            player = Player
            super(FlxG.width / 2 - 30, FlxG.height / 2 - 10);
            makeGraphic(20, 20);
        }

        public override function update() : void
        {
            // if path already exists, destroy it
            if (copPath) {
                stopFollowingPath(true);
            }

            // prepare player start and end position
            var pathStart:FlxPoint = new FlxPoint(x, y);
            var pathEnd:FlxPoint = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);

            // create & follow path
            copPath = collideMap.findPath(pathStart, pathEnd);
            if (copPath) followPath(copPath);

            super.update();
        }
    }
}
