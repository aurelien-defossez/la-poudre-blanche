package states
{
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;

    /**
     * ...
     * @author Alex Frêne
     */
    public class EndGameState extends FlxState {

        public function EndGameState() {
        }

        public override function create() : void {
            FlxG.mouse.show();

            var background:FlxSprite = new FlxSprite(0, 0, Assets.MENU_TITLE);
            add(background);
        }

        public override function update() : void {
            var clicked:Boolean = FlxG.mouse.justPressed();

            if (FlxG.mouse.justPressed()) {
                FlxG.switchState(new PlayState(0));
            }
        }
    }
}
