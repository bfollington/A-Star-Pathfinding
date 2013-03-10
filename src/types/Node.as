package types
{
	public class Node
	{
		public var x:int=0, y:int=0, g:int=0, h:int=0, f:int=0;
		public var parent:Node;
		public var free:Boolean = true;
		
		public function Node(_x:int, _y:int, _parent:Node=null, _g:int=0, _h:int=0)
		{
			x = _x;
			y = _y;
			g = _g;
			h = _h;
			f = g + h;
			parent = _parent;

		}
		
		public function toString():String
		{
			return "New Cell x:" + x.toString() + ", y:" + y.toString() + ", h:" + g.toString() + ", g:" + h.toString() + ", f:" + f.toString();
		}
	}
}