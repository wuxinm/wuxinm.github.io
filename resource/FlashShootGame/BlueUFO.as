package  {
	import flash.events.*;
	import flash.display.Sprite;

	public class BlueUFO extends Sprite{
		
		public var _blueUFO:BUFO;
		public var _count:int = 0

		public function BlueUFO() {
			// constructor code
			_blueUFO = new BUFO();
			_blueUFO.addEventListener(Event.ENTER_FRAME, appearUFO)
			_blueUFO.width =0;
			_blueUFO.height =0;
			_blueUFO.stop();
			addChild(_blueUFO);
		}
		
		private function appearUFO(e:Event):void
		{
			var _UFO:BUFO = e.target as BUFO;
			_UFO.width +=  3.5;
			_UFO.height +=  2;
			if (_UFO.width == 70)
			{
				_UFO.removeEventListener(Event.ENTER_FRAME, appearUFO);
				_UFO.addEventListener(Event.ENTER_FRAME, moveUFO);
			}
		}
		
		private function moveUFO(e:Event):void
		{
			var _UFO:BUFO = e.target as BUFO;
			_UFO.y +=  1;
		}

	}
	
}
