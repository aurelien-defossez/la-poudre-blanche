package  
{
	import actors.Player;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxText;
	import states.PlayState;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class Hud extends FlxGroup 
	{
		private var _player:Player;
		
		private var _drugText:FlxText;
		private var _runTimer:FlxText;
		
		public function Hud(player:Player) {
			_player = player;
			_drugText = new FlxText(5, 5, 200, "Drug : " + _player.drugCounter);
			fixItem(_drugText);
			
			_runTimer = new FlxText(5, 25, 200, "Run time : " + _player.runTimer);
			fixItem(_runTimer);
			
			add(_drugText);
			add(_runTimer);
		}
		
		public override function update() : void {
			_drugText.text = "Drug : " + _player.drugCounter;
			_runTimer.text = "Run time : " + _player.runTimer;
		}
		
		private function fixItem(o:FlxObject) : void {
			o.scrollFactor.x = o.scrollFactor.y = 0;
		}
	}

}