package maps 
{	
	/**
	 * ...
	 * @author Aurelien Defossez
	 */
	public class Map {
		
		private var _map:Array;
		private var _nRows:int;
		private var _nCols:int;
		
		public function get nRows() : int { return _nRows; };
		public function get nCols() : int { return _nCols; };
		
		public function Map(nRows:int, nCols:int) {
			_map = new Array();
			_nRows = nRows;
			_nCols = nCols;
			
			var i:int;
			var j:int;
			var k:int;
			
			// Initialize map
			for (i = 0;  i < nRows; i++) {
				_map[i] = new Array();
				
				for (j = 0;  j < nCols; j++) {
					_map[i][j] = 1;
				}
			}
			
			// Create main strees
			for (i = 1;  i < nRows - 1; i += 2) {
				for (j = 1;  j < nCols - 1; j++) {
					_map[i][j] = 0;
				}
			}
			
			// Create intersections
			for (i = 2;  i < nRows - 2; i += 2) {
				var intersections:int = Math.round(2 + Math.random() * nCols / 6);
				
				for (k = 0; k < intersections; k++) {
					_map[i][3 + Math.floor(Math.random() * (nCols - 6))] = 0;
				}
			}
			
			// Create main street buildings
			/*for (i = 1;  i < nRows - 2; i += 2) {
				var buildings:int = Math.round(Math.random() * nCols / 6);
				
				for (k = 0; k < buildings; k++) {
					_map[i][1 + Math.floor(Math.random() * nCols - 2)] = 1;
				}
			}*/
		}
		
		public function at(i:int, j:int) : int {
			return _map[i][j];
		}
		
		public function getCollisionMap() : String {
			var rows:Array = new Array();
			
			for (var i:int = 0; i < nRows; i++ ) {
				rows.push(_map[i].join(","));
			}
			
			return rows.join("\n");
		}
		
		public function getRoadMap() : String {
			var buffer:String = "";
			
			for (var i:int = 0; i < nRows; i++ ) {
				for (var j:int = 0; j < nCols; j++ ) {
					buffer += ((_map[i][j] == 0) ? 1 : 0) + ",";
				}
				buffer += "\n";
			}
			
			return buffer;
		}
	}

}