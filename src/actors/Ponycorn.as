package actors 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class Ponycorn extends FlxSprite 
	{
		private var _lifeSpan:Number;
		
		public function Ponycorn(x:int, y:int) 
		{
			super();
			
			_lifeSpan = Config.ninjaBombTime;
			
			super.loadGraphic(Assets.PONYCORN, true, false, 96, 96);
			addAnimation("idle", [0, 1, 2, 3, 4, 5], 30);
			play("idle");
			
			this.x = x - width / 2;
			this.y = y - height / 2;
		}
	
		public override function update() : void {
			_lifeSpan -= FlxG.elapsed;
			if (_lifeSpan < 0)
			{
				alpha -= Config.ponycornAlphaSpeed;
				if (alpha == 0) {
					kill();
				}
			}
		}
	}

}