package input 
{
	import org.flixel.FlxG;

	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class KeyboardController extends Controller {
		public function KeyboardController() {
			super();
		}
		
		public override function update() : void {
			_left = FlxG.keys.pressed("LEFT") || FlxG.keys.pressed("A") || FlxG.keys.pressed("Q");
			_right = FlxG.keys.pressed("RIGHT") || FlxG.keys.pressed("D");
			_up = FlxG.keys.pressed("UP") || FlxG.keys.pressed("W") || FlxG.keys.pressed("Z");
			_down = FlxG.keys.pressed("DOWN") || FlxG.keys.pressed("S");
			_actionA = FlxG.keys.pressed("A");
			_actionB = FlxG.keys.pressed("B");
		}
	}

}
