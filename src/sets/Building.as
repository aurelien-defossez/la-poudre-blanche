package sets 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
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
		private var _alphaTarget:Number;
		
		public function set alpha(value:Number) : void { _alphaTarget = value; };
		
		public function Building(x:int, y:int, basementGroup:FlxGroup, roofGroup:FlxGroup, sprite:Class) {
			var tempSprite:FlxSprite = new FlxSprite(0, 0, sprite);
			
			// Manage the basement
			_basement = new FlxSprite();
			_basement.makeGraphic(Config.tileSize, Config.tileSize);
			_basement.x = x * Config.tileSize;
			_basement.y = y * Config.tileSize;
			
			var data:BitmapData = new BitmapData(Config.tileSize, Config.tileSize);
			data.copyPixels(tempSprite.pixels, new Rectangle(0, tempSprite.height - Config.tileSize, Config.tileSize, Config.tileSize), new Point());
			_basement.pixels = data;
		
			// Manage the roof
			_roof = new FlxSprite();
			_roof.makeGraphic(Config.tileSize, tempSprite.height - Config.tileSize);
			_roof.x = x * Config.tileSize;
			_roof.y = y * Config.tileSize - Config.tileSize * 2;
			
			data = new BitmapData(Config.tileSize, _roof.height);
			data.copyPixels(tempSprite.pixels, new Rectangle(0, 0, Config.tileSize, _roof.height), new Point());
			_roof.pixels = data;
			
			basementGroup.add(_basement);
			roofGroup.add(_roof);
		}
		
		public override function update() : void {
			super.update();
			
			if (_roof.alpha > _alphaTarget) {
				_roof.alpha = Math.max(_alphaTarget, _roof.alpha - FlxG.elapsed / 0.5);
			} else if (_roof.alpha < _alphaTarget) {
				_roof.alpha = Math.min(_alphaTarget, _roof.alpha + FlxG.elapsed / 0.5);
			}
		}
	}

}