package com.castro.game.powerups 
{
	import Box2D.Dynamics.b2Body;
	import com.castro.game.Entities.Entity;
	import com.castro.game.Entities.Trash;
	
	public class BombPowerup extends Powerup
	{
		public static const TYPE : String = "bomb";
		
		public function BombPowerup(body : b2Body = null)
		{
			super(body, TYPE, false, true);
		}
	}
}