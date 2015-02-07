float r = 10;
float w = 1;

float k = .0001;

PVector v = new PVector(0, 0);
PVector a = new PVector(0, 0);
PVector g = new PVector(0, w);
PVector f = new PVector(0, 0);

PVector loc = new PVector(0, 0);

void setup() 
{
	size(500,500,OPENGL);
	background(0);
	fill(255);
	stroke(255);
	colorMode(HSB);
	g.normalize();
}

void draw() 
{
	background(0);

	translate(250,250);

	stroke(255,dist(0,0,loc.x,loc.y),255);
	line(0,0,loc.x,loc.y);

	stroke(255,255,255);
	line(loc.x,loc.y, loc.x + 10*v.x, loc.y + 10*v.y);
	noStroke();
	ellipse(loc.x, loc.y, r, r);
	//line(x,y, 4*(x + v.x), 4*(y + v.y));

	if(mousePressed)
	{
		loc.x = mouseX - 250;
		loc.y = mouseY - 250;
		v = new PVector(mouseX - pmouseX, mouseY - pmouseY);
		//reset();
	}
	else
	{
		physics();
	}
}

void reset()
{
	v = new PVector(0,0);
	a = new PVector(0, 0);
	f = new PVector(0, 0);
}

void physics()
{
	a = new PVector(0, 0);
	f = new PVector(0, 0);
	calcHooke();
	a.add(g);
	a.add(f);
	v.add(a);
	v.mult(.99);
	loc.add(v);
}

void calcHooke()
{
	float disp = dist(0,0,loc.x,loc.y);
	float force = k * disp;
	float theta = atan2(loc.y,loc.x);
	
	f = new PVector(-loc.x, -loc.y);
	f.mult(force);
}