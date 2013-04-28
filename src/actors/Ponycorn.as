package actors 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class Ponycorn extends Hallucination 
	{
		
		public function Ponycorn(x:int, y:int) 
		{
			super();
			super.loadGraphic(Assets.PONYCORN, true, false, 96, 96);
			addAnimation("idle", [0, 1, 2, 3, 4, 5], 30);
			play("idle");
			
			this.x = x - width / 2;
			this.y = y - height / 2;
		}

	}

}