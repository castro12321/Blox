package com.castro.game.Entities 
{
	import Box2D.Dynamics.b2Body;
	
	public class Trash extends Entity
	{
		public function Trash(body : b2Body)
		{
			super(body);
		}
		
		override public function onCollision(collided : Entity) : void
		{
			//if (collided is Entity)
			//collided.destroy();
		}
	}
}