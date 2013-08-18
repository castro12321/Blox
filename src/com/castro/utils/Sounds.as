package com.castro.utils 
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	public class Sounds 
	{
		public var hitPaddle	: Sound;
		public var hitBlock		: Sound;
		public var hitWall		: Sound;
		public var destroy		: Sound;
		public var gameOver		: Sound;
		public var laser		: Sound;
		public var explosion	: Sound;
		
		public function Sounds()
		{
			/*
			var snd : Sound = new Sound();
			snd.load(new URLRequest("my.mp3"));
			snd.play();
			*/
			hitPaddle	= load("hitPaddle");
			hitBlock	= load("hitBlock");
			hitWall		= load("hitWall");
			destroy		= load("destroy");
			gameOver	= load("gameover");
			laser		= load("laser");
			explosion	= load("explosion");
			
		}
		
		private function load(path : String) : Sound
		{
			return new Sound(new URLRequest("media\\audio\\" + path + ".mp3"));
		}
	}
}