package
{
	/**
	 * ...
	 * @author Aurélien Defossez
	 */
	public class Config {
		// Map
		public static const tileSize:Number = 128;
		public static const buildingAlpha:Number = 0.5;

		// Player
		public static const playerWalkSpeed:Number = 2;
		public static const playerRunSpeed:Number = 4;

		// Cops
		public static const copPathFindingPeriod:Number = 0.5;

		// Drug and powers
		public static const baseDrugCounter:int = 5;
		public static const runTime:Number = 3;
		public static const runIntox:Number = 1;
		public static const ninjaBombTime:Number = 3;
		public static const ninjaBombIntox:Number = 2;
		public static const ninjaBombRadius:Number = 140;
		public static const ponycornAlphaSpeed:Number = 0.02;
		
		// Levels
		public static const levels:Array = [ {
			map:
				"0,0,0,0,0,0,0\n" +
				"0,1,1,0,1,0,0\n" +
				"0,1,1,1,1,1,0\n" +
				"0,0,0,0,0,1,0\n" +
				"0,1,0,1,1,1,0\n" +
				"0,1,1,1,0,1,0\n" +
				"0,1,0,1,1,1,0\n" +
				"0,1,0,0,0,0,0\n" +
				"0,1,1,1,1,1,0\n" +
				"0,0,0,1,0,1,0\n" +
				"0,1,0,1,1,1,0\n" +
				"0,1,1,1,0,0,0\n" +
				"0,1,0,0,0,0,0\n" +
				"0,1,1,1,1,1,0\n" +
				"0,0,0,0,0,0,0",
			player: { x: 13, y: 4 },
			target: { x: 1, y: 3 }
		}, {
			map:
				"0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
				"0,1,1,1,1,1,1,1,1,1,1,1,1,0\n" +
				"0,0,0,0,0,1,0,0,0,0,1,0,0,0\n" +
				"0,1,1,1,1,1,1,1,1,1,1,1,1,0\n" +
				"0,0,0,0,1,0,1,0,0,0,0,0,0,0\n" +
				"0,1,1,1,1,0,1,1,0,1,1,1,1,0\n" +
				"0,1,0,0,1,0,1,0,0,0,1,0,0,0\n" +
				"0,1,1,1,1,1,1,1,1,1,1,1,1,0\n" +
				"0,1,0,0,0,0,1,0,0,0,0,0,1,0\n" +
				"0,1,1,1,1,1,1,1,1,1,1,1,1,0\n" +
				"0,0,0,0,0,0,0,0,0,0,0,0,0,0",
			player: { x: 1, y: 3 },
			target: { x: 6, y: 11 }
		}];
	}

}
