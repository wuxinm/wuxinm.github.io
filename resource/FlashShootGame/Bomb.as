package  {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Bomb extends Sprite{
		
		private var _bomb:BBomb;
		
		public function Bomb() {
			// constructor code
			_bomb = new BBomb();
			_bomb.addEventListener(Event.ENTER_FRAME, addBomb);
			addChild(_bomb);
		}
		
		private function addBomb(e:Event):void{
			_bomb.y += 8;
		}

	}
	
}
