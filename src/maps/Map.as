package maps 
{	
	/**
	 * ...
	 * @author Aurelien Defossez
	 */
	public class Map {
		private var _map:Object;
		private var _mapData:Array;
		private var _nRows:int;
		private var _nCols:int;
		private var _collisionMap:String;
		private var _roadMap:String;
		
		public function get nRows() : int { return _nRows; };
		public function get nCols() : int { return _nCols; };
		public function get collisionMap() : String { return _collisionMap; };
		public function get roadMap() : String { return _roadMap; };
		public function get player() : Object { return _map.player; };
		public function get targetBuilding() : Object { return _map.target; };
		public function get targetTile() : Object { return _map.targetTile; };
		
		public function Map();
		
		public function load(map:Object) : void {
			_map = map;
			_mapData = new Array();
			_roadMap = map.map;
			_map.targetTile = {
				x: _map.target.x,
				y: _map.target.y + 1
			};
			
			var rows:Array = _roadMap.split("\n");
			_nRows = rows.length;
			for (var i:int = 0; i < _nRows; i++) {
				_mapData[i] = rows[i].split(",");
				_nCols = _mapData[i].length;
				
				for (var j:int = 0; j < _nCols; j++) {
					_mapData[i][j] = (_mapData[i][j] == 0) ? 1 : 0;
				}
			}
			
			computeCollisionMap();
		}
		
		public function generate(nRows:int, nCols:int) : void {
			_mapData = new Array();
			_nRows = nRows;
			_nCols = nCols;
			
			var i:int;
			var j:int;
			var k:int;
			
			// Initialize map
			for (i = 0;  i < nRows; i++) {
				_mapData[i] = new Array();
				
				for (j = 0;  j < nCols; j++) {
					_mapData[i][j] = 1;
				}
			}
			
			// Create main strees
			for (i = 1;  i < nRows - 1; i += 2) {
				for (j = 1;  j < nCols - 1; j++) {
					_mapData[i][j] = 0;
				}
			}
			
			// Create intersections
			for (i = 2;  i < nRows - 2; i += 2) {
				var intersections:int = Math.round(2 + Math.random() * nCols / 6);
				
				for (k = 0; k < intersections; k++) {
					_mapData[i][3 + Math.floor(Math.random() * (nCols - 6))] = 0;
				}
			}
			
			// Create main street buildings
			/*for (i = 1;  i < nRows - 2; i += 2) {
				var buildings:int = Math.round(Math.random() * nCols / 6);
				
				for (k = 0; k < buildings; k++) {
					_mapData[i][1 + Math.floor(Math.random() * nCols - 2)] = 1;
				}
			}*/
			
			computeCollisionMap();
			computeRoadMap();
		}
		
		public function at(i:int, j:int) : int {
			return _mapData[i][j];
		}
		
		public function computeCollisionMap() : void {
			var rows:Array = new Array();
			
			for (var i:int = 0; i < _nRows; i++) {
				rows.push(_mapData[i].join(","));
			}
			
			_collisionMap = rows.join("\n");
		}
		
		public function computeRoadMap() : void {
			var buffer:String = "";
			
			for (var i:int = 0; i < nRows; i++) {
				for (var j:int = 0; j < nCols; j++) {
					buffer += ((_mapData[i][j] == 0) ? 1 : 0) + ",";
				}
				buffer += "\n";
			}
			
			_roadMap = buffer;
		}
	}

}