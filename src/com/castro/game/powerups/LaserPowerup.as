package com.castro.game.powerups 
{
	import Box2D.Dynamics.b2Body;
	import com.castro.game.Entities.Entity;
	import com.castro.game.Entities.Trash;
	
	public class LaserPowerup extends Powerup
	{
		public static const TYPE : String = "laser";
		
		public function LaserPowerup(body : b2Body = null)
		{
			super(body, TYPE, true);
		}
	}
}