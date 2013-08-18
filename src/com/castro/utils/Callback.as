package com.castro.utils 
{	
	public class Callback 
	{
		public var fn : Function;
		public var args : *;
		
		public function Callback(func : Function, ...args) 
		{
			this.fn = func;
			this.args = args as Array;
			
			//var newArgs : Array = args as Array;			
			//newArgs.unshift(fn);
			
			
			//func.apply(fn, args);
			//callback.fn.apply(callback.args);
		}
	}

}