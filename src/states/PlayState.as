package states 
{
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class PlayState extends FlxState 
	{
		private var _tilemap:FlxTilemap;
		
		public function PlayState() 
		{
			
		}
		
		public override function create() : void
		{
			_tilemap = new FlxTilemap();
			//_tilemap.loadMap(map, 
		}
		
		public override function update() : void
		{
		}
	}

}