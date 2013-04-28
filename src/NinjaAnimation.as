package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class NinjaAnimation extends FlxSprite {
		
		public function NinjaAnimation(x:int, y:int) {
			super();
			loadGraphic(Assets.NINJA_ANIMATION, true, false, 128, 32);
			
			this.x = x - width / 2;
			this.y = y - height / 2;
			
			this.addAnimation("animation", [0, 1, 2, 3, 4], 25, false);
			play("animation");
		}
		
		public override function update() : void {
			if (finished) {
				alpha -= 0.02;
				if (alpha == 0) {
					kill();
				}
			}
		}
		
	}

}