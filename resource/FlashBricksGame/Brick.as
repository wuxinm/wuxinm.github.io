﻿package  {
	import flash.display.Sprite;
	import flash.geom.*
    import flash.display.*
	
	public class Brick extends Sprite{

		private var COLOR_ARRAY:Array = [0x33E707, 0xFF0000, 0x0033FF, 0xFFEE46, 0xCC00FF];
		public static const BRICK_WIDTH:uint = 80;
		public static const BRICK_HEIGHT:uint = 20;
		public static const GAP = 5;
		private const ELLIPSE_NUMBER:uint = 10;
		private var color:uint;
		
		public function Brick() {
			// constructor code
			this.color = getRandomColor();
			drawBrick(COLOR_ARRAY[color]);
		}
		
		private function drawBrick(color:uint):void{
			//graphics.beginFill(color);
			graphics.beginGradientFill(GradientType.LINEAR, [color, 0x333333], [1, 1],[180, 255]);
			graphics.drawRoundRect(0, 0, BRICK_WIDTH, BRICK_HEIGHT, ELLIPSE_NUMBER);
			graphics.lineStyle(50, 0xFFFFFF);
			graphics.endFill();
		}
		
		private function getRandomColor():int{
			var number:int;
			number = int(COLOR_ARRAY.length*Math.random());
			
			return(number);
		}
		
		public function getColor():uint{
			return color;
		}

	}
	
}
