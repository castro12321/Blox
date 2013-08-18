package com.castro.game.Entities.blocks 
{
	import Box2D.Dynamics.b2Body;
	import com.castro.game.Entities.Entity;
	
	public class Block extends Entity
	{
		public static var width  : Number = 30;
		public static var height : Number = 15;
		
		public function Block(body : b2Body, texture : String)
		{ 
			super(body);
			setTexture("blocks\\" + texture + ".png"); // 30x15
		}
	}
}