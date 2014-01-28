﻿package  {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Ball extends Sprite{
		
		public const BALL_WIDTH:uint = 25;
		public const BALL_HEIGHT:uint = 25;
		
		public function Ball() {
			// constructor code
			drawBall();
		}
		
		private function drawBall():void{
			graphics.beginFill(0xFFFFFF);
			graphics.drawEllipse(0, 0, BALL_WIDTH, BALL_HEIGHT);
			graphics.endFill();
		}
		
	}
	
}
