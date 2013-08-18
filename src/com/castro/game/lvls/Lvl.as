package com.castro.game.lvls 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import com.castro.Engine;
	import com.castro.game.Entities.Ball;
	import com.castro.game.Entities.blocks.Block;
	import com.castro.game.Entities.blocks.BreakableBlock;
	import com.castro.game.Entities.blocks.NotBreakableBlock;
	import com.castro.game.Entities.Entity;
	import com.castro.game.Entities.Laser;
	import com.castro.game.Entities.Paddle;
	import com.castro.game.Entities.Trash;
	import com.castro.game.Entities.Wall;
	import com.castro.game.powerups.BombPowerup;
	import com.castro.game.powerups.ContractPowerup;
	import com.castro.game.powerups.DeathPowerup;
	import com.castro.game.powerups.ExpandPowerup;
	import com.castro.game.powerups.LaserPowerup;
	import com.castro.game.powerups.LifePowerup;
	import com.castro.game.powerups.Powerup;
	import com.castro.game.powerups.SplitPowerup;
	import com.castro.game.powerups.StickyPaddlePowerup;
	import com.castro.game.powerups.CutPowerup;
	import com.castro.game.powerups.AccPowerup;
	import com.castro.game.powerups.BrakePowerup;
	import com.castro.utils.Callback;
	
	// Raw level (from file or so...)
	public class Lvl 
	{
		private var engine  : Engine;
		
		public var map : Array;
		
		public var world	: b2World;
		public var trash	: Trash;
		public var paddle	: Paddle;
		public var laser	: Laser = new Laser(null);
		public var walls	: Array = new Array();
		public var balls	: Array = new Array();
		public var objects	: Array = new Array();
		public var powerups	: Array = new Array();
		
		public function Lvl()
		{
			this.engine = Engine.engine;
			world = new b2World(new b2Vec2(), true);
		}
		
		public function initBase() : void
		{
			var wX : Number = engine.winX;
			var wY : Number = engine.winY;
			
			createWall(wX / 2, 25    , wX-10, 50); // upper wall
			createWall(-15	 , wY / 2, 50	, wY); // left wall
			createWall(wX +15, wY / 2, 50	, wY); // right wall
			trash = new Trash(createBody(wX / 2, wY + 5, wX, 10)); // down wall
			
			addPaddleWithBall();
			
			loadLvl();
		}
		
		public function init() : void
		{
			trace("UNUSED init() in lvl!");
		}
		
		/****
		 * BODY
		 ****/
		
		private function createBody(x : Number, y : Number, w : Number, h : Number, isWall : Boolean = false) : b2Body {
			return engine.bFactory.createBlock(x, y, w, h, isWall);
		}
		
		private function createWall(x : Number, y : Number, w : Number, h : Number) : void 
		{
			var body : b2Body = createBody(x, y, w, h, true);
			walls.push(new Wall(body, w, h));
		}
		
		/****
		 * BALL
		 ****/
		public function addBall(x : int, y : int) : void {
			balls.push(engine.bFactory.createBall(x, y, 8));
		}
		
		public function splitBalls() : void
		{
			var len : int = balls.length.valueOf();
			for (var i : int = 0; i < len; ++i)
				(balls[i] as Ball).split(this);
			//engine.game.split++;
		}
		
		/****
		 * PADDLE
		 ****/
		
		public function addPaddle(x : int, y : int) : void 
		{
			paddle = engine.bFactory.createPaddle(x, y);
		}
		
		public function addPaddleWithBall(/*x : int, y : int*/) : void
		{
			var x : Number = engine.centerX;
			var y : Number = engine.winY - 15;
			addPaddle(x, y);
			addBall(x, y);
			linkBallToPaddleWithOffset(paddle, balls[balls.length -1], new b2Vec2(-0.3, -0.8));
			//paddle.balls.push(balls[balls.length - 1]); // links paddle with ball
		}
		
		public function linkBallToPaddle(paddle : Paddle, ball : Ball) : void
		{
			if (ball.linked == false)
			{
				ball.body.SetLinearVelocity(new b2Vec2()); // stop ball			
				ball.body.SetAwake(false);
				ball.body.GetFixtureList().SetFilterData(engine.bFactory.getFilter(0, 0));
				paddle.balls.push(ball);
				ball.linked = true;
			}
		}
		
		public function linkBallToPaddleWithOffset(paddle : Paddle, ball : Ball, offset : b2Vec2) : void
		{
			var pos : b2Vec2 = paddle.body.GetPosition();
			ball.body.SetPosition(new b2Vec2(pos.x + offset.x, pos.y + offset.y));
			linkBallToPaddle(paddle, ball);
		}
		
		/****
		 * BLOCKS
		 ****/
		public function addBlockXY(block : Block, x : Number, y : Number) : void
		{
			// swap x and y
			var tmp : Number = x; x = y; y = tmp;
			
			x = 11 + Block.width  * x - Block.width  / 2;
			x /= engine.worldScale;
			y = 50.5 + Block.height * y - Block.height / 2;
			y /= engine.worldScale;
			block.body.SetPosition(new b2Vec2(x, y));
			
			objects.push(block);
		}
		
		public function createBlock(block : Block, x : Number, y : Number) : void
		{
			block.body = createBody(0, 0, Block.width, Block.height);
			block.body.SetUserData(block);
			addBlockXY(block, x, y);
		}
		
		/****
		 * POWERUP
		 ****/
		public function addPowerup(position : b2Vec2) : void
		{
			//engine.game.powerupsQueue.push(position);
			engine.game.functions.push(new Callback(spawnPowerup, position));
		}
		
		public function spawnPowerup(position : b2Vec2) : void
		{
			var p : Powerup = randomPowerup();
			p.body = engine.bFactory.createPowerup(position);
			p.body.SetUserData(p);
			powerups.push(p);
		}
		
		private function randomPowerup() : Powerup
		{
			var p : Powerup;
			var r : int = Math.random() * 11;
			switch(r)
			{
				// PADDLE
				case  0: p = new StickyPaddlePowerup();	break;
				case  1: p = new LaserPowerup();	break;
				case  2: p = new ExpandPowerup();	break;
				case  3: p = new ContractPowerup();	break;
				// BALL
				case  4: p = new CutPowerup();		break;
				case  5: return randomPowerup(); p = new BombPowerup();		break;
				case  6: p = new SplitPowerup();	break;
				case  7: p = new AccPowerup();		break;
				case  8: p = new BrakePowerup();	break;
				// MISC
				case  9: p = new LifePowerup();		break;
				case 10: p = new DeathPowerup();	break;
				default: p = new SplitPowerup();
			}
			return p;
		}
		
		/****
		 * MISC
		 ****/
		
		public function shootLaser() : void
		{
			/**/
			if (laser.destroyed || laser.body == null)
			{
				var pos : b2Vec2 = paddle.body.GetPosition().Copy();
				pos.Multiply(engine.worldScale);
				laser.destroy();
				Engine.engine.sounds.laser.play();
				laser = engine.bFactory.createLaser(pos.x, pos.y);
			}
			/**/
		}
		public function removeObject(value : Entity) : void
		{
			for (var i : int = 0; i < objects.length; ++i)
				if (objects[i] == value)
				{
					objects[i] = objects[objects.length - 1];
					objects.pop();
				}
		}
		
		private function loadLvl() : void
		{
			var dmg : int;
			var color : String;
			
			var i : int = 1;
			var j : int = 1;
			for each(var line : String in map)
			{
				var blocks : Array = line.split(",");
				for each(var block : String in blocks)
				{
					if (block != "  ")
					{
						dmg   = parseInt(block.charAt(0));
						color = block.charAt(1);
						if (dmg < 6)
							createBlock(new BreakableBlock(null, dmg, color), j, i);
						else
							createBlock(new NotBreakableBlock(null, color), j, i);
					}
					++i;
				}
				i = 1;
				++j;
			}
		}
	}
}