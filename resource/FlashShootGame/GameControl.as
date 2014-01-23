package 
{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.text.engine.EastAsianJustifier;

	public class GameControl extends Sprite
	{
		public static const GAMEOVER:String = "gameover";
		private var _isShooting:Boolean = false;
		private var _leftPressed:Boolean = false;
		private var _rightPressed:Boolean = false;
		private var _enhancing:Boolean = false;
		private var _timeTween:int = 2000;
		private var _stage:MovieClip;
		private var _UFOTimer:Timer;
		private var _bombTimer:Timer;
		private var _bossUFO:BossUFO;
		private var _gameTimer:Timer;
		private var _gameTimeText:TextField;
		private var _timeCount:uint = 0;
		public var _bangTimer:Timer = new Timer(1000);
		private var _enhancingTimer:Timer;
		private var _enhancingTime:int = 5;
		private var _cannon:Cannon;
		private var _UFOArray:Array = new Array();
		private var _bulletArray:Array = new Array();
		private var _bangArray:Array = new Array();
		private var _bombArray:Array = new Array();
		private var _bang:Bang;
		private var _HP:int = 10;
		private var _HPText:TextField;
		private var _changeTime:Boolean = true;
		private var _direction:Boolean = true;
		private var _protection:Boolean = false;
		private var _randomBossX:int;
		private var _protectTimer:Timer;
		private var _maxLeft:Boolean = true;
		private var _maxRight:Boolean = true;


		public function GameControl(_stage:MovieClip, _gameTimeText:TextField, _HPText:TextField)
		{
			// constructor code
			this._stage = _stage;
			this._gameTimeText = _gameTimeText;
			this._HPText = _HPText;

			addCannon();
			setHP();

			_stage.stage.addEventListener(Event.ENTER_FRAME, explosion);
			_stage.stage.addEventListener(Event.ENTER_FRAME, keyboardControl);
			_stage.stage.addEventListener(Event.ENTER_FRAME, refreshHP);

			_UFOTimer = new Timer(_timeTween);
			_UFOTimer.addEventListener(TimerEvent.TIMER, addUFO);
			_UFOTimer.start();

			_gameTimer = new Timer(100);
			_gameTimer.addEventListener(TimerEvent.TIMER, timeCount);
			_gameTimer.start();

			_bangTimer.addEventListener(TimerEvent.TIMER, removeBang);
			_bangTimer.start();

			_protectTimer = new Timer(2000);
			_protectTimer.addEventListener(TimerEvent.TIMER, protectTime);
		}

		//addUFO to stage
		private function addUFO(e:Event):void
		{
			var _randomX:int = Math.random() * 850;
			var _randomY:int = Math.random() * 150;
			var _randomNum:uint = Math.random() * 100;
			if (_randomNum> 40&& _randomNum <= 100)
			{
				var _greenUFO:GreenUFO = new GreenUFO();
				_greenUFO.x = _randomX;
				_greenUFO.y = _randomY;
				_UFOArray.push(_greenUFO);
				_stage.addChild(_greenUFO);
			}
			else if (_randomNum>=0 && _randomNum <= 15)
			{
				var _redUFO:RedUFO = new RedUFO();
				_redUFO.x = _randomX;
				_redUFO.y = _randomY;
				_UFOArray.push(_redUFO);
				_stage.addChild(_redUFO);
			}
			else if (_randomNum> 15 && _randomNum <= 40)
			{
				var _blueUFO:BlueUFO = new BlueUFO();
				_blueUFO.x = _randomX;
				_blueUFO.y = _randomY;
				_UFOArray.push(_blueUFO);
				_stage.addChild(_blueUFO);
			}
		}

		//timeCount and improve speed of appearing UFO
		private function timeCount(e:Event):void
		{
			_timeCount +=  100;
			_gameTimeText.text = "Time: "+(int)(_timeCount/60000)+":"+(int)((_timeCount % 60000) / 1000)+":"+(int)((_timeCount%1000)/100);
			if (_timeCount >= 20000&&_timeCount < 40000)
			{
				if (_changeTime)
				{
					_UFOTimer.delay = 1500;
					_changeTime = false;
				}
			}
			if (_timeCount == 40000)
			{
				_changeTime = true;
			}
			if (_timeCount > 40000&&_timeCount < 70000)
			{
				if (_changeTime)
				{
					_UFOTimer.delay = 1000;
					_bangTimer.delay = 700;
					_changeTime = false;
				}
			}
			if (_timeCount == 70000)
			{
				_changeTime = true;
			}
			if (_timeCount > 70000&&_timeCount < 120000)
			{
				if (_changeTime)
				{
					_UFOTimer.delay = 500;
					_bangTimer.delay = 200;
					_changeTime = false;
				}
			}
			if (_timeCount == 120000)
			{
				_UFOTimer.stop();
				_UFOTimer.removeEventListener(TimerEvent.TIMER, addUFO);
				_randomBossX = Math.random() * 850;
				_bossUFO = new BossUFO();
				_bossUFO.x = _randomBossX;
				_bossUFO.y = 10;
				_bossUFO.addEventListener(BossUFO.START, addBossUFO);
				_stage.addChild(_bossUFO);

				_bombTimer = new Timer(1000);
				_bombTimer.addEventListener(TimerEvent.TIMER, addBomb);
				_bombTimer.start();
			}
		}

		//remove bang logo from stage
		private function removeBang(e:Event):void
		{
			var _i:int;
			if (_bangArray[0] != null)
			{
				_stage.removeChild(_bangArray[0]);
				_bangArray.splice(0, 1);
			}
		}

		//addCannon to stage
		private function addCannon():void
		{
			_cannon = new Cannon();
			_cannon.x = _stage.stage.stageWidth / 2 - 40;
			_cannon.y = _stage.stage.stageHeight - 95;
			_stage.addChild(_cannon);
			_stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandlerDown);
			_stage.stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandlerUp);
		}

		private function setHP():void
		{
			_HPText.text = "HP: " + _HP.toString() + "/10";
		}

		private function refreshHP(e:Event):void
		{
			for (var _i:int = 0; _i<_UFOArray.length; _i++)
			{
				if (_UFOArray[_i].hitTestObject(_stage.endline))
				{
					_stage.removeChild(_UFOArray[_i]);
					_UFOArray.splice(_i, 1);
					_HP -=  1;
					if (_HP != 0)
					{
						_stage.hpBar.width -=  10;
						setHP();
					}
					else
					{
						_stage.hpBar.width -=  10;
						setHP();
						gameOver();
						if (_UFOArray[0] != null)
						{
							var _count:int = 0;
							for (var _m:int = 0; _m< _UFOArray.length; _m++)
							{
								_stage.removeChild(_UFOArray[_m]);
								_count +=  1;
							}
							_UFOArray.splice(0, _count);
						}
						_stage.removeChild(_cannon);
						dispatchEvent(new Event(GAMEOVER));
					}
				}
			}

			for (var _j:int = 0; _j<_bombArray.length; _j++)
			{
				if (_bombArray[_j].hitTestObject(_stage.endline))
				{
					_stage.removeChild(_bombArray[_j]);
					_bombArray.splice(_j,1);
					_HP -=  1;
					if (_HP != 0)
					{
						_stage.hpBar.width -=  10;
						setHP();
					}
					else
					{
						_stage.hpBar.width -=  10;
						setHP();
						gameOver();
						_bombTimer.stop();
						_bombTimer.removeEventListener(TimerEvent.TIMER, addBomb);
						_stage.removeChild(_bossUFO);
						if (_bombArray[0] != null)
						{
							_count = 0;
							for (var _n:int = 0; _n< _bombArray.length; _n++)
							{
								_stage.removeChild(_bombArray[_n]);
								_count +=  1;
							}
							_bombArray.splice(0, _count);
						}
						_stage.removeChild(_cannon);
						dispatchEvent(new Event(GAMEOVER));
					}
				}
			}
		}

		//Cannnon control
		private function keyboardHandlerDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.SPACE :
					{
						_isShooting = true;
						break;

					};
				case Keyboard.LEFT :
					{
						_leftPressed = true;
						break;

					};
				case Keyboard.RIGHT :
					{
						_rightPressed = true;
						break;

				}
			}
		};

		//Cannon control
		private function keyboardHandlerUp(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.SPACE :
					{
						_isShooting = false;
						break;

					};
				case Keyboard.LEFT :
					{
						_leftPressed = false;
						break;

					};
				case Keyboard.RIGHT :
					{
						_rightPressed = false;
						break;

				}
			}
		};

		//moveBossUFO
		private function addBossUFO(e:Event):void
		{
			_bossUFO.addEventListener(Event.ENTER_FRAME, moveBossUFO);
		}
		private function moveBossUFO(e:Event):void
		{
			var _bossUFO:BossUFO = e.target as BossUFO;
			if (_direction)
			{
				_bossUFO.x +=  10;
				if (_bossUFO.x >= 650)
				{
					_direction = false;
				}
			}
			else
			{
				_bossUFO.x -=  10;
				if (_bossUFO.x <= 0)
				{
					_direction = true;
				}
			}
		}

		//bombmove
		private function addBomb(e:Event):void
		{
			var _bomb:Bomb = new Bomb();
			_bomb.x = _bossUFO.x + 100;
			_bomb.y = 110;
			_bombArray.push(_bomb);
			_stage.addChild(_bomb);
		}

		//protectBoss
		private function protectTime(e:Event):void
		{
			_protection = false;
			_protectTimer.stop();
			_bossUFO._bossUFO.gotoAndStop(_bossUFO._count + 1);
		}

		//collision of UFO and bullet;
		private function explosion(e:Event):void
		{
			if (_UFOArray[0] != null)
			{
				for (var _i:uint=0; _i<_UFOArray.length; _i++)
				{
					for (var _j:uint=0; _j<_bulletArray.length; _j++)
					{
						if (_UFOArray[_i].hitTestObject(_bulletArray[_j]))
						{
							var _num:int = Math.random() * 10;
							if (_UFOArray[_i].toString() == "[object BlueUFO]")
							{
								if (_UFOArray[_i]._count == 3)
								{
									_bang = new Bang();
									_bang.x = _bulletArray[_j].x - 20;
									_bang.y = _bulletArray[_j].y - 20;
									_bang.width = 60;
									_bang.height = 60;
									_stage.addChild(_bang);
									_bangArray.push(_bang);
									_stage.removeChild(_UFOArray[_i]);
									_stage.removeChild(_bulletArray[_j]);
									delete (_UFOArray[_i]);
									delete (_bulletArray[_j]);
									_UFOArray.splice(_i, 1);
									_bulletArray.splice(_j, 1);
									break;
								}

								_UFOArray[_i]._count +=  1;
								_UFOArray[_i]._blueUFO.gotoAndStop(_UFOArray[_i]._count + 1);
								_stage.removeChild(_bulletArray[_j]);
								_bulletArray.splice(_j, 1);
								break;

							}
							else
							{
								if (_num==0)
								{
									var _eBall:EnhancingBall = new EnhancingBall();
									_eBall.x = _bulletArray[_j].x;
									_eBall.y = _bulletArray[_j].y;
									_stage.addChild(_eBall);
									_eBall.addEventListener(Event.ENTER_FRAME, eBallMove);
								}
								else if (_num==1)
								{
									var _bBall:BangBall = new BangBall();
									_bBall.x = _bulletArray[_j].x;
									_bBall.y = _bulletArray[_j].y;
									_stage.addChild(_bBall);
									_bBall.addEventListener(Event.ENTER_FRAME, bBallMove);
								}
								else if (_num==2)
								{
									var _hBall:HPBall = new HPBall();
									_hBall.x = _bulletArray[_j].x;
									_hBall.y = _bulletArray[_j].y;
									_stage.addChild(_hBall);
									_hBall.addEventListener(Event.ENTER_FRAME, hBallMove);
								}
								_bang = new Bang();
								_bang.x = _bulletArray[_j].x - 20;
								_bang.y = _bulletArray[_j].y - 20;
								_bang.width = 60;
								_bang.height = 60;
								_stage.addChild(_bang);
								_bangArray.push(_bang);
								_stage.removeChild(_UFOArray[_i]);
								_stage.removeChild(_bulletArray[_j]);
								delete (_UFOArray[_i]);
								delete (_bulletArray[_j]);
								_UFOArray.splice(_i, 1);
								_bulletArray.splice(_j, 1);
								break;
							}
						}

					}
				}
			}
			if (_bombArray[0] != null)
			{
				for (var _m:uint=0; _m<_bombArray.length; _m++)
				{
					for (var _n=0; _n<_bulletArray.length; _n++)
					{
						if (_bombArray[_m].hitTestObject(_bulletArray[_n]))
						{
							_bang = new Bang();
							_bang.x = _bulletArray[_n].x - 20;
							_bang.y = _bulletArray[_n].y - 20;
							_bang.width = 60;
							_bang.height = 60;
							_stage.addChild(_bang);
							_bangArray.push(_bang);
							_stage.removeChild(_bombArray[_m]);
							_stage.removeChild(_bulletArray[_n]);
							delete (_bombArray[_m]);
							delete (_bulletArray[_n]);
							_bombArray.splice(_m, 1);
							_bulletArray.splice(_n, 1);
							break;
						}
						if (_bulletArray[_n].hitTestObject(_bossUFO))
						{
							if (_bossUFO._count == 9)
							{
								_bossUFO._bossUFO.gotoAndStop(10);
								_bossUFO.removeEventListener(Event.ENTER_FRAME, moveBossUFO);
								_stage.removeChild(_bulletArray[_n]);
								delete (_bulletArray[_n]);
								_bulletArray.splice(_n, 1);
								finishGame();
								break;
							}
							if (! _protection)
							{
								_bossUFO._count +=  1;
								_bossUFO._bossUFO.gotoAndStop(11);
								_stage.removeChild(_bulletArray[_n]);
								_bulletArray.splice(_n, 1);
								_protection = true;
								_protectTimer.start();
								break;
							}
						}
					}
				}
			}

		}

		//Event of enhancing ball
		private function eBallMove(e:Event):void
		{
			var _eBall:EnhancingBall = e.target as EnhancingBall;
			_eBall.y +=  7;
			if (_eBall.hitTestObject(_cannon))
			{
				_stage.removeChild(_eBall);
				_eBall.removeEventListener(Event.ENTER_FRAME, eBallMove);
				_stage.stage.removeEventListener(Event.ENTER_FRAME, keyboardControl);
				_stage.stage.addEventListener(Event.ENTER_FRAME, keyboardEnhancingControl);
				if (! _enhancing)
				{
					_enhancingTimer = new Timer(1000);
					_enhancingTimer.addEventListener(TimerEvent.TIMER, enhancingTime);
					_enhancingTimer.start();
					_enhancing = true;
					_stage.addChild(_stage.enhancingLabel);
					_stage.addChild(_stage.enhancingBar);
				}
			}
		}

		//event of bang ball
		private function bBallMove(e:Event):void
		{
			var _bBall:BangBall = e.target as BangBall;
			var _count:int = 0;
			_bBall.y +=  10;
			if (_bBall.hitTestObject(_cannon))
			{
				_stage.removeChild(_bBall);
				_bBall.removeEventListener(Event.ENTER_FRAME, bBallMove);
				if (_UFOArray[0] != null)
				{
					for (var _i:int = 0; _i< _UFOArray.length; _i++)
					{
						_stage.removeChild(_UFOArray[_i]);
						_count +=  1;
					}
					_UFOArray.splice(0, _count);
				}
				_bang = new Bang();
				_bang.x = 300;
				_bang.y = 100;
				_bang.width = 300;
				_bang.height = 300;
				_stage.addChild(_bang);
				_bangArray.push(_bang);
			}

		}

		//event of health ball
		private function hBallMove(e:Event):void
		{
			var _hBall:HPBall = e.target as HPBall;
			_hBall.y +=  7;
			if (_hBall.hitTestObject(_cannon))
			{
				_stage.removeChild(_hBall);
				_hBall.removeEventListener(Event.ENTER_FRAME, hBallMove);
				if (_HP != 10)
				{
					_HP +=  1;
					_stage.hpBar.width +=  10;
					setHP();
				}
			}
		}

		//time of cannon enhancing
		private function enhancingTime(e:Event):void
		{
			_enhancingTime -=  1;
			_stage.enhancingBar.width -=  30;
			if (_enhancingTime == 0)
			{
				_enhancingTimer.stop();
				_enhancingTimer.reset();
				_enhancingTimer.removeEventListener(TimerEvent.TIMER, enhancingTime);
				_stage.stage.removeEventListener(Event.ENTER_FRAME, keyboardEnhancingControl);
				_stage.stage.addEventListener(Event.ENTER_FRAME, keyboardControl);
				_enhancingTime = 5;
				_enhancing = false;
				_stage.enhancingBar.width = 150;
				_stage.removeChild(_stage.enhancingLabel);
				_stage.removeChild(_stage.enhancingBar);
			}
		}

		private function keyboardControl(e:Event):void
		{
			if (_isShooting)
			{
				var _bullet:Bullet = new Bullet();
				_bullet.x = _cannon.x + 35;
				_bullet.y = _cannon.y - 5;
				_stage.addChild(_bullet);
				_bulletArray.push(_bullet);
				_bullet.addEventListener(Event.ENTER_FRAME, bulletMove);
				_isShooting = false;
			}
			if (_leftPressed)
			{
				_maxRight = true;
				if (_maxLeft)
				{
					_cannon.x -=  7;
					if (_cannon.x <= 3)
					{
						_maxLeft = false;
					}
				}
			}
			if (_rightPressed)
			{
				_maxLeft = true;
				if (_maxRight)
				{
					_cannon.x +=  7;
					if (_cannon.x >= 817)
					{
						_maxRight = false;
					}
				}
			}
		}

		private function keyboardEnhancingControl(e:Event):void
		{
			if (_isShooting)
			{
				var _bullet:Bullet = new Bullet();
				_bullet.x = _cannon.x + 35;
				_bullet.y = _cannon.y - 5;
				_stage.addChild(_bullet);
				_bulletArray.push(_bullet);
				_bullet.addEventListener(Event.ENTER_FRAME, bulletMove);

				_bullet= new Bullet();
				_bullet.x = _cannon.x + 35;
				_bullet.y = _cannon.y - 5;
				_stage.addChild(_bullet);
				_bulletArray.push(_bullet);
				_bullet.addEventListener(Event.ENTER_FRAME, bulletMove1);

				_bullet = new Bullet();
				_bullet.x = _cannon.x + 35;
				_bullet.y = _cannon.y - 5;
				_stage.addChild(_bullet);
				_bulletArray.push(_bullet);
				_bullet.addEventListener(Event.ENTER_FRAME, bulletMove2);
				_isShooting = false;
			}
			if (_leftPressed)
			{
				_cannon.x -=  7;
				if (_cannon.x <= 20)
				{
					_leftPressed = false;
				}
			}
			if (_rightPressed)
			{
				_cannon.x +=  7;
				if (_cannon.x >= 900)
				{
					_rightPressed = false;
				}
			}
		}

		//bulletmove
		private function bulletMove(e:Event):void
		{
			var _bullet:Bullet = e.target as Bullet;
			_bullet.y -=  5;
		}

		private function bulletMove1(e:Event):void
		{
			var _bullet:Bullet = e.target as Bullet;
			_bullet.y -=  5;
			_bullet.x -=  2;
			//if(_bullet.x <= 0){
			//_stage.removeChild(_bullet);
			//}
		}

		private function bulletMove2(e:Event):void
		{
			var _bullet:Bullet = e.target as Bullet;
			_bullet.y -=  5;
			_bullet.x +=  2;
		}

		//finishGame
		private function gameOver():void
		{
			_stage.stage.removeEventListener(Event.ENTER_FRAME, explosion);
			_stage.stage.removeEventListener(Event.ENTER_FRAME, keyboardControl);
			_stage.stage.removeEventListener(Event.ENTER_FRAME, refreshHP);
			_UFOTimer.stop();
			_gameTimer.stop();
			_bangTimer.stop();
		}

		private function finishGame():void
		{
			_stage.stage.removeEventListener(Event.ENTER_FRAME, explosion);
			_stage.stage.removeEventListener(Event.ENTER_FRAME, keyboardControl);
			_stage.stage.removeEventListener(Event.ENTER_FRAME, refreshHP);
			_gameTimer.stop();
			_bangTimer.stop();
			_bombTimer.stop();
			_stage.addChild(_stage.finishText);
		}
	}

}