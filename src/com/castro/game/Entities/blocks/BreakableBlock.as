package com.castro.game.Entities.blocks 
{
	import Box2D.Dynamics.b2Body;
	import com.castro.Engine;
	import com.castro.game.Entities.Ball;
	import com.castro.game.Entities.blocks.Block;
	import com.castro.game.Entities.Entity;
	import com.castro.game.powerups.CutPowerup;
	import com.castro.Session;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class BreakableBlock extends Block
	{
		private var health : int;
		private var maxHealth : int;
		
		public function BreakableBlock(body : b2Body, maxHealth : int, texture : String)
		{
			Session.session.blocksLeft++;
			super(body, texture);
			this.maxHealth = maxHealth;
			this.health = maxHealth;
		}
		
		override public function onCollision(collided : Entity) : void
		{
			if (collided is Ball)
			{
				if (!destroyed)
				{
					Engine.engine.game.session.addPointsForHit();
					
					--health;
					if (health <= 0 || Session.session.ballPowerup is CutPowerup)
						destroy();
					else
						damage();
				}
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			Engine.engine.sounds.destroy.play();
			Session.session.blocksLeft--;
			if(Math.random() > 0.85)
				Engine.engine.game.lvl.addPowerup(body.GetPosition());
		}
		
		private function damage() : void
		{
			Engine.engine.sounds.hitBlock.play();
			var damage : Number = health / maxHealth;
			damage *= 5;
			
			setDamage(damage);
		}
		
		private function setDamage(damage : int) : void
		{
			if (texture.numChildren > 1)
				texture.removeChildAt(1);
			var loader : Loader = new Loader();
			texture.addChildAt(loader, 1);
			loader.load(new URLRequest("media\\dmg\\" + damage + ".png"));
		}
	}
}