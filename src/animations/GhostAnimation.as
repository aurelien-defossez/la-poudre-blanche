package animations 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class GhostAnimation extends FlxSprite 
	{
		
		public function GhostAnimation(x, y) 
		{
			super(x, y);
			
			loadGraphic(Assets.GHOST_ANIMATION, true, false);
			
			this.addAnimation("animation", [0, 1, 2, 1], 25);
			play("animation");
		}
		
		
	}

}