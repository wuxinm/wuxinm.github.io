﻿package  {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BrickMatrix extends Sprite{
		
		public static const HIT_EVENT:String = "hit";
		private var _rows:uint;
		private var _cols:uint;
		private var _bricks:Array;
		private var _stage:Sprite;
		private var _ball:Ball;
		
		public function BrickMatrix(_rows:uint, _cols:uint) {
			// constructor code
			this._rows = _rows;
			this._cols = _cols;
			_bricks = new Array();
			buildMatrix();
		}

		private function buildMatrix():void{
			var i:uint;
			var j:uint;
			var brick:Brick;
			for(i = 0;i < _rows;i ++){
				for(j = 0;j < _cols;j ++){
					brick = new Brick();
					addChild(brick);
					brick.x = i * (Brick.BRICK_WIDTH + Brick.GAP);
					brick.y = j * (Brick.BRICK_HEIGHT + Brick.GAP);
					_bricks.push(brick);
				}
			}
		}
		
		public function getBricksArray():Array{
			return _bricks;
		}
	}
	
}
