package com.castro 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.castro.game.Entities.Ball;
	import com.castro.game.Entities.Entity;
	import com.castro.game.Entities.Wall;
	import com.castro.game.lvls.Lvl;
	import com.castro.game.powerups.LaserPowerup;
	import com.castro.game.powerups.Powerup;
	import com.castro.Session;
	import com.castro.utils.Callback;
	import flash.events.Event;
	import flash.net.FileReference;
	
	public class Game extends b2ContactListener
	{
		private var engine : Engine;
		
		public var session : Session;
		public var lvl : Lvl;
		public var functions : Array = new Array();
		public var pause : Boolean = false;
		
		public function Game(engine : Engine)
		{
			this.engine = engine;
		}
		
		
		public function clean(arr : Array, e : Entity) : void
		{
			if(arr != null)
				engine.utils.removeFromArray(arr, e);
			
			if(engine.contains(e.texture))
				engine.removeChild(e.texture);
			if(e.body != null)
				e.body.GetWorld().DestroyBody(e.body);
		}
		
		public function tick(event : Event) : void
		{
			if (pause)
				return;
			
			while (functions.length > 0)
			{
				var callback : Callback = functions.pop();
				callback.fn.apply(callback.fn, callback.args);
			}
			
			if (lvl.balls.length <= 0)
				session.die();
			
			if (session.blocksLeft <= 0)
			{
				session.level++;
				engine.fileMgr.saveGame();
				engine.reloadGame();
				return;
			}
			
			// Box2d stuff
			//lvl.world.Step(engine.utils.getDT() / 1000.0, 6, 3);
			lvl.world.Step(1.0 / 30.0, 8, 8);
			lvl.world.ClearForces();
			//lvl.world.DrawDebugData();
			
			if(session.speed > 20)
				session.speed -= 0.01;
			if (session.speed < 20)
				session.speed += 0.01;
			
			if (session.gOver)
			{
				Engine.engine.sounds.gameOver.play();
				Engine.engine.reloadGame();
				return;
			}
			
			// Tick in objects
			var ws : Number = engine.worldScale;
			lvl.paddle.tick(ws);
			lvl.laser.tick(ws);
			for each(var w:Wall	   in lvl.walls)	w.tick(ws);
			for each(var b:Ball	   in lvl.balls)	b.tick(ws);
			for each(var o:Entity  in lvl.objects)	o.tick(ws);
			for each(var p:Powerup in lvl.powerups)	p.tick(ws);
		}
		
		
		public function load() : void
		{
			var file : FileReference = new FileReference();
			
			session = new Session();
			engine.fileMgr.loadGame();
			
			if (session.level >= engine.levels.length)
				session.level = 0;
			
			lvl = engine.levels[session.level];
			lvl.initBase();
			lvl.init();
			session.initGui();
			
            lvl.world.SetContactListener(this); // register collision callbacks
		}
		
		
		override public function BeginContact(contact:b2Contact) : void
		{
			if (contact.IsTouching() || true)
			{
				var fixtureA : b2Fixture = contact.GetFixtureA();
				var fixtureB : b2Fixture = contact.GetFixtureB();
				var bodyA	 : b2Body = fixtureA.GetBody();
				var bodyB	 : b2Body = fixtureB.GetBody();
				var entityA	 : Entity = bodyA.GetUserData();
				var entityB	 : Entity = bodyB.GetUserData();
				if (entityA != null && entityB != null)
				{
					entityA.onCollision(entityB);
					entityB.onCollision(entityA);
				}
				else
					trace("FOUND NULL! In Game.as BeginContact D:");
			}
		}
		
		
		//override public function EndContact(contact:b2Contact):void { }
		//override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void {}
		//override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void { }
	}
}