package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class TutorialState extends FlxState {

		private var _cursor:FlxSprite;
		private var _playRectangle:FlxRect;
		private var _creditsRectangle:FlxRect;
		private var _exitRectangle:FlxRect;

		public function TutorialState() {
		}

		public override function create() : void {
			FlxG.mouse.show();

			var background:FlxSprite = new FlxSprite(0, 0, Assets.TUTORIAL);

			add(background);
		}

		public override function update() : void {
			if (FlxG.mouse.justPressed()) {
				FlxG.switchState(new PlayState(0, new Score()));
			}
		}
	}

}
