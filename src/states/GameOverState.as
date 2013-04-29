package states
{
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;

    /**
     * ...
     * @author Alex Frêne
     */
    public class GameOverState extends FlxState {

        private var _timeLeft:Number;

        public function GameOverState() {
        }

        public override function create() : void {
            _timeLeft = Config.THIS_IS_THE_LAW_DURATION;

            var background:FlxSprite = new FlxSprite(0, 0, Assets.MENU_GAMEOVER);
            add(background);

            FlxG.loadSound(Assets.THIS_IS_THE_LAW, Config.THIS_IS_THE_LAW_VOLUME, false, true, true);
        }

        public override function update() : void {
            _timeLeft -= FlxG.elapsed;

            if (_timeLeft <= 0) {
                FlxG.switchState(new MenuState());
            }
        }
    }
}
