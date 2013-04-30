package
{
	import org.flixel.FlxGame;

	import states.SplashScreenState;

	/**
	 * ...
	 * @author Alex Frêne
	 */
	[Frame(factoryClass="Preloader")] //Tells Flixel to use the default preloader
	public class Main extends FlxGame {


		public function Main() : void {
			super(800, 600, SplashScreenState, 1);
		}
	}

}
