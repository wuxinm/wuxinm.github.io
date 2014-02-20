var stage = new Kinetic.Stage({
	container:'container',
	width:1320,
	height:800
});

var layer = new Kinetic.Layer();
var messageLayer = new Kinetic.Layer();
var highestPointLayer = new Kinetic.Layer();

//variables of loading pictures
var array = [];

//variables of cards
var cardArray = [];

//variables of testing matching
var checkArray = [];
var checkCount = 0;
var gameCount = 0;
var lock = false;
var points = 0;
var level = 0;

//variables of initCardsPosition
var initArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]; 

//sounds
var bgm = new Audio("sounds/bgm.mp3");
bgm.loop = true;
bgm.volume = 0.4;
var correctSound = new Audio("sounds/correct.mp3");
var wrongSound = new Audio("sounds/wrong.mp3");
var doubleSound = new Audio("sounds/double.mp3");
var tripleSound = new Audio("sounds/triple.mp3");
var quadraSound = new Audio("sounds/quadra.mp3");
var pentaSound = new Audio("sounds/penta.mp3");

//spriteSheet
var animations = {
	normal:[{
		x:0,
		y:225,
		width:150,
		height:350
	},{
		x:150,
		y:225,
		width:150,
		height:350
	},{
		x:300,
		y:225,
		width:150,
		height:350
	},{
		x:450,
		y:225,
		width:150,
		height:350
	},{
		x:600,
		y:225,
		width:150,
		height:350
	},{
		x:750,
		y:225,
		width:150,
		height:350
	},{
		x:900,
		y:225,
		width:150,
		height:350
	},{
		x:1050,
		y:225,
		width:150,
		height:350
	},{
		x:1200,
		y:225,
		width:150,
		height:350
	},{
		x:1350,
		y:225,
		width:150,
		height:350
	}
	]
};

var ss;
var spriteSheet = new Image();
spriteSheet.src = 'images/spriteSheet.jpg';
spriteSheet.onload = function(){
	ss = new Kinetic.Sprite({
		x:280,
		y:120,
		image:spriteSheet,
		animation:'normal',
		animations:animations,
		frameRate: 1
	});
	
	layer.add(ss);
	ss.start();
};

window.addEventListener('load', function () { 
	writeMessage(messageLayer, 'Points: ' + points);
	if(localStorage.highestPoint){
		writeHighestPoint(highestPointLayer,'HighestPoint: ' + localStorage.highestPoint.toString());
	}
	else{
		localStorage.highestPoint = 0;
		writeHighestPoint(highestPointLayer,'HighestPoint: ' + localStorage.highestPoint.toString());
	}
	
});

//gameStart
$(document).ready(function(){
	bgm.play();
	$("#startButton").bind("click", function(){
		//loading animation
		ss.stop();
		ss.destroy();
		$("#startButton").removeClass("start").addClass("started");
		$(".title").removeClass("title").addClass("titleStart");
		var yellowRect = new Kinetic.Rect({
			x: 400,
			y: 375,
			width: 100,
			height: 20,
			fill: 'yellow',
			stroke: 'black',
			strokeWidth: 4,
			offset: [50, 50]
        });
		var simpleText = new Kinetic.Text({
			x: 500,
			y: 350,
			text: 'Loading...',
			fontSize: 30,
			fontFamily: 'Calibri',
			fill: 'yellow'
		});
		layer.add(simpleText);
		layer.add(yellowRect);
		var anim = new Kinetic.Animation(function(frame) {
			var angleDiff = frame.timeDiff * Math.PI / 1000;
			yellowRect.rotate(angleDiff);
        }, layer);
		anim.start();
		
		//loading pictures from folder
		function loadPics(){
			if(index > 40){
				clearInterval(timer);
				anim.stop();
				simpleText.destroy();
				yellowRect.destroy();
				buildCardMatrix();
				return;
			}
			var img_back = new Image();
			img_back.src = 'images/back.png';
			var img_front = new Image();
			img_front.src = 'images/' + (index) + '.png';
	
			array.push(img_back);
			array.push(img_front);
			index ++;
		}
		var index = 1;
		var timer = setInterval(loadPics,100);
	
	});
});

//initGame
function buildCardMatrix(){
	var index = 1;
	var initTimer = setInterval(init, 100);
	
	function init(){
	if(index > 40){
		clearInterval(initTimer);
		for(var i = 0;i<=cardArray.length-1;i++){
			turnOver(cardArray[i]);
		}
		initPosition();
		return;
	}
	
	var card = new Card(index);
	cardArray.push(card);
	
	if(index >= 1 && index < 11){
		card.cardBack.setPosition(index*120, 140);
		card.cardFront.setPosition(index*120, 140);
	}
	else if(index >= 11 && index < 20){
		card.cardBack.setPosition((index%10)*120, 260);
		card.cardFront.setPosition((index%10)*120, 260);
	}
	else if(index == 20){
		card.cardBack.setPosition(1200, 260);
		card.cardFront.setPosition(1200, 260);
	}
	else if(index >= 21 && index < 30){
		card.cardBack.setPosition((index%20)*120, 380);
		card.cardFront.setPosition((index%20)*120, 380);
	}
	else if(index == 30){
		card.cardBack.setPosition(1200, 380);
		card.cardFront.setPosition(1200, 380);
	}
	else if(index >= 31 && index < 40){
		card.cardBack.setPosition((index%30)*120, 500);
		card.cardFront.setPosition((index%30)*120, 500);
	}
	else if(index == 40){
		card.cardBack.setPosition(1200, 500);
		card.cardFront.setPosition(1200, 500);
	}
	card.cardFront.on('click',function(){
	});
	card.cardBack.on('click',function(){
		if(!lock){
			turnOver(card);
			checkArray.push(card);
			checkCount ++;
		}
	});
	layer.add(card.cardBack);
	layer.draw();
	layer.add(card.cardFront);
	layer.draw();
	index ++;
	}
}

function initPosition(){
	var testIndex = 1;
	var initTimer = setInterval(init,100);
	function init(){
	if(testIndex > 20){
		clearInterval(initTimer);
		return
	}
	var random = parseInt(Math.random()*initArray.length);
	var cardNum1 = initArray[random];
	var pickFirstCard = cardArray[cardNum1];
	initArray.splice(random, 1);
	random = parseInt(Math.random()*initArray.length);
	var cardNum2 = initArray[random];
	var pickSecondCard = cardArray[cardNum2];
	initArray.splice(random, 1);
	changePosition(pickFirstCard, pickSecondCard);
	testIndex ++;
	}
}

function Card(index){
	this.scale = 1;
	this.turnOver = false;
	this.backUp = false;
	this.cardUp = true;
	
	if(index%2 == 1){
		this.name = index.toString();
	}
	else{
		this.name = (index-1).toString();
	}
	
	this.cardBack = new Kinetic.Image({
		image:array[2*index-2],
		offset:[50,50],
		width:100,
		height:100,
		stroke:'black',
		strokeWidth:4,
	});
	this.cardFront = new Kinetic.Image ({
		image:array[2*index-1],
		offset:[50,50],
		width:100,
		height:100,
		stroke:'black',
		strokeWidth:4,
	});
	this.anim = new Kinetic.Animation(function(frame){
		if(!this.turnOver){
			this.scale = this.scale - 0.1;
		}
		else{
			scale = scale + 0.1;
		}
		console.log(this.cardFront);
		this.cardFront.setScale(1,scale);
		this.cardBack.setScale(1,scale);
				
		if(scale <= 0.00001){
			if(cardUp){
				this.cardFront.hide();
				this.cardBack.show();
				turnOver = true;
				backUp = true;
				cardUp = false;
			}
			else if(backUp){
				this.cardFront.show();
				this.cardBack.hide();
				turnOver = true;
				backUp = false;
				cardUp = true;
			}
		}
		else if(scale >= 0.9999){
			if(backUp){
				anim.stop();
				turnOver = false;
			}
			else if(cardUp){
				anim.stop();
				turnOver = false;
			}	
		}
	}, layer);
}

//turnOver one card
function turnOver(card){
	var anim = new Kinetic.Animation(function(frame){
		if(!card.turnOver){
			card.scale = card.scale - 0.1;
		}
		else{
			card.scale = card.scale + 0.1;
		}
		card.cardFront.setScale(1,card.scale);
		card.cardBack.setScale(1,card.scale);
				
		if(card.scale <= 0.00001){
			if(card.cardUp){
				card.cardFront.hide();
				card.cardBack.show();
				card.turnOver = true;
				card.backUp = true;
				card.cardUp = false;
			}
			else if(card.backUp){
				card.cardFront.show();
				card.cardBack.hide();
				card.turnOver = true;
				card.backUp = false;
				card.cardUp = true;
			}
		}
		else if(card.scale >= 0.9999){
			if(card.backUp){
				anim.stop();
				card.turnOver = false;
			}
			else if(card.cardUp){
				anim.stop();
				if(checkCount == 2){
					lock = true;
					setTimeout(function(){checkMatching(checkArray[0], checkArray[1]);},100);
				}
				card.turnOver = false;
			}	
		}
	}, layer);
	anim.start();
}

//checking a pair of cards whether they are matched
function checkMatching(card1, card2){
	card1.cardFront.setRotation(0);
	card2.cardFront.setRotation(0);
	card1.cardFront.transitionTo({
		rotation:Math.PI*2,
		scale:{x:1.3, y:1.3},
		duration:0.5,
		easing:'ease-in-out'
	});
	card2.cardFront.transitionTo({
		rotation:Math.PI*2,
		scale:{x:1.3, y:1.3},
		duration:0.5,
		easing:'ease-in-out'
	});
	if(card1.name == card2.name){
		setTimeout(function(){
			card1.cardFront.transitionTo({
				opacity:0,
				duration:0.5,
				easing:'ease-in-out'
			});
			card2.cardFront.transitionTo({
				opacity:0,
				duration:0.5,
				easing:'ease-in-out'
			});
			setTimeout(function(){
				card1.cardBack.remove();
				card1.cardFront.remove();
				card2.cardBack.remove();
				card2.cardFront.remove();
				lock = false;
				if(gameCount == 20){
					if(points > localStorage.highestPoint){
						alert("Congratulation!!!\nNew record is: " + points + "\nReload to restart.");
						localStorage.highestPoint = points;
					}
					else{
						alert("Finish!!!\nYour Point is: " + points + "\nReload to restart.");
					}
				}
			}, 500);
		}, 500);
		if(level == 0){
			points = points + 10;
			writeMessage(messageLayer, 'Points: ' + points);
			level ++;
			correctSound.play();
		}
		else if(level == 1){
			points = points + 20;
			writeMessage(messageLayer, 'Points: ' + points);
			level ++;
			doubleSound.play();
		}
		else if(level == 2){
			points = points + 40;
			writeMessage(messageLayer, 'Points: ' + points);
			level ++;
			tripleSound.play();
		}
		else if (level == 3){
			points = points + 80;
			writeMessage(messageLayer, 'Points: ' + points);
			level ++;
			quadraSound.play();
		}
		else if (level > 3){
			points = points + 150;
			writeMessage(messageLayer, 'Points: ' + points);
			level ++;
			pentaSound.play();
		}
		checkArray.pop();
		checkArray.pop();
		checkCount = 0;
		gameCount ++;
	}
	else{
		setTimeout(function(){
			card1.cardFront.transitionTo({
				scale:{x:1, y:1},
				duration:0.5,
				easing:'ease-in-out'
			});
			card2.cardFront.transitionTo({
				scale:{x:1, y:1},
				duration:0.5,
				easing:'ease-in-out'
			});
			setTimeout(function(){
				turnOver(card1);
				turnOver(card2);
				lock = false;
			}, 500);
		}, 500);
		wrongSound.play();
		level = 0;
		checkArray.pop();
		checkArray.pop();
		checkCount = 0;
	}
}

//exchange two cards position
function changePosition(card1, card2){
	var tempX = card1.cardBack.getX();
	var tempY = card1.cardBack.getY();
	
	card1.cardBack.transitionTo({
		rotation:Math.PI*2,
		x:card2.cardBack.getX(),
		y:card2.cardBack.getY(),
		duration:1,
		easing:'ease-in-out'
	});
	card1.cardFront.transitionTo({
		rotation:Math.PI*2,
		x:card2.cardFront.getX(),
		y:card2.cardFront.getY(),
		duration:1,
		easing:'ease-in-out'
	});
	card2.cardBack.transitionTo({
		rotation:Math.PI*2,
		x:tempX,
		y:tempY,
		duration:1,
		easing:'ease-in-out'
	});
	card2.cardFront.transitionTo({
		rotation:Math.PI*2,
		x:tempX,
		y:tempY,
		duration:1,
		easing:'ease-in-out'
	});
}

//set text on messageLayer
function writeMessage(messageLayer, message) {
    var context = messageLayer.getContext();
    messageLayer.clear();
    context.font = '30pt Elephant';
    context.fillStyle = '#E59900';
    context.fillText(message, 70, 60);
};

//set text on highestPointLayer
function writeHighestPoint(highestPointLayer, message) {
    var context = highestPointLayer.getContext();
    highestPointLayer.clear();
    context.font = '30pt Elephant';
    context.fillStyle = '#E59900';
    context.fillText(message, 850, 60);
};

stage.add(layer);
stage.add(messageLayer);
stage.add(highestPointLayer);