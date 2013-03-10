package worlds
{
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import types.Node;
	
	public class TestBed extends World
	{
		
		private var _levelData:Array = [[]];
		
		private static const ARRAY_WIDTH:int = 40;
		private static const ARRAY_HEIGHT:int = 30;
		private var maxWidth:int = ARRAY_WIDTH;
		private var maxHeight:int = ARRAY_HEIGHT;
		
		public function TestBed()
		{
			super();
			
			//var e:Entity = new Entity(0, 0, new Image( new BitmapData(32, 32)));
			//add(e);
			
			_levelData = initArray(ARRAY_WIDTH, ARRAY_HEIGHT);
			
			_levelData[10][10] = 1;
			
			renderGrid();
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.mousePressed)
			{
				var mX:int, mY:int;
				
				mX = int(Input.mouseX / 32);
				mY = int(Input.mouseY / 32);
				
				_levelData[mX][mY] = 1;
				addBlock(mX, mY, 0xFFFF1493);
			}
			
			if (Input.pressed(Key.SPACE))
			{
				AStar.findPath(FP.world, new Node(5, 5), new Node(12, 12));
			}
			
		}
		
		public function addBlock(x:int, y:int, col:uint):void
		{
			addGraphic( new Image( new BitmapData(32, 32, false, col)), 0, x*32, y*32);
			_levelData[x][y] = 1;
			
			if (maxWidth < x) maxWidth = x;
			if (maxHeight < y) maxHeight = y;
			
		}
		
		private function renderGrid():void
		{
			for (var i:int = 0; i < ARRAY_WIDTH; i++)
			{
				for (var j:int = 0; j < ARRAY_HEIGHT; j++)
				{
					//trace(i, j);
					if (_levelData[i][j] == 1)
					{
						trace("Draw Grid at ", i, ", ", j);
						addBlock(i, j, 0xFFFF3497);
					}
				}
			}
		}
		
		public function isFree(x:int, y:int):Boolean
		{

			trace(x, y);
			
			if (x > maxWidth) return false;
			if (y > maxHeight) return false;
			
			if (_levelData[x][y] == 0)
			{
				return false;
			} else {
				return true;
			}

		}
		
		private function initArray(width:uint, height:uint):Array
		{
			var array:Array = new Array();
			var i:int;
			var j:int;
			
			for (i = 0; i < width; i++) {
				array.push(new Array());
				for (j = 0; j < height; j++) {
					array[i].push(0);
				}
			}
			
			return array;
		}
	}
}