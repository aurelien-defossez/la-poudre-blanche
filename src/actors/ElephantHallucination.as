package actors 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class ElephantHallucination extends Hallucination 
	{
		
		public function ElephantHallucination(x:int, y:int) 
		{
			super();
			loadGraphic(Assets.ELEPHANT);
			this.x = x;
			this.y = y;
			this.immovable = true;
		}
		
	}

}