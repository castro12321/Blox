package com.castro 
{
	import com.castro.Engine;
	import com.castro.game.Entities.Ball;
	import com.castro.game.Entities.Paddle;
	import com.castro.game.powerups.*;
	import com.castro.utils.Live;
	import com.castro.utils.Point;
	import flash.display.Sprite;
	import com.castro.game.lvls.Lvl;
	import com.castro.utils.Callback;
	
	public class Session 
	{
		public static var session : Session;
		private var engine : Engine = Engine.engine;
		
		public var level	: int = 0;
		public var points	: int = 0;
		public var lives	: int = 3;
		public var speed	: Number = 20;
		public var lostBall	: Boolean = false;
		public var gOver	: Boolean = false;
		public var ballPowerup   : Powerup;
		public var paddlePowerup : Powerup;
		public var blocksLeft	 : Number = 0;
		
		private var pointsSprites : Array = new Array();
		private var livesSprites  : Array = new Array();
		private var bgDigits : Sprite;
		
		private var paddleDefaultLength : Number = 60;
		public var paddleLength : Number = paddleDefaultLength;
		
		public function Session()
		{
			session = this;
		}
		
		public function die() : void
		{
			if (--lives <= 0)
			{
				level = 0;
				points = 0;
				lives = 3;
				gOver = true;
				engine.fileMgr.saveGame();
			}
			
			setLives(lives);
			
			removePowerups()
			engine.game.lvl.paddle.destroy();
			engine.game.lvl.addPaddleWithBall();
		}
		
		public function removePowerups() : void
		{
			ballPowerup = null;
			paddlePowerup = null;
			paddleLength = paddleDefaultLength;
		}
		
		public function addLive() : void 
		{
			setLives(lives + 1);
		}
		
		private function setLives(lives : int) : void
		{
			if (lives > 10)
				lives = 10;
			this.lives = lives;
			
			for (var i : int = 0; i < 10; ++i)
			{
				var live : Live = livesSprites[i];
				if (i < lives)
				{
					if (live.active == false)
					{
						engine.utils.setTexture(live.sprite, "hearth.png");
						live.active = true;
					}
				}
				else
				{
					if (live.active)
					{
						engine.utils.setTexture(live.sprite, "hearthgrey.png");
						live.active = false;
					}
				}
			}
		}
		
		public function addPointsForHit() : void
		{
			setPoints(points + 10);
		}
		
		public function setPoints(points : int) : void
		{
			this.points = points
			
			var chars : String = points.toString();
			var char  : String;
			for (var i : int = 0; i < chars.length; ++i)
			{
				var point : Point = pointsSprites[11 - chars.length + i];
				char = chars.charAt(i);
				if (point.char != char)
				{
					Engine.engine.utils.setTexture(point.sprite, "digits\\" + char + ".png");
					point.char = char;
				}
			}
		}
		
		public function addPowerup(powerup : Powerup) : void
		{
			if (hasPowerup(powerup.type))
				return;
			
			var game : Game = Engine.engine.game;
			var lvl : Lvl = game.lvl;
			var ball : Ball;
			
			if (powerup.paddle)
				paddlePowerup = powerup;
			if (powerup.ball)
				ballPowerup = powerup;
			
			switch(powerup.type)
			{
				// PADDLE POWERUPS
				case StickyPaddlePowerup.TYPE:	lvl.paddle.setSticky();	break;
				case LaserPowerup.TYPE:			lvl.paddle.setLaser();	break;
				case ExpandPowerup.TYPE:		lvl.paddle.expand();	break;
				case ContractPowerup.TYPE:		lvl.paddle.contract();	break;
				
				// BALL POWERUPS
				case CutPowerup.TYPE:	for each(ball in lvl.balls) ball.makeSharp();		break;
				case BombPowerup.TYPE:	for each(ball in lvl.balls) ball.makeExplosive();	break;
				case SplitPowerup.TYPE: game.functions.push(new Callback(lvl.splitBalls));	break;
				case AccPowerup.TYPE:	
					if (speed <= 20) speed += 10; 
					else if (speed > 20) speed = 30; break;
				case BrakePowerup.TYPE:	
					if (speed >= 20) speed -= 10; 
					else if (speed < 20) speed = 10; break;
				
				// OTHER
				case LifePowerup.TYPE:	setLives(lives + 1); break;
				case DeathPowerup.TYPE:	for each(ball in lvl.balls) ball.destroy(); game.functions.push(new Callback(die)); break;
			}
		}
		
		public function hasPowerup(powerupType : String) : Boolean
		{
			if (paddlePowerup != null)
				if (paddlePowerup.type == powerupType)
					return true;
			if (ballPowerup != null)
				if (ballPowerup.type == powerupType)
					return true;
			return false;
		}
		
		public function initGui() : void
		{
			var s : Sprite;
			var i : int;
			
			// Add lives
			for (i = 0; i < 10; ++i)
			{
				s = new Sprite();
				s.y = 6;
				s.x = 390 + 40 * i;
				Engine.engine.utils.setTexture(s, "hearthgrey.png");
				Engine.engine.addChild(s);
				livesSprites.push(new Live(false, s));
			}
			setLives(lives);
			
			// Add background for points
			bgDigits = new Sprite();
			bgDigits.x = 25;
			bgDigits.y = 6;
			Engine.engine.utils.setTexture(bgDigits, "counterbg.png");
			Engine.engine.addChild(bgDigits);
			
			// Add points
			var chars : String = points.toString();
			var char  : String;
			for (i = 0; i < 11; ++i)
			{
				s = new Sprite();
				s.y = 10;
				s.x = 30 + 17 * i;
				Engine.engine.addChild(s);
				pointsSprites.push(new Point("-", s));
			}
			setPoints(points);
		}
	}
}