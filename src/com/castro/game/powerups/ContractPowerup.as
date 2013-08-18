package com.castro.game.powerups 
{
	import Box2D.Dynamics.b2Body;
	import com.castro.game.Entities.Entity;
	import com.castro.game.Entities.Trash;
	
	public class ContractPowerup extends Powerup
	{
		public static const TYPE : String = "contract";
		
		public function ContractPowerup(body : b2Body = null)
		{
			super(body, TYPE);
		}
	}
}