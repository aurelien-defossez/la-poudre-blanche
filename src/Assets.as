package
{
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class Assets {
		// -------------------------------------------------------------------------------------------------
		// Sprites
		// -------------------------------------------------------------------------------------------------
		[Embed(source = "/gfx/debug_tileset.png")] public static const DEBUG_TILESET:Class;
		[Embed(source = "/gfx/roads.png")] public static const ROAD_TILESET:Class;
		[Embed(source = "/gfx/ponycorn.png")] public static const PONYCORN:Class; 
		[Embed(source = "/gfx/bombeensemble.png")] public static const NINJA_ANIMATION:Class;
		[Embed(source = "/gfx/fantomes.png")] public static const GHOST_ANIMATION:Class;
		[Embed(source = "/gfx/elephantgd.png")] public static const ELEPHANT:Class;
		[Embed(source = "/gfx/hudfond.png")] public static const HUD:Class; 
		[Embed(source = "/gfx/hudnez.png")] public static const HUD_NOSE:Class; 
		
		// Buildings
		[Embed(source = "/gfx/buildings/sol.png")] public static const GROUND:Class;
		[Embed(source = "/gfx/buildings/immeuble_gd.png")] public static const BUILDING_1:Class;
		[Embed(source = "/gfx/buildings/immeuble_pt.png")] public static const BUILDING_2:Class;
		[Embed(source = "/gfx/buildings/maison.png")] public static const HOUSE_1:Class;
		[Embed(source = "/gfx/buildings/maison_gauche.png")] public static const HOUSE_LEFT:Class;
		[Embed(source = "/gfx/buildings/maison_centrale.png")] public static const HOUSE_MIDDLE:Class;
		[Embed(source = "/gfx/buildings/maison_droite.png")] public static const HOUSE_RIGHT:Class;
		[Embed(source = "/gfx/buildings/parc.png")] public static const GARDEN:Class;
		[Embed(source = "/gfx/buildings/tour_vert.png")] public static const SKYLINE_GREEN:Class;
		[Embed(source = "/gfx/buildings/tour_violet.png")] public static const SKYLINE_PURPLE:Class;

		// Actors
		[Embed(source = "/gfx/heenok.png")] public static const HEENOK_TILESET:Class;
		[Embed(source = "/gfx/gerard.png")] public static const GERARD_TILESET:Class;

		// Font
		[Embed(source = "/erasdust.ttf", fontFamily = "EraserDust", embedAsCFF = "false")] public static const FONT_DEF:Class;
		public static var FONT:String = "EraserDust";
		
		
		// Actors tilesheets data
		public static const DIRECTIONS:Object = {
			south: 0,
			north: 1,
			east: 2,
			west: 3
		};

		public static const ANIMATIONS:Object = {
			walk: [0, 1, 2, 3],
			run: [4, 1, 3, 5]
		}

		public static const TOTAL_FRAMES:Number = 7;
		public static const STANDING_FRAME:Number = 6;

	}
}
