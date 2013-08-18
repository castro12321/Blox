package com.castro.game.Entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.castro.game.Entities.blocks.Block;
	
	public class Laser extends Entity
	{
		public function Laser(body : b2Body) 
		{
			super(body);
			setTexture("laser.png");
		}
		
		override public function onCollision(collided : Entity) : void
		{
			body.SetAngle(0);
			if (collided is Block)
			{
				collided.destroy();
				destroy();
			}
			else if (collided is Wall)
				destroy();
		}
		
		override public function tick(worldScale : Number) : void
		{
			if (body != null)
			{
				super.tick(worldScale);
				body.SetLinearVelocity(new b2Vec2(0, -15));
				body.SetAngle(0);
			}
		}
	}
}