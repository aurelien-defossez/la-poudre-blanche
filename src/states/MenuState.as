package states 
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class MenuState extends FlxState 
	{
		
		public function MenuState() 
		{
			
		}
		
		public override function create() : void
		{
			add(new FlxText(25, 25, 100, "La Poudre Blanche"));
		}
		
		public override function update() : void
		{
		}
	}

}