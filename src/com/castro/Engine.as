package com.castro
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.*;
	import com.castro.game.lvls.Lvl;
	import com.castro.game.lvls.Lvl0;
	import com.castro.game.lvls.Lvl1;
	import com.castro.game.lvls.Lvl2;
	import com.castro.game.lvls.Lvl3;
	import com.castro.game.lvls.Lvl4;
	import com.castro.game.lvls.Lvl5;
	import com.castro.utils.BodyFactory;
	import com.castro.utils.FileMgr;
	import com.castro.utils.Sounds;
	import com.castro.utils.Utils;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(backgroundColor = "0x000000")]
	public class Engine extends Sprite
	{		
		public static var engine:Engine;
		public var worldScale:Number = 30;
		
		// main classes
		public var utils	: Utils;
		public var fileMgr	: FileMgr;
		public var sounds	: Sounds;
		public var bFactory : BodyFactory;
		public var eventMgr : EventMgr;
		public var game		: Game;
		
		// misc
		public var background : Sprite = new Sprite;
		public var levels : Array;
		
		// window size
		public var winX:Number;
		public var winY:Number;
		public var centerX:Number;
		public var centerY:Number;
		
		public function Engine()
		{
			init(null);
			utils	 = new Utils()
			fileMgr  = new FileMgr();
			sounds	 = new Sounds();
			bFactory = new BodyFactory(this);
			eventMgr = new EventMgr(this);
			
			engine = this;
			reloadGame()
			eventMgr.registerEvents();
		}
		
		public function reloadGame() : void
		{
			function p(lvl : Lvl) : void
			{
				levels.push(lvl);
			}
			levels = new Array();
			p(new Lvl0());
			p(new Lvl1());
			p(new Lvl2());
			p(new Lvl3());
			p(new Lvl4());
			p(new Lvl5());
			
			if (game != null)
				removeEventListener(Event.ENTER_FRAME, game.tick);
			
			while (numChildren > 0)
				removeChildAt(0);
			
			game = new Game(this);
			game.load();
			addEventListener(Event.ENTER_FRAME, game.tick);
			setDebugDraw();
		}
		
		private function setDebugDraw():void
		{
			// debug draw
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			game.lvl.world.SetDebugDraw(debugDraw);
		}
		
		public function init(e:Event):void
		{
			winX = stage.stageWidth;
			winY = stage.stageHeight;
			centerX = winX / 2;
			centerY = winY / 2;
			
			addChild(background);
		}
	}
}