package 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Main extends Sprite
	{
		private var _gameEvent:GameEvent;
		public static var _matrix:BrickMatrix;
		private var _board:Board;
		private var _ball:Ball;
		private var _overText:TextField;
		private var _scoreText:TextField;
		private var _overFormat:TextFormat = new TextFormat;
		private var _bricks:Array = new Array;

		public function Main()
		{
			// constructor code
			removeChild(finishText);
			startButton.addEventListener(MouseEvent.CLICK, startGame);
		}
		private function startMenu():void{
			
		}
		
		private function init():void
		{
			_matrix = new BrickMatrix(7,7);
			_matrix.x = 30;
			_matrix.y = 30;
			addChild(_matrix);

			_board = new Board();
			_board.x = this.stage.stageWidth / 2 - _board.BOARD_WIDTH / 2;
			_board.y = this.stage.stageHeight - _board.BOARD_HEIGHT * 2;
			addChild(_board);
			
			_ball = new Ball();
			_ball.x = this.stage.stageWidth/2 - _ball.BALL_WIDTH/2;
			_ball.y = this.stage.stageHeight - _board.BOARD_HEIGHT * 2 - _ball.BALL_HEIGHT-1;
			addChild(_ball);
			
			_scoreText = new TextField();
			_scoreText.width = 200;
			_scoreText.height = 50;
			_scoreText.x = 5;
			_scoreText.y = 470;
			_scoreText.text = "Your Score:";
			_overFormat.color = 0xFFFFFF;
			_overFormat.size = 20;
			_overFormat.font = "Arial Rounded MT Bold";
			_overFormat.align = TextFormatAlign.LEFT;
			_scoreText.setTextFormat(_overFormat);
			addChild(_scoreText);
			
			
			_gameEvent = new GameEvent(this, _matrix, _board, _ball, _scoreText);
			
			_gameEvent.addEventListener(GameEvent.GAME_OVER, addOverText);
			_gameEvent.addEventListener(GameEvent.GAME_FINISH, addFinishText);
		}
		
		private function addOverText(e:Event){
			_overFormat.color = "0xFFFFFF";
			_overFormat.size = 20;
			_overFormat.font = "Arial Rounded MT Bold";
			_overFormat.align = TextFormatAlign.CENTER;
			
			_overText = new TextField();
			_overText.width = 400;
			_overText.height = 200;
			_overText.x = stage.stageWidth/2 - _overText.width/2;
			_overText.y = 300;
			_overText.text = "Game Over. Click and start a new Game"
			_overText.setTextFormat(_overFormat);
			addChild(_overText);
			_overText.addEventListener(MouseEvent.CLICK, restart);
			Mouse.show();
		}
		
		private function addFinishText(e:Event):void{
			addChild(finishText);
		}
		
		private function startGame(e:Event):void{
			init();
			removeChild(menu);
			removeChild(startButton);
		}
		
		private function restart(e:Event):void{
			clearStage();
			init();
		}
		
		private function clearStage():void{
			removeChild(_ball);
			removeChild(_matrix);
			removeChild(_board);
			removeChild(_overText);
			removeChild(_scoreText);
		}
	}

}