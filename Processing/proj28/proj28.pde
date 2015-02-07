int w = 500;
int h = 500;

Player mainPlayer;
Enemy[] es;

void setup() {
	size(w,h,OPENGL);
	smooth(8);
	rectMode(CENTER);

	frame.setResizable(true);
	mainPlayer = new Player(w/2,h/2);
	es = new Enemy[1];
	for(int i = 0; i < es.length; i++)
	{
		es[i] = new Enemy(random(500),random(500));
	}

}

void draw() 
{
	background();
	upDrawPlayer();
	upDrawEnemies();
}

boolean keyup = false;
boolean keyright = false;
boolean keyleft = false;
boolean keydown = false;

void keyPressed() 
{
	if (key == CODED) 
	{
		if (keyCode == UP) keyup = true; 
		if (keyCode == DOWN) keydown = true; 
		if (keyCode == LEFT) keyleft = true; 
		if (keyCode == RIGHT) keyright = true; 
	}
}
 
void keyReleased() 
{
	if (key == CODED) 
	{
		if (keyCode == UP) keyup = false; 
		if (keyCode == DOWN) keydown = false; 
		if (keyCode == LEFT) keyleft = false; 
		if (keyCode == RIGHT) keyright = false; 
	}
}

void background()
{
	background(0);
}

void upDrawEnemies()
{
	for(int i = 0; i < es.length; i++)
	{
		es[i].upDraw();
	}
}

void upDrawPlayer()
{
	mainPlayer.upDraw();
}

class Player
{

	final float da = .01;
	final float dampening = .95;

	PVector a;
	PVector v;

	float x;
	float y;

	Player(float x, float y)
	{
		this.x = x;
		this.y = y;
		a = new PVector(0,0);
		v = new PVector(0,0);
	}

	void upDraw()
	{

		if (keyup) a.y -= da;
  		if (keydown) a.y += da;
  		if (keyright) a.x += da;
  		if (keyleft) a.x -= da;

		v.add(a);
		a.mult(dampening);
		v.mult(dampening);
		x += v.x;
		y += v.y;

		fill(255);
		rect(x,y,20,20);
	}
}

class Enemy
{

	final float da = .01;
	final float dampening = .95;

	PVector a;
	PVector v;

	float x;
	float y;

	Enemy(float x, float y)
	{
		this.x = x;
		this.y = y;
		a = new PVector(0,0);
		v = new PVector(0,0);
	}

	void upDraw()
	{
		PVector temp = new PVector(mainPlayer.x - x, mainPlayer.y - y);
		temp.normalize();
		temp.mult(da);
		a.add(temp);
		v.add(a);
		a.mult(dampening);
		v.mult(dampening);
		x += v.x;
		y += v.y;

		fill(255,0,0);
		rect(x,y,20,20);
	}
}