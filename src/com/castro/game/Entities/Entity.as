package com.castro.game.Entities
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.castro.Engine;
	import com.castro.Game;
	import com.castro.game.Entities.blocks.Block;
	import com.castro.game.powerups.Powerup;
	import com.castro.utils.Callback;
	import flash.display.Sprite;
	
	public class Entity
	{
		public var body : b2Body;
		public var texture : Sprite = new Sprite();
		
		public var destroyed : Boolean = false;
		public var currTexture : String;
		//public var sprite : Sprite;
		
		public function Entity(body : b2Body)
		{
			this.body = body;
			if (body != null)
				body.SetUserData(this);
			Engine.engine.addChild(texture);
		}
		
		public function onCollision(collided : Entity) : void
		{ trace("UNUSED onCollision in Entity"); }
		
		public function move(x : Number, y : Number) : void
		{
			body.SetPosition(new b2Vec2(x, y));
		}
		
		public function tick(worldScale : Number) : void
		{
			texture.x = (body.GetPosition().x * worldScale) - (texture.width * 0.5);
			texture.y = (body.GetPosition().y * worldScale) - (texture.height * 0.5);
		}
		
		public function setTexture(path : String, scaleX : Number = 1, scaleY : Number = 1) : void
		{
			Engine.engine.utils.setTexture(texture, path, scaleX, scaleY);
			currTexture = path;
		}
		
		public function destroy() : void
		{
			if (!destroyed)
			{
				//Engine.engine.removeChild(this);
				
				var game : Game = Engine.engine.game;
				if (this is Ball)
					game.functions.push(new Callback(game.clean, game.lvl.balls, this));
				else if (this is Powerup)
					game.functions.push(new Callback(game.clean, game.lvl.powerups, this));
				else if (this is Block)
					game.functions.push(new Callback(game.clean, game.lvl.objects, this));
				else if (this is Paddle)
					game.functions.push(new Callback(game.clean, null, this));
				else if (this is Laser)
					game.functions.push(new Callback(game.clean, null, this));
					
				//Engine.engine.game.toDestroy.push(this);
				destroyed = true;
			}
		}
	}
}