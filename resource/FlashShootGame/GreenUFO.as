package 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.MovieClip;

	public class GreenUFO extends UFO
	{
		public var _greenUFO:GUFO;
		private var _stage:MovieClip;

		public function GreenUFO()
		{
			// constructor code
			_greenUFO = new GUFO();
			_greenUFO.addEventListener(Event.ENTER_FRAME, appearUFO);
			_greenUFO.width = 0;
			_greenUFO.height = 0;
			addChild(_greenUFO);
		}

		private function appearUFO(e:Event):void
		{
			var _UFO:GUFO = e.target as GUFO;
			_UFO.width +=  3.5;
			_UFO.height +=  2;
			if (_UFO.width == 70)
			{
				_UFO.removeEventListener(Event.ENTER_FRAME, appearUFO);
				_UFO.addEventListener(Event.ENTER_FRAME, moveUFO);
			}
		}

		public static function moveUFO(e:Event):void
		{
			var _UFO:GUFO = e.target as GUFO;
			_UFO.y +=  2.5;
		}

	}

}