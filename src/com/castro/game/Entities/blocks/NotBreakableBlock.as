package com.castro.game.Entities.blocks 
{
	import Box2D.Dynamics.b2Body;
	import com.castro.game.Entities.blocks.Block;
	import com.castro.game.Entities.Entity;
	
	public class NotBreakableBlock extends Block
	{
		public function NotBreakableBlock(body : b2Body, texture : String) 
		{
			super(body, texture);
		}
		
		override public function onCollision(collided : Entity) : void
		{
			return;
		}
	}
}