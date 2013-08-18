package com.castro.game.powerups 
{
	import Box2D.Dynamics.b2Body;
	import com.castro.game.Entities.Entity;
	import com.castro.game.Entities.Trash;
	import com.castro.Engine;
	
	public class Powerup extends Entity
	{
		public var type : String;
		public var ball : Boolean;
		public var paddle : Boolean;
		
		public function Powerup(body : b2Body, type : String, paddle : Boolean = false, ball : Boolean = false)
		{
			super(body);
			this.type = type;
			this.paddle = paddle;
			this.ball = ball;
			
			setTexture("powerups\\" + type + ".png", 0.75, 0.75);
		}
		
		override public function onCollision(collided : Entity) : void
		{
			if (collided is Trash)
				destroy();
		}
	}
}