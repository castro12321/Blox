package com.castro.utils 
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.*;
	import com.castro.Engine;
	import com.castro.game.Entities.Ball;
	import com.castro.game.Entities.Laser;
	import com.castro.game.Entities.Paddle;
	import com.castro.Session;
	
	public class BodyFactory 
	{
		private var engine : Engine;
		private var worldScale : int;
		
		// 0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200 to 0x8000
		// What a category an object is
		public var CATEGORY_BALL	: uint = 0x0001;
		public var CATEGORY_PADDLE	: uint = 0x0002;
		public var CATEGORY_BLOCK	: uint = 0x0004;
		public var CATEGORY_POWERUP	: uint = 0x0008;
		public var CATEGORY_WALL	: uint = 0x0010;
		public var CATEGORY_LASER	: uint = 0x0020;
		public var CATEGORY_ALL		: uint = 0xFFFF;
		
		// who with an object collides
		public var MASK_BALL	: uint =(CATEGORY_ALL ^ CATEGORY_BALL) ^ CATEGORY_POWERUP;
		public var MASK_PADDLE	: uint = CATEGORY_ALL;
		public var MASK_BLOCK	: uint = CATEGORY_ALL;
		public var MASK_POWERUP	: uint = (CATEGORY_ALL ^ CATEGORY_BLOCK) ^ CATEGORY_POWERUP; // all except block
		public var MASK_WALL	: uint = CATEGORY_ALL;
		public var MASK_LASER	: uint = CATEGORY_BLOCK | CATEGORY_WALL;
		
		public function BodyFactory(engine : Engine)
		{
			this.engine = engine;
			this.worldScale = engine.worldScale;
		}
		
		public function createBlock(pX : Number, pY : Number, width : Number, height : Number, isWall : Boolean) : b2Body
		{
			var bodyDef : b2BodyDef = getBodyDef(pX, pY, b2Body.b2_staticBody);
			var body : b2Body = createBody(bodyDef);
			
			var polygonShape : b2PolygonShape = new b2PolygonShape();
			width  /= 2 * worldScale;
			height /= 2 * worldScale;
			polygonShape.SetAsBox(width, height);
			
			var fixtureDef : b2FixtureDef;
			if(isWall)
				fixtureDef = getFixtureDef(polygonShape, CATEGORY_WALL, MASK_WALL);
			else
				fixtureDef = getFixtureDef(polygonShape, CATEGORY_BLOCK, MASK_BLOCK);
			body.CreateFixture(fixtureDef);
			
			return body;
		}
		
		public function createPowerup(position : b2Vec2) : b2Body
		{
			var bodyDef : b2BodyDef = getBodyDef(position.x , position.y, b2Body.b2_dynamicBody);
			var body : b2Body = createBody(bodyDef);
			body.SetPosition(position);
			body.SetLinearVelocity(new b2Vec2(0, 5));
			
			var polygonShape : b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(9 / worldScale, 9 / worldScale);
			
			var fixtureDef : b2FixtureDef = getFixtureDef(polygonShape, CATEGORY_POWERUP, MASK_POWERUP);
			body.CreateFixture(fixtureDef);
			
			return body;
		}
		
		public function createPaddleBody(center_x : Number, center_y : Number, angle_from:Number = 180, angle_to:Number = 360, precision:Number = 1) : b2Body
		{
			var radius : Number = Session.session.paddleLength;
			var height : Number = 60;
			
			center_x /= engine.worldScale;
			center_y /= engine.worldScale;
			
			var angle_diff : Number = angle_to - angle_from;
			var steps : Number = Math.round(angle_diff * precision);
			var angle : Number = angle_from;
			var px : Number = center_x + radius * Math.cos(angle * Math.PI / 180);
			var py : Number = center_y + height * Math.sin(angle * Math.PI / 180);
			
			var vertexes : Array = new Array();			
			for (var i:int = 0; i <= steps; i++) 
			{
				angle = angle_from + angle_diff / steps * i;
				px = center_x + radius * Math.cos(angle * Math.PI / 180);
				px -= 14;
				px /= worldScale;
				
				py = center_y + height * Math.sin(angle * Math.PI / 180);
				py *= 0.3;
				py += 3;
				py /= worldScale;
				
				vertexes.push(new b2Vec2(px, py));
			}
			
			var bodyDef : b2BodyDef = getBodyDef(0, 0, b2Body.b2_kinematicBody);
			var chainBody : b2Body = createBody(bodyDef);
			chainBody.SetPosition(new b2Vec2(center_x, center_y - 0.5));
			
			var chainDef : b2EdgeChainDef = new b2EdgeChainDef;
			for (var j : int = 0; j < vertexes.length; j++)
					chainDef.vertices.push(vertexes[j]);
			chainDef.vertexCount = chainDef.vertices.length;
			
			var chainShape : b2PolygonShape = new b2PolygonShape();
			chainShape.SetAsArray(chainDef.vertices, chainDef.vertexCount);
			
			var fixtureDef : b2FixtureDef = getFixtureDef(null, CATEGORY_PADDLE, MASK_PADDLE);
			fixtureDef.shape = chainShape;
			
			chainBody.CreateFixture(fixtureDef);
			return chainBody;
		}
		
		public function createPaddle(center_x:Number, center_y:Number) : Paddle
		{
			var body : b2Body = createPaddleBody(center_x, center_y); 
			return new Paddle(body);
		}
		
		public function createBall(pX : Number, pY : Number, radius : Number) : Ball
		{
			radius /= worldScale;
			
			var bodyDef : b2BodyDef = getBodyDef(pX, pY, b2Body.b2_dynamicBody, true);
			var body : b2Body = createBody(bodyDef);
			
			var fixtureDef : b2FixtureDef = getFixtureDef(new b2CircleShape(radius), CATEGORY_BALL, MASK_BALL);
			body.CreateFixture(fixtureDef);
			
			return new Ball(body);
		}
		
		public function createLaser(pX : Number, pY : Number) : Laser
		{
			var bodyDef : b2BodyDef = getBodyDef(pX, pY, b2Body.b2_dynamicBody);
			var body : b2Body = createBody(bodyDef);
			
			var polygonShape : b2PolygonShape = new b2PolygonShape();
			var width  : Number = 0.1;
			var height : Number = 1.0;
			polygonShape.SetAsBox(width, height);
			
			var fixtureDef : b2FixtureDef;
			//fixtureDef = getFixtureDef(polygonShape, CATEGORY_LASER, MASK_LASER);
			fixtureDef = getFixtureDef(polygonShape, CATEGORY_LASER, MASK_LASER);
			body.CreateFixture(fixtureDef);
			
			//return body;
			return new Laser(body);
		}
		
		private function getBodyDef(posX : Number, posY : Number, type : uint, bullet : Boolean = false) : b2BodyDef
		{
			var bodyDef : b2BodyDef = new b2BodyDef();
			posX /= worldScale;
			posY /= worldScale;
			bodyDef.position.Set(posX, posY);
			bodyDef.type = type;
			bodyDef.bullet = bullet;
			return bodyDef;
		}
		
		private function getFixtureDef(shape : b2Shape, categoryBits : uint, maskBits : uint, density : Number = 1, restitution : Number = 1, friction : Number = 0, isSensor : Boolean = false) : b2FixtureDef
		{
			var fixtureDef : b2FixtureDef = new b2FixtureDef();
			var filter : b2FilterData = new b2FilterData();
			filter.categoryBits = categoryBits;
			filter.maskBits = maskBits;
			fixtureDef.filter = filter
			fixtureDef.isSensor = isSensor;
			fixtureDef.shape = shape;
			fixtureDef.density = density;
			fixtureDef.restitution = restitution;
			fixtureDef.friction = friction;
			return fixtureDef;
		}
		
		private function createBody(bodyDef : b2BodyDef) : b2Body
		{
			return engine.game.lvl.world.CreateBody(bodyDef);
		}
		
		public function getFilter(category : uint, mask : uint) : b2FilterData
		{
			var filter : b2FilterData = new b2FilterData();
			filter.categoryBits = category;
			filter.maskBits = mask;
			return filter;
		}
	}
}