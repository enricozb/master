string t = new string(null, random(240,260),random(240,260), false);
float time = 0;
void setup() 
{
	size(1200,800,P3D);
	noFill();
	smooth(8);
	for(int i = 0; i < 10; i++)
	{
		t.link(new string(null,random(240,260),random(240,260),false));
	}
	noCursor();
}

void draw() 
{
	noStroke();
	background(35);
	noFill();
	t.l.x = mouseX;
	t.l.y = mouseY;

	time+=3;

	stroke(255,0,0);
	t.paint(1);
	t.update();
}

class string
{
	PVector g = new PVector(0,0);
	float k = .001;
	PVector v = new PVector(0,0);
	PVector l;
	string uLink; //I don't even know how I thought of this. 
	boolean fixed;

	string(string uLink, float x, float y, boolean fixed)
	{
		this.fixed = fixed;
		if(uLink != null)
		{
			this.uLink = uLink;
		}
		else
		{
			this.uLink = this;
			this.fixed = true;
		}
		l = new PVector(x,y);
	}

	void link(string uLink)
	{
		if(!fixed)
		{
			this.uLink.link(uLink);
		}
		else
		{
			this.uLink = uLink;
			this.fixed = false;
		}
	}

	void paint(int call)
	{
		if(call == 1)
		{
			beginShape();
			curveVertex(l.x,l.y);
		}
		curveVertex(l.x,l.y);
	
		if(!fixed)
		{
			uLink.paint(0);
		}
		else
		{
			curveVertex(l.x,l.y);
			endShape();
		}
	}

	void update()
	{
		PVector f = calcHooke();
		f.mult(.5);
		v.add(f);
		f.mult(-1);
		uLink.v.add(f);
		v.add(g);
		v.mult(.99);
		l.add(v);
		if(!fixed)
			uLink.update();
	}

	PVector calcHooke()
	{
		float disp = dist(uLink.l.x, uLink.l.y, l.x, l.y);
		float force = k * disp;

		float theta = atan2(uLink.l.y + l.y, uLink.l.x + l.x);
		PVector f = new PVector(uLink.l.x-l.x, uLink.l.y-l.y);
		f.mult(force);
		f.limit(100);
		return f;
	}
}