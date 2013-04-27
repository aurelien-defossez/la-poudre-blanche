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
	}
}
