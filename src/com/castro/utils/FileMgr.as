package com.castro.utils 
{
	import com.castro.Session;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	public class FileMgr 
	{
		
		public function FileMgr() 
		{
			SharedObject.defaultObjectEncoding = ObjectEncoding.AMF3;
		}
		
		public function saveGame() : void
		{
			var s : Session = Session.session;
			var f : Array = new Array();
			
			var shared : SharedObject = SharedObject.getLocal("save");
			shared.data.level  = s.level;
			shared.data.points = s.points;
			shared.data.lives  = s.lives;
			shared.close();
		}
		
		public function loadGame() : void
		{
			var s : Session = Session.session;
			var shared : SharedObject = SharedObject.getLocal("save");
			if (shared.data.level == undefined || shared.data.points == undefined || shared.data.lives == undefined)
			{
				saveGame();
				shared.close();
				loadGame();
				return;
			}
			s.level  = shared.data.level;
			s.points = shared.data.points;
			s.lives  = shared.data.lives;
			//if (s.level	 == 0) s.level  = 1;
			if (s.lives	 == 0) s.lives  = 3;
			shared.close();
		}
	}

}