package input 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	/**
	 * Global input controller
	 * 
	 * @author Alex Frêne
	 */
	public class Controller extends FlxBasic {
		// Key definitions
		protected var _leftKey:String;
		protected var _rightKey:String;
		protected var _upKey:String;
		protected var _downKey:String;
		protected var _actionAKey:String;
		protected var _actionBKey:String;
		
		// Input values
		protected var _left:Boolean;
		protected var _right:Boolean;
		protected var _up:Boolean;
		protected var _down:Boolean;
		protected var _actionA:Boolean;
		protected var _actionB:Boolean;
		
		// Getters
		public function get left() : Boolean { return _left; }
		public function get right() : Boolean { return _right; }
		public function get up() : Boolean { return _up; }
		public function get down() : Boolean { return _down; }
		public function get actionA() : Boolean { return _actionA; }
		public function get actionB() : Boolean { return _actionB; }
		
		public function Controller() {
			_left = false;
			_right = false;
			_up = false;
			_down = false;
			_actionA = false;
			_actionB = false;
		}
		
		public override function update() : void {
			_left = FlxG.keys.pressed(_leftKey);
			_right = FlxG.keys.pressed(_rightKey);
			_up = FlxG.keys.pressed(_upKey);
			_down = FlxG.keys.pressed(_downKey);
			_actionA = FlxG.keys.pressed(_actionAKey);
			_actionB = FlxG.keys.pressed(_actionBKey);
		}
	}

}