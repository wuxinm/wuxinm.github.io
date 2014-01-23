package  {
	import flash.events.*;
	public class RedUFO extends UFO{
		
		public var _redUFO:RUFO;
		
		public function RedUFO() {
			// constructor code
			_redUFO = new RUFO();
			_redUFO.addEventListener(Event.ENTER_FRAME, appearUFO)
			_redUFO.width =0;
			_redUFO.height =0;
			addChild(_redUFO);
		}
		
		private function appearUFO(e:Event):void
		{
			var _UFO:RUFO = e.target as RUFO;
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
			var _UFO:RUFO = e.target as RUFO;
			_UFO.y +=  8;
		}

	}
	
}
