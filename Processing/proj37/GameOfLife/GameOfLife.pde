import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput aout;

boolean[][] board;
boolean paused = true;

int frameR = 10;
float dur = 1.5/frameR;
void setup() {
	size(1200,800,"processing.core.PGraphicsRetina2D");
	frameRate(frameR);
	board = new boolean[120][80];
	board[board.length/2][board[0].length/2] = true;
	noStroke();
	fill(255);
	//initRandom();
	initMinim();
}

void draw() {
	background(35);
	for(int i = 0; i < board.length; i++)
	{
		for(int k = 0; k < board[i].length; k++)
		{
			if(board[i][k])
				rect(i * 10,k * 10,10,10);
		}
	}
	if(!paused)
		update();
}

void initMinim()
{
	minim = new Minim(this);
	aout = minim.getLineOut();
}

void initRandom()
{
	for(int i = 0; i < board.length; i++)
		for(int k = 0; k < board[i].length; k++)
			if(random(1) > .9)
				board[i][k] = true;
}

void update()
{
	boolean[][] tboard = new boolean[board.length][board[0].length];
	for(int i = 0; i < tboard.length; i++)
	{
		for(int k = 0; k < tboard[0].length; k++)
		{
			int n = getNumNext(board,i,k);
			if((!board[i][k] && n == 3) || (board[i][k] && (n == 3 || n == 2)))
			{
				tboard[i][k] = true;
				//if(!board[i][k])
					//aout.playNote(0,.05 ,pow(2,i/40f) * 220);
			}
		}
	}
	board = tboard;
}

int getNumNext(boolean[][] b, int i, int k)
{
	int c = 0;
	for(int j = -1; j < 2; j++)
		for(int l = -1; l < 2; l++)
		{
			if(j + i < 0 || j + i >= b.length || l + k < 0 || l + k >= b[j + i].length)
				continue;
			if(b[i + j][k + l])
				c++;
		}
	if(b[i][k])
		c--;
	c = max(c,0);
	return c;
}

void keyPressed()
{
	if(key == 'p')
		paused = !paused;
	else if(key == 'c')
	{
		aout = minim.getLineOut();
		board = new boolean[board.length][board.length];
	}
	else if(keyCode == DOWN)
	{
		frameRate(max(--frameR,1));
		frameR = max(frameR, 1);
		println(frameR);
		dur = 1.5/frameR;
	}
	else if(keyCode == UP)
	{
		frameRate(++frameR);
		println(frameR);
		dur = 1.5/frameR;
	}
}

void mousePressed()
{
	int i = mouseX/10;
	int k = mouseY/10;
	if(!board[i][k])
		aout.playNote(0,.05,pow(2,i/40f) * 220);
	board[i][k] = !board[i][k];
}