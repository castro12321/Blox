package com.castro.game.Entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import com.castro.Engine;
	import com.castro.Game;
	import com.castro.game.powerups.LaserPowerup;
	import com.castro.game.powerups.Powerup;
	import com.castro.game.powerups.StickyPaddlePowerup;
	import com.castro.Session;
	import com.castro.utils.BodyFactory;
	import com.castro.utils.Callback;
	import com.castro.game.lvls.Lvl;
	
	public class Paddle extends Entity
	{
		public var balls : Array = new Array();
		
		public function Paddle(body : b2Body)
		{
			super(body);
			setTexture("paddle.png");
		}
		
		override public function onCollision(collided : Entity) : void
		{
			if (collided is Powerup)
			{
				Session.session.addPowerup(collided as Powerup);
				collided.destroy();
			}
			
			if (collided is Ball)
			{
				if (Session.session.hasPowerup(StickyPaddlePowerup.TYPE))
					Engine.engine.game.lvl.linkBallToPaddle(this, collided as Ball);
			}
		}
		
		override public function move(x : Number, y : Number) : void
		{
			var ws : Number = Engine.engine.worldScale;
			
			// Block moving the paddle out of map
			if (x * ws - Session.session.paddleLength < 5)
				x = 5 / ws + Session.session.paddleLength / ws;
			else if (x * ws + Session.session.paddleLength > 795)
				x = 795 / ws - Session.session.paddleLength / ws;
			
			var changeX : Number = x - body.GetPosition().x;
			
			// Move the paddle...
			y = body.GetPosition().y;
			body.SetPosition(new b2Vec2(x, y));
			
			// Move linked balls
			for (var i : int = 0; i < balls.length; ++i)
			{
				var ball : Ball = balls[i];
				var npos : b2Vec2 = ball.body.GetPosition().Copy();
				ball.move(npos.x + changeX, npos.y);
			}
		}
		
		public function shoot() : void
		{
			// TODO: laser
			if (Session.session.hasPowerup(LaserPowerup.TYPE))
			{
				var game : Game = Engine.engine.game;
				game.functions.push(new Callback(game.lvl.shootLaser));
			}
			
			var ball : Ball = null;
			while (ball = balls.pop())
			{
				ball.linked = false;
				ball.body.SetAwake(true);
				var bf : BodyFactory = Engine.engine.bFactory;
				var f : b2Fixture = ball.body.GetFixtureList();
				if(f)
					f.SetFilterData(bf.getFilter(bf.CATEGORY_BALL, bf.MASK_BALL));
				
				var diffX : Number = ball.body.GetPosition().x - body.GetPosition().x;
				var distX : Number = Math.abs(diffX);
				var radius: Number = Session.session.paddleLength / Engine.engine.worldScale;
				var ratio : Number = diffX / radius;
				var speed : Number = Session.session.speed;
				var velX  : Number = speed * ratio; velX *= 0.85;
				var velY  : Number = -Math.sqrt(Math.abs(speed * speed - velX * velX));
				
				ball.body.SetLinearVelocity(new b2Vec2(velX, velY));
				ball.adjustVelocity();
			}
		}
		
		public function reloadPaddle() : void
		{
			var ws : Number = Engine.engine.worldScale;
			var pos : b2Vec2 = body.GetPosition().Copy();
			pos.x *= ws;
			pos.y = Engine.engine.winY - 15;
			
			body.GetWorld().DestroyBody(body);
			body = Engine.engine.bFactory.createPaddleBody(pos.x, pos.y);
			body.SetUserData(this);
			
			var r : Number = Session.session.paddleLength;
			setTexture(currTexture);
		}
		
		public function setSticky() : void
		{
			setTexture("");
		}
		
		public function setLaser() : void
		{
			setTexture("");
		}
		
		public function expand() : void
		{
			if (Session.session.paddleLength <= 80)
				changeLength(20);
		}
		
		public function contract() : void
		{
			if (Session.session.paddleLength >= 40)
				changeLength(-20);
		}
		
		public function changeLength(change : Number) : void
		{
			Session.session.paddleLength += change;
			Engine.engine.game.functions.push(new Callback(Engine.engine.game.lvl.paddle.reloadPaddle));
		}
		
		override public function setTexture(texture : String, scaleX : Number = 1, scaleY : Number = 1) : void
		{
			texture = "paddle.png";
			if (Session.session.paddlePowerup is LaserPowerup)
				texture = "paddleB.png";
			if (Session.session.paddlePowerup is StickyPaddlePowerup)
				texture = "paddleG.png";
			super.setTexture(texture, Session.session.paddleLength / 60);
		}
	}
}