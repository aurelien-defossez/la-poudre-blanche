package actors 
{
	import actors.Hallucination;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class GhostAnimation extends Hallucination 
	{
		
		public function GhostAnimation(x:int, y:int) 
		{
			super();
			loadGraphic(Assets.GHOST_ANIMATION, true, false);
			this.addAnimation("animation", [0, 1, 2, 1], 25);
			play("animation");
			
			this.x = x;
			this.y = y;
			this.immovable = true;
		}
		
		
	}

}