package com.castro.game.lvls 
{
	import com.castro.game.Entities.blocks.BreakableBlock;
	
	public class Lvl4 extends Lvl
	{		
		public function Lvl4()
		{			
			map =
			[
				["  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["  ,  ,1r,1r,1r,  ,  ,  ,1r,1r,1r,1o,1o,1o,1o,1o,1o,1o,  ,  ,  ,  ,  ,  ,  ,  "],
				["1r,1r,1r,1r,1r,1r,1r,1r,1r,1r,1o,1o,1v,1v,1v,1v,1v,1o,1o,1h,  ,  ,  ,  ,1h,  "],
				["1r,1r,1r,1r,1r,1r,1r,1r,1r,1r,1o,1o,1v,1v,1v,1v,1v,1v,1h,1h,1h,  ,  ,1h,1h,1h"],
				["1r,1r,1o,1o,1o,1r,1r,1r,1o,1o,1o,1v,1v,1v,1v,1v,1v,1v,1h,1h,1h,1h,1h,1h,1h,1h"],
				["1o,1o,1o,1o,1o,1o,1o,1h,1h,1o,1o,1v,1v,1v,1v,1v,1v,1v,1h,1h,1h,1h,1h,1h,1h,1h"],
				["1o,1o,1o,1o,1o,1o,1o,1h,1h,1h,1o,1v,1r,1v,1v,1r,1v,1v,1h,1h,1h,1h,1h,1h,1h,1h"],
				["1o,1o,1y,1y,1y,1o,1o,1o,1h,1h,1o,1v,1v,1v,1v,1v,1v,1v,1h,1h,1b,1h,1h,1h,1b,1h"],
				["1y,1y,1y,1y,1y,1y,1y,1y,1y,1h,1o,1v,1v,1v,1v,1v,1v,1v,1h,1h,1h,1h,1h,1h,1h,1h"],
				["1y,1y,1y,1y,1y,1y,1y,1y,1y,1h,1o,1v,1v,1v,1v,1v,1v,1r,1h,1h,1h,1h,1h,1h,1h,1h"],
				["1y,1y,1g,1g,1g,1y,1y,1y,1g,1g,1o,1v,1v,1v,1v,1v,1v,1v,1h,1h,1r,1h,1r,1h,1r,1h"],
				["1g,1g,1g,1g,1g,1g,1g,1g,1g,1g,1o,1v,1v,1r,1v,1r,1v,1v,1o,1h,1h,1r,1h,1r,1h,  "],
				["1g,1g,1g,1g,1g,1g,1g,1g,1g,1g,1o,1v,1v,1v,1v,1v,1v,1v,1o,1h,1h,1h,1h,1h,1h,  "],
				["1g,1g,1b,1b,1b,1g,1g,1g,1b,1b,1o,1o,1v,1v,1v,1v,1v,1v,1o,  ,  ,1h,1h,  ,  ,  "],
				["1b,1b,1b,1b,1b,1b,1b,1b,1b,1b,1o,1o,1v,1v,1v,1r,1v,1v,1o,  ,  ,  ,  ,  ,  ,  "],
				["1b,1b,1b,1b,1b,1b,1b,1b,1b,1b,1b,1o,1o,1o,1o,1o,1o,1o,  ,  ,  ,  ,  ,  ,  ,  "],
				["1b,1b,1v,1v,1v,1b,1b,1b,1v,1v,1v,1h,  ,1h,  ,1h,  ,1h,  ,  ,  ,  ,  ,  ,  ,  "],
				["1v,1v,1v,1v,1v,1v,1v,1v,1v,1v,1v,1h,  ,1h,  ,1h,  ,1h,  ,  ,  ,  ,  ,  ,  ,  "],
				["1v,1v,1v,1v,1v,1v,1v,1v,1v,1v,1v,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["1v,1v,  ,  ,  ,1v,1v,1v,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "],
				["  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  "]
			]
		}
		
		override public function init() : void
		{
			// width 26 max
			// height 26 max playable
		}
	}

}