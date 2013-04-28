package actors 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class Hallucination extends FlxSprite {
		
		private var _lifeSpan:Number;
		
		public function Hallucination() {
			super();
			_lifeSpan = Config.ninjaBombTime;
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