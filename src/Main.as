package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;
	import states.MenuState;
	import states.PlayState;

	/**
	 * ...
	 * @author Alex Frêne
	 */
	[Frame(factoryClass="Preloader")] //Tells Flixel to use the default preloader
	public class Main extends FlxGame {


		public function Main() : void {
			super(800, 600, MenuState, 1);
		}
	}

}
