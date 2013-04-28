package  
{
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Alex Frêne
	 */
	public class CustomText extends FlxText 
	{
		
		public function CustomText(x:int, y:int, width:int, text:String, fontSize:int, color:uint = 0xffffffff, textAlign:String = "center")
		{
			super(x, y, width, text);
			
			setFormat(Assets.FONT, fontSize, color, textAlign);
		}
		
	}

}