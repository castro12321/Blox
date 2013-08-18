package com.castro.game.Entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.castro.Engine;
	import com.castro.game.Entities.blocks.Block;
	import com.castro.game.Entities.blocks.BreakableBlock;
	import com.castro.game.lvls.Lvl;
	import com.castro.game.powerups.BombPowerup;
	import com.castro.game.powerups.CutPowerup;
	import com.castro.Session;
	import com.castro.utils.Callback;
	
	public class Ball extends Entity
	{
		public var linked : Boolean = false;
		public var explodeable : Boolean = false;
		
		public function Ball(body : b2Body) 
		{
			super(body);
			setTexture("", 1.1, 1.1);
		}
		
		override public function onCollision(collided : Entity) : void
		{
			if (collided is Trash)
				destroy();
			else if (collided is Paddle)
				Engine.engine.sounds.hitPaddle.play();
			else if (collided is Wall)
				Engine.engine.sounds.hitWall.play();
			else if (collided is BreakableBlock)
				if (Session.session.ballPowerup is CutPowerup)
				{
					var vel : b2Vec2 = body.GetLinearVelocity().Copy();
					var pos : b2Vec2 = body.GetPosition().Copy();
					Engine.engine.game.functions.push(new Callback(postCollision, vel, pos));
				}	
		}
		
		public function postCollision(newVel : b2Vec2, newPos : b2Vec2) : void
		{
			body.SetLinearVelocity(newVel);
			body.SetPosition(newPos);
		}
		
		override public function tick(worldScale : Number) : void
		{
			body.SetAwake(true);
			super.tick(worldScale);
			adjustVelocity();
			body.SetAngularVelocity(0);
		}
		
		// protect the ball in order not to slow down too much
		private var vo : b2Vec2 = new b2Vec2();
		public function adjustVelocity() : void
		{
			var targetSpeed : Number = Engine.engine.game.session.speed;
			
			var v : b2Vec2 = body.GetLinearVelocity();
			var speed : Number = v.Length();// Math.sqrt(v.x * v.x + v.y * v.y);
			
			if (speed > 0)
			{
				var diff : Number = targetSpeed / speed;
				if (diff > 1.1)
					diff = 1.1;
				if (diff < 0.9)
					diff = 0.9;
				
				var limit : Number = 0.1;
				if (v.y <= limit && v.y >= -limit) // Check Y velocity
				{
						 if (v.y > 0) setv(v.x, limit *  2);
					else if (v.y < 0) setv(v.x, limit * -2);
					else			  setv(v.x, limit *  2 * getSign());
					return;
				}
				
				limit = 0.1;
				if (v.x <= limit && v.x >= -limit) // Check Y velocity
				{
						 if (v.x > 0) setv(limit *  2, v.y);
					else if (v.x < 0) setv(limit * -2, v.y);
					else			  setv(limit *  2 * getSign(), v.y);
					return;
				}
				
				body.SetLinearVelocity(new b2Vec2(v.x * diff, v.y * diff));
			}
		}
		
		public function split(l : Lvl) : void
		{
			if (l.balls.length > 100)
				return;
			
			var vel : b2Vec2 = body.GetLinearVelocity().Copy();
			var pos : b2Vec2 = body.GetPosition().Copy();
			
			var sign : int = 1;
			for (var i : int = 0; i < 2; ++i)
			{
				l.addBall(pos.x, pos.y);
				var ball1 : Ball = this;
				var ball2 : Ball = l.balls[l.balls.length - 1];
				
				if (vel.y > vel.x)
				{
					ball2.body.SetLinearVelocity(new b2Vec2(vel.x + 2.0 * sign, vel.y));
					ball2.body.SetPosition		(new b2Vec2(pos.x + 0.3 * sign, pos.y));
				}
				else
				{
					ball2.body.SetLinearVelocity(new b2Vec2(vel.x, vel.y + 2.0 * sign));
					ball2.body.SetPosition		(new b2Vec2(pos.x, pos.y + 0.3 * sign));
				}
				
				if(linked)
					l.linkBallToPaddle(l.paddle, ball2);
				
				sign = -1;
			}
		}
		
		public function makeExplosive() : void
		{
			setTexture("");
		}
		
		public function makeSharp() : void
		{
			setTexture("");
		}
		
		override public function setTexture(texture : String, scaleX : Number = 1.1, scaleY : Number = 1.1) : void
		{
			texture = "ball.png";
			if (Session.session.ballPowerup is CutPowerup)
				texture = "ballC.png";
			if (Session.session.ballPowerup is BombPowerup)
				texture = "ballB.png";
			super.setTexture(texture, scaleX, scaleY);
		}
		
		private function setv(vx : Number, vy : Number) : void
		{
			body.SetLinearVelocity(new b2Vec2(vx, vy));
		}
		
		private function getSign() : int
		{
			return (Math.random() > 0.5 ? 1 : -1);
		}
	}
}