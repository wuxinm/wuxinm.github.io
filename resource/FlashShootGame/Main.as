package  {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Main extends MovieClip{
		
		private var _gameC:GameControl;
		private var _gUFO:GreenUFO;
		private var _gameTimeText:TextField;
		private var _HPText:TextField;
		private var _format:TextFormat;
		
		public function Main() {
			// constructor code
			gotoAndStop(2);
			startButton.addEventListener(MouseEvent.CLICK, startGame);
			introButton.addEventListener(MouseEvent.CLICK, introGame);
			
		}
		
		private function startGame(e:MouseEvent):void{
			gotoAndStop(1);
			init();
		}
		
		private function introGame(e:MouseEvent):void{
			gotoAndStop(3);
			returnButton.addEventListener(MouseEvent.CLICK, returnMain);
		}
		
		private function returnMain(e:MouseEvent):void{
			gotoAndStop(2);
			startButton.addEventListener(MouseEvent.CLICK, startGame);
			introButton.addEventListener(MouseEvent.CLICK, introGame);
		}
		
		private function init():void{
			removeComponents()
			
			_format = new TextFormat();
			_format.size = 18;
			_format.leftMargin = 15;
			_format.color = "0xFFFFFF";
			_format.font = "Arial Rounded MT Bold";
			
			newText()
			
			_gameC = new GameControl(this, _gameTimeText, _HPText);
			_gameC.addEventListener(GameControl.GAMEOVER, gameOver);
		}
		
		private function gameOver(e:Event):void{
			addChild(gameOverText);
			addChild(restartButton);
			restartButton.addEventListener(MouseEvent.CLICK, restartGame);
		}
		
		private function restartGame(e:MouseEvent):void{
			removeChild(_gameTimeText);
			removeChild(_HPText);
			removeChild(gameOverText);
			removeChild(restartButton);
			
			newText()
			hpBar.width = 100;
			
			_gameC = new GameControl(this, _gameTimeText, _HPText);
			_gameC.addEventListener(GameControl.GAMEOVER, gameOver);
			
		}
		
		private function newText():void{
			_gameTimeText = new TextField();
			_gameTimeText.x = 750;
			_gameTimeText.y = 15;
			_gameTimeText.width = 130;
			_gameTimeText.height = 30;
			_gameTimeText.defaultTextFormat = _format;
			addChild(_gameTimeText);
			
			_HPText = new TextField();
			_HPText.x = 650;
			_HPText.y = 45;
			_HPText.width = 110;
			_HPText.height = 30;
			_HPText.defaultTextFormat = _format;
			addChild(_HPText);
		}
		
		private function removeComponents():void{
			removeChild(greenUFO);
			removeChild(redUFO);
			removeChild(blueUFO);
			removeChild(bossUFO);
			removeChild(cannon);
			removeChild(bullet);
			removeChild(eBall);
			removeChild(enhancingLabel);
			removeChild(enhancingBar);
			removeChild(bang);
			removeChild(bBall);
			removeChild(hBall);
			removeChild(bomb);
			removeChild(gameOverText);
			removeChild(finishText);
			removeChild(restartButton);
		}
	}
	
}
