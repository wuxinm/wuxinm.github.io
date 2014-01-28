﻿package  {
	import flash.display.Sprite;
	
	public class Board extends Sprite{
		
		public const BOARD_WIDTH:uint = 100;
		public const BOARD_HEIGHT:uint = 20;
		private const ELLIPSE_NUMBER:uint = 10;
		
		public function Board() {
			// constructor code
			drawBoard();
		}
		
		private function drawBoard():void{
			graphics.beginFill(0x999999, 1);
			graphics.drawRoundRect(0, 0, BOARD_WIDTH, BOARD_HEIGHT, ELLIPSE_NUMBER);
			graphics.endFill();
		}
		
	}
	
}
