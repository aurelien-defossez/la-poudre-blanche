package actors {

	import input.Controller;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import states.PlayState;

	public class Player extends FlxSprite {
		
		private var _collideMap:FlxTilemap;
		private var _inputController:Controller;
		private var _tileIndex:Object;
		private var _state:PlayState;
		
		private var _drugCounter:int
		
		private var _runTimer:Number;
		/** Each drug consumption increase this counter : use it to make crazy things */
		private var _intoxication:int;
		
		public function get drugCounter() : int { return _drugCounter; };
		public function set drugCounter(value:int) : void { _drugCounter = value; };
		
		public function get runTimer() : Number { return _runTimer; };
		
		public function Player(collideMap:FlxTilemap, inputController:Controller, state:PlayState, i:Number, j:Number) {
			super(j * Config.tileSize, i * Config.tileSize);
			
			_state = state;
			_drugCounter = Config.baseDrugCounter;
			_intoxication = 0;
			_runTimer = 0;
			_collideMap = collideMap;
			_inputController = inputController;
			
			makeGraphic(20, 20);
		}

		public override function update() : void {
			// Update position
			var speed:int = 0;
			if (_runTimer > 0) {
				_runTimer -= FlxG.elapsed;
				speed = Config.playerRunSpeed;
			} else {
				_runTimer = 0;
				speed = Config.playerWalkSpeed;
			}
			
			if (_inputController.up) {
				y -= speed;
			} else if (_inputController.down) {
				y += speed;
			}

			if (_inputController.left) {
				x -= speed;
			} else if (_inputController.right) {
				x += speed;
			}

			if (_drugCounter > 0) {
				// Speed shoot
				if (_inputController.actionA) {
					_drugCounter--;
					_runTimer += Config.runTime;
				}
				
				// Ninja powder
				if (_inputController.actionB)
				{
					_drugCounter--;
					_state.dropBomb(x, y);
				}
			}
			
			// Check for collision with buildings
			FlxG.collide(_collideMap, this);
			
			super.update();
		}
		
		public function changedTile() : Boolean {
			// Do not call this method in update, because it returns a boolean
			// telling if the player has changed tile since the last update,
			// which is used by the game to know which buildings to fade
				
			if (_tileIndex == null) {
				var center:FlxPoint = getCenter();
				_tileIndex = Utils.getTile(center.x, center.y);
				return true;
			} else {
				var previousTile:Object = {
					x: _tileIndex.x,
					y: _tileIndex.y
				};
				
				_tileIndex = Utils.getTile(x, y);
				
				return (_tileIndex.x == previousTile.x && _tileIndex.y == previousTile.y);
			}
		}
		
		public function getCenter() : FlxPoint {
			return new FlxPoint(
				x + width / 2,
				y + height / 2
			);
		}
		
		public function getTileIndex() : Object {
			return _tileIndex;
		}
	}
}
