package com.castro.utils 
{
	import com.castro.Engine;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class Utils 
	{
		private var engine : Engine;
		
		public function Utils() 
		{
			engine = Engine.engine;
		}
		
		private var currentTime : Number = 0;
		private var dt : Number = 0;
		private var prevTime : Number = 0;
		public function getDT() : Number
		{
			currentTime = getTimer();
			dt = currentTime - prevTime;
			prevTime = currentTime; //update for next go around
			return dt;
		}
		
		public function setTexture(sprite : Sprite, texture : String, scaleX : Number = 1, scaleY : Number = 1) : void
		{
			if (sprite.numChildren > 0)
				sprite.removeChildAt(0);
			texture = "media\\" + texture;
			var loader : Loader = new Loader();
			sprite.addChildAt(loader, 0);
			loader.load(new URLRequest(texture));
			sprite.scaleX = scaleX;
			sprite.scaleY = scaleY;
		}
		
		public function changeTexture(sprite : Sprite, texture : String, scaleX : Number = 1, scaleY : Number = 1) : void
		{
			engine.removeChild(sprite);
			setTexture(sprite, texture, scaleX, scaleY);
		}
		
		// TODO: zrobic, zeby dzialalo :P
		// sprawdz pozycje i wielkosc sprite'a
		public function setBackground(path : String) : void
		{
			trace("setbg1");
			if (engine.background.numChildren > 0)
				engine.background.removeChildAt(0);
			var loader : Loader = new Loader();
			engine.background.addChildAt(loader, 0);
			loader.load(new URLRequest("media\\" + path));
			trace("setbg2");
		}
		
		public function removeFromArray(arr : Array, object : Object) : void
		{
			for (var i : int = 0; i < arr.length; ++i)
				if (arr[i] == object)
				{
					arr[i] = arr[arr.length -1];
					arr.pop();
				}
		}
	}
}