package  
{
	/**
	 * ...
	 * @author Aurélien Defossez
	 */
	public class Utils {
		public static function getTile(x:Number, y:Number) : Object {
			// Please note that i (row index) is computed from y and j (column index) from x
			// It is normal because the map matrix is tranlated compared to the X/Y axis
			// Rows in the matrix are representing the Y axis and the columns the X axis
			return {
				i: Math.floor(y / Config.tileSize),
				j: Math.floor(x / Config.tileSize)
			}
		}
	}

}
