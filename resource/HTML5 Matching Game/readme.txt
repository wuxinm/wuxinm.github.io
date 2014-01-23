CS5413 Project2
Name: Youmeng Li
ID: 0528314
Game title: Cards Matching Game
URL: Project2_Youmeng Li/index.html

Overview:
	As a big fan of league of legends (a popular online game), I made a cards matching game which is 
	used league of legends champions picture as the surface of each card. This game is very easy as 
	other card matching games; you just need to find each pair of same picture. However, I wanted to 
	make this game has some special performances, such as animations and transitions. I this case, I 
	tried to use KineticJS to make canvas can be controlled easily and more beautiful. Not as same as 
	the card matching game which was showed in class (html+css). 

Controls:
	Game is very simple, just click any card it will be turned over, then you choose another one. 
	If they are same, you will get point and this pair will disappear. On the other hand, they 
	will turn back again.

Instructions:
	In this game, I make each card as a class. Every card has front side and back side and some 
	variables to control turning action. I use localStorage to save player¡¯s highest point. The 
	point of right guessing is 10, but if you keep finding same cards, the point will be higher 
	and higher. So, you need to remember some cards¡¯ positions and turn each pair one by one so that
	you can get higher point. When you find all the pair of cards the game will be end.

Three additions in my game:
1.canvas (kineticJS).
2.localStorage.
3.<audio>

Game testing:
	I test my game by playing several times. And I also send it to some of my friends let them to play it.

Features in the future:
	I want to add one pair of boom card. If you turn over this pair at the same time, 
	the game will be end immediately. So you need to remember the position of boom card. I can also 
	let any two cards exchange their position per 30s, this will make game a little more difficulty.
