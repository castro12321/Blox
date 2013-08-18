package com.castro.utils 
{
	import flash.display.Sprite;
	
	public class Live
	{
		public var active : Boolean;
		public var sprite : Sprite;
		
		public function Live(active : Boolean, sprite : Sprite)
		{
			this.active = active;
			this.sprite = sprite;
		}
	}

}