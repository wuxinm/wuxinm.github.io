package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class BossUFO extends Sprite{
		
		public var _bossUFO:BoUFO;
		public var _count:int = 0;
		public static const START:String = "start";
		
		public function BossUFO() {
			// constructor code
			_bossUFO = new BoUFO();
			_bossUFO.addEventListener(Event.ENTER_FRAME, appearUFO);
			_bossUFO.width = 0;
			_bossUFO.height = 0;
			_bossUFO.stop();
			addChild(_bossUFO);
		}

		private function appearUFO(e:Event):void{
			var _bossUFO:BoUFO = e.target as BoUFO;
			_bossUFO.width += 5;
			_bossUFO.height += 2;
			if(_bossUFO.width == 250){
				_bossUFO.removeEventListener(Event.ENTER_FRAME, appearUFO);
				dispatchEvent(new Event(START))
			}
		}
	}
	
}
