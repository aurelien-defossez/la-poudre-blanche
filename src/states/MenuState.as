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
	public class MenuState extends FlxState {

		private var _cursor:FlxSprite;
		private var _playRectangle:FlxRect;

		public function MenuState() {
		}

		public override function create() : void {
			FlxG.mouse.show();

			_playRectangle = new FlxRect(0, 180, FlxG.width, 110);

			var background:FlxSprite = new FlxSprite();
			background.makeGraphic(FlxG.width, FlxG.height, 0xff020322);

			var foreground:FlxSprite = new FlxSprite(0, 0, Assets.START_MENU);

			_cursor = new FlxSprite(0, 0, Assets.MENU_CURSOR);
			_cursor.y = _playRectangle.y;

			add(background);
			add(_cursor);
			add(foreground);
		}

		public override function update() : void {
			var clicked:Boolean = FlxG.mouse.justPressed();

			if (mouseInRect(_playRectangle)) {
				_cursor.y = _playRectangle.y;
				if (clicked) {
					FlxG.switchState(new TutorialState());
				}
			}
		}

		private  function mouseInRect(rect:FlxRect) : Boolean {
			return rect.x <= FlxG.mouse.x && (rect.x + rect.width) >= FlxG.mouse.x
				&& rect.y <= FlxG.mouse.y && (rect.y + rect.height) >= FlxG.mouse.y;
		}
	}

}
