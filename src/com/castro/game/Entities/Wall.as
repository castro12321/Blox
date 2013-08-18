package com.castro.game.Entities 
{
	import Box2D.Dynamics.b2Body;
	
	public class Wall extends Entity
	{		
		public function Wall(body : b2Body, width : Number, height : Number)
		{
			super(body);
			setTexture("wall.png", width/2, height/2);// , width, height);
		}
		
		override public function onCollision(collided : Entity) : void
		{
		}
	}
}