package states
{
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;

    /**
     * ...
     * @author Alex Frêne
     */
    public class SplashScreenState extends FlxState {

        private var _timer:Number;

        public function SplashScreenState() {
        }

        public override function create() : void {
            _timer = Config.SPLASH_SCREEN_DURATION;

            var background:FlxSprite = new FlxSprite(0, 0, Assets.MENU_TITLE);
            add(background);
        }

        public override function update() : void {
            super.update();

            _timer -= FlxG.elapsed;

            if (_timer <= 0) {
                FlxG.switchState(new MenuState());
            }
        }
    }
}
