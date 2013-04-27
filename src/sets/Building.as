package sets 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class Building extends FlxGroup {
		
		private var _basement:FlxSprite;
		private var _roof:FlxSprite;
		
		public function set alpha(value:Number) : void { _roof.alpha = value; };
		
		public function Building(x:int, y:int, basementGroup:FlxGroup, roofGroup:FlxGroup, sprite:Class) {
			const tileSize:int = 128;
			
			var tempSprite:FlxSprite = new FlxSprite(0, 0, sprite);
			
			// Manage the basement
			_basement = new FlxSprite();
			_basement.makeGraphic(tileSize, tileSize);
			_basement.x = x * tileSize;
			_basement.y = y * tileSize;
			
			var data:BitmapData = new BitmapData(tileSize, tileSize);
			data.copyPixels(tempSprite.pixels, new Rectangle(0, tempSprite.height - tileSize, tileSize, tileSize), new Point());
			_basement.pixels = data;
		
			// Manage the roof
			_roof = new FlxSprite();
			_roof.makeGraphic(tileSize, tempSprite.height - tileSize);
			_roof.x = x * tileSize;
			_roof.y = y * tileSize - tileSize * 2;
			_roof.alpha = 0.5;
			
			data = new BitmapData(tileSize, _roof.height);
			data.copyPixels(tempSprite.pixels, new Rectangle(0, 0, tileSize, _roof.height), new Point());
			_roof.pixels = data;
			
			// The ground
			var ground:FlxSprite = new FlxSprite(_roof.x, _roof.y, Assets.GROUND);
			
			basementGroup.add(ground);
			basementGroup.add(_basement);
			roofGroup.add(_roof);
			
			// Add the roof to the group to test collision with player (line of sight)
			add(_roof);
		}
		
	}

}