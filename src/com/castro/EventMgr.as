package com.castro 
{
	import com.castro.Engine;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class EventMgr
	{
		private var engine : Engine;
		
		public function EventMgr(engine : Engine)
		{
			this.engine = engine;
		}
		
		public function registerEvents() : void
		{
			engine.stage.addEventListener(MouseEvent.CLICK, mouseClick);
			engine.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			engine.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		private function mouseClick(e : MouseEvent) : void
		{
			engine.game.lvl.paddle.shoot();
		}
		
		private function mouseMove(e : MouseEvent) : void
		{
			var x : Number = e.stageX / engine.worldScale;
			var y : Number = e.stageY / engine.worldScale;
			engine.game.lvl.paddle.move(x, y);
		}
		
		private function keyDown(e : KeyboardEvent) : void
		{
			var p : uint = 112;
			if (e.charCode == p)
				engine.game.pause = !engine.game.pause;
		}
	}
}