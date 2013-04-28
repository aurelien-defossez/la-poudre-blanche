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
		public static const baseDrugCount:int = 2500;
		public static const runPrice:int = 2;
		public static const ninjaPrice:int = 10;

		// Cops
		public static const copPathFindingPeriod:Number = 0.5;

		// Drug and powers
		public static const runTime:Number = 3;
		public static const runIntox:Number = 1;
		public static const ninjaBombTime:Number = 3;
		public static const ninjaBombIntox:Number = 2;
		public static const ninjaBombRadius:Number = 140;
		public static const ponycornAlphaSpeed:Number = 0.02;
		
		public static const levels:Array = [{
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
			player: { x: 3, y: 1 },
			target: { x: 6, y: 11 }
		}];
	}

}
