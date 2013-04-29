package
{
	import actors.Player;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import states.PlayState;

	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class Hud extends FlxGroup
	{
		private const drugXlimit:int = 220;

		private var _player:Player;

		private var _drugText:FlxText;
		private var _runTimer:FlxText;

		private var _background:FlxSprite;
		private var _drugProgress:FlxSprite;
		private var _nose:FlxSprite;
		private var _noseGoalX:int;
		private var _drugCounter:CustomText;
		private var _scoreCounter:CustomText;

		private var _score:Number = 0;

		public function get score() : Number { return _score; };
		public function set score(value:Number) : void { _score = value; };

		public function Hud(player:Player) {
			_player = player;

			_background = new FlxSprite(0, 0, Assets.HUD);
			fixItem(_background);

			_nose = new FlxSprite(0, 0, Assets.HUD_NOSE);
			_nose.x = (drugXlimit - _player.drugCounter * 150 / _player.map.drug) - _nose.width / 2;
			fixItem(_nose);

			_drugProgress = new FlxSprite();
			_drugProgress.makeGraphic(_player.drugCounter * 150 / _player.map.drug, 5);
			_drugProgress.x = _nose.x + _nose.width / 2;
			_drugProgress.y = 30;
			fixItem(_drugProgress);

			_drugCounter = new CustomText(70, 10, 250, _player.map.drug.toString(), 24, 0xffffffff, "right");
			fixItem(_drugCounter);

			_scoreCounter = new CustomText(190, 38, 250, String(_score), 24, 0xffffffff, "right");
			fixItem(_scoreCounter);

			add(_background);
			add(_drugProgress);
			add(_nose);
			add(_drugCounter);
			add(_scoreCounter);
		}

		public override function update() : void {
			super.update();
			// Drug progress
			var progressWidth:int = _player.drugCounter * 150 / _player.map.drug;

			_noseGoalX = (drugXlimit - progressWidth) - _nose.width / 2;
			if (_nose.x < _noseGoalX) {
				_nose.velocity.x = 50;
				_drugProgress.x = _nose.x + _nose.width / 2;
				var barWidth:int = drugXlimit - _nose.x - _nose.width / 2;
				if (barWidth == 0) {
					_drugProgress.visible = false;
				} else {
					_drugProgress.makeGraphic(barWidth, 5);
				}
			} else {
				_nose.velocity.x = 0;
			}

			_drugCounter.text = _player.drugCounter.toString();
			_scoreCounter.text = String(Math.floor(_score));
		}

		private function fixItem(o:FlxObject) : void {
			o.scrollFactor.x = o.scrollFactor.y = 0;
		}
	}

}
