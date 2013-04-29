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
		private var _x:int;
		private var _y:int;
		private var _basementGroup:FlxGroup;
		private var _roofGroup:FlxGroup;
		private var _sprite:Class;
		
		public function set alpha(value:Number) : void { _alphaTarget = value; };
		
		public function Building(x:int, y:int, basementGroup:FlxGroup, roofGroup:FlxGroup, sprite:Class) {
			_x = x;
			_y = y;
			_basementGroup = basementGroup;
			_roofGroup = roofGroup;
			_sprite = sprite;
			
			show();
		}
		
		public override function update() : void {
			super.update();
			
			if (_roof.alpha > _alphaTarget) {
				_roof.alpha = Math.max(_alphaTarget, _roof.alpha - FlxG.elapsed / 0.5);
			} else if (_roof.alpha < _alphaTarget) {
				_roof.alpha = Math.min(_alphaTarget, _roof.alpha + FlxG.elapsed / 0.5);
			}
		}
		
		public function show() : void {
			var tempSprite:FlxSprite = new FlxSprite(0, 0, _sprite);
			
			// Manage the basement
			_basement = new FlxSprite();
			_basement.makeGraphic(Config.tileSize, Config.tileSize);
			_basement.x = _x * Config.tileSize;
			_basement.y = _y * Config.tileSize;
			
			var data:BitmapData = new BitmapData(Config.tileSize, Config.tileSize);
			data.copyPixels(tempSprite.pixels, new Rectangle(0, tempSprite.height - Config.tileSize, Config.tileSize, Config.tileSize), new Point());
			_basement.pixels = data;
		
			// Manage the roof
			_roof = new FlxSprite();
			_roof.makeGraphic(Config.tileSize, tempSprite.height - Config.tileSize);
			_roof.x = _x * Config.tileSize;
			_roof.y = _y * Config.tileSize - Config.tileSize * 2;
			
			data = new BitmapData(Config.tileSize, _roof.height);
			data.copyPixels(tempSprite.pixels, new Rectangle(0, 0, Config.tileSize, _roof.height), new Point());
			_roof.pixels = data;
			
			_basementGroup.add(_basement);
			_roofGroup.add(_roof);
		}
		
		public function hide() : void {
			_basementGroup.add(_basement);
			_roofGroup.add(_roof);
			
			_basement.destroy();
			_roof.destroy();
		}
	}

}