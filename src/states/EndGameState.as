package states
{
	import input.KeyboardController;

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class EndGameState extends FlxState {

		private var _score:Score;

		private var _drugText:CustomText;
		private var _timeText:CustomText;
		private var _bonusText:CustomText;
		private var _scoreText:CustomText;

		private var _inputController:KeyboardController;

		public function EndGameState(score:Score) {
			_score = score;
		}

		public override function create() : void {
			_inputController = new KeyboardController();
			add(_inputController);

			var background:FlxSprite = new FlxSprite(0, 0, Assets.MENU_WINNING);
			add(background);

			_drugText = new CustomText(325, 245, 150, String(Math.floor(_score.totalDrugSold)), 24, 0xffffffff, "right");
			_timeText = new CustomText(325, 284, 150, String(Math.floor(_score.totalTime)), 24, 0xffffffff, "right");
			_bonusText = new CustomText(325, 319, 150, String(Math.floor(_score.totalTimeBonus)), 24, 0xffffffff, "right");
			_scoreText = new CustomText(260, 387, 150, String(Math.floor(_score.score)), 30, 0xffffffff, "right");

			add(_drugText);
			add(_timeText);
			add(_bonusText);
			add(_scoreText);
		}

		public override function update() : void {
			super.update();

			if (_inputController.userInput()) {
				FlxG.switchState(new MenuState());
			}
		}
	}
}
