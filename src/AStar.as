package 
{
	import net.flashpunk.World;
	
	import types.Node;
	
	import worlds.TestBed;
	
	public class AStar
	{
		public function AStar()
		{
		}
		
		public static function findPath(world:World, Start:Node, End:Node):Vector.<Node>
		{
			Start.h = dist(Start, End);
			var openCells:Array = new Array(Start);
			var closedCells:Array = new Array();
			var c:Node, d:Node;
			var notDone:Boolean = true;
			var cycles:int = 0;
			var finalPath:Vector.<Node>;
			
			var length:int;
			
			while(notDone) 
			{
				
				//Get a fixed representation of the length (since this will change)
				length = openCells.length;
				//Pick the first node so we have something to compare to when we are finding the lowest f score
				d = openCells[0];
			
				//Find the node with the lowest cost to reach
				for(var i:int = 0; i < length; i++)
				{
					c = openCells[i];
					if (c.f < d.f) d = c;	
				}
				
				//Now we have the cheapest node, we examine the surrounding nodes
				for each(var n:Node in adjacentNodes(d))
				{
					//Set up the child node
					n.g = d.g + 1;
					n.h = dist(n, End);
					n.f = n.g + n.h;
					n.parent = d;
					
					//Check if the spot in the world is an obstacle
					if ((world as TestBed).isFree(n.x, n.y)) 
					{
						n.free = false;
					}
					
					//If the cell is the ending cell, we are done
					if ((n.x == End.x) && (n.y == End.y))
					{
						notDone = false;
						trace("Done in ", cycles);

						finalPath = tracePath(n, new Vector.<Node>()).reverse();
						
						//Trace the path to the destination using re-re-re-recursion
						for each(var node:Node in finalPath)
						{
							(world as TestBed).addBlock(node.x, node.y, 50000000 * 20 * 20);
						}
					}
					
					//If the cell is actually viable, add it to the openCells list
					if (!(inArray(openCells, n)) && !(inArray(closedCells, n)) && (n.free))
					{
						openCells.push(n);
					}
				}
				
				//We are finished with the parent node
				closedCells.push(d);
				removeItemArray(openCells, d);
				
				//Count how many cycles this takes us
				cycles++;
				
			}
				
			return finalPath;
				
		}
		
		/**
		 * Determines if a Node is in an array (not an exact match)
		 * Determines match based on x and y
		 */
		private static function inArray(arr:Array, n:Node):Boolean
		{
			for each(var node:Node in arr)
			{
				if ((node.x == n.x) && (node.y == n.y)) return true;
			}
			
			return false;
		}
		
		/**
		 * Recursively find the path taken to the given node 
		 */
		private static function tracePath(lastNode:Node, resultVector:Vector.<Node>):Vector.<Node>
		{
			resultVector.push(lastNode);
			
			if (lastNode.parent == null)
			{
				return resultVector;
			} else
			{
				return tracePath(lastNode.parent, resultVector);
			}

		}
		
		/**
		 * Return the adjacent nodes given a parent node, these are:
		 * To the left, the right, above and below
		 */
		private static function adjacentNodes(n:Node):Vector.<Node>
		{
			var retVec:Vector.<Node> = new Vector.<Node>();
			
			//Make sure we aren't out of bounds in the world when we pick nodes
			//This would crash otherwise
			if (n.x - 1 >= 0) retVec.push(new Node(n.x-1, n.y, n));
			retVec.push(new Node(n.x+1, n.y, n));
			retVec.push(new Node(n.x, n.y+1, n));
			if (n.y - 1 >= 0) retVec.push(new Node(n.x, n.y-1, n));
			
			return retVec;
		}
		
		/**
		 * Find the distance between two nodes
		 */
		private static function dist(c:Node, b:Node):int
		{
			return int(Math.abs(c.x - b.x) + Math.abs(c.y - b.y));
		}
		
		/**
		 * Find the distance from a Node to provided co-ordinates
		 */
		private static function distInt(c:Node, x:int, y:int):int
		{
			return int(Math.abs(c.x - x) + Math.abs(c.y - y));
		}
		
		/**
		 * Removes a given node from an array of nodes
		 * Operates on given array, does not return a new one
		 */
		private static function removeItemArray(thearray:Array, theItem:Node):void{
			for(var i:int=0; i<thearray .length;i++)
			{
				if(thearray[i] == theItem){
					thearray.splice(i,1);
					i-=1;
				}
			}
		}
		
	}
}