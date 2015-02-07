import java.util.*;
boolean unlocked;

int[] tape = new int[8];
int[] keys = new int[4];
int pos = tape.length;

void setup() {
	size(500,500,OPENGL);
	textMode(CENTER);
	rectMode(CENTER);
	noFill();
	stroke(255);
	for(int i = 0; i < 11; i++)
	{
		incrementKeys();
	}
}

void draw() {
	background(0);
	translate(width/2,height/2);
	drawKey();
	drawTape();
	checkWin();
}

void incrementKeys(){
	keys[keys.length - 1]++;
	for(int i = keys.length - 1; i >= 0; i--)
	{
		if(keys[i] == 2 && i > 0)
		{
			keys[i] = 0;
			keys[i-1]++;
		}
	}
}

void checkWin(){
	for(int i = 0; i < tape.length; i++)
	{
		if(tape[i] == 0)
			return;
	}
	incrementKeys();
	restart();
}

void drawTape(){
	for(int i = 0; i < tape.length; i++)
	{
		rect(lerp(-100,100, i/7f), 0, 25,25);
		text("" + tape[i], lerp(-100,100, i/7f), 0);
	}
}

void drawKey(){
	for(int i = 0; i < keys.length; i++)
	{
		rect(lerp(-100,100, (i + pos)/7f), -25, 25,25);
		text("" + keys[i], lerp(-100,100, (i + pos)/7f), -25);
	}
}

void move(int dir){
	pos += dir;
	if(pos < tape.length - keys.length)
	{
		if(tape[pos + keys.length] == 0)
		{
			pos -= dir;
		}
	}
	pos = constrain(pos, 0, tape.length);
}

void flip(){
	for(int i = 0; i < keys.length && i + pos < tape.length; i++)
	{
		if(keys[i] != tape[i + pos])
			return;
	}
	if(pos == 0)
		return;
	tape[pos - 1] = tape[pos - 1] == 0? 1 : 0;
}

void restart(){
	pos = tape.length;
	tape = new int[tape.length];
}

void keyPressed(){
	if(key == 'r')
	{
		restart();
	}
	else if(keyCode == RIGHT)
	{
		move(1);
	}
	else if(keyCode == LEFT)
	{
		move(-1);
	}
	else if(keyCode == DOWN)
	{
		flip();
	}
}