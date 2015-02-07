import ddf.minim.*;

Minim minim;
AudioPlayer sound;

int NUM_POINTS = 300;

ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Triangle> triangles = new ArrayList<Triangle>();

PImage photo = loadImage("/Users/Enrico/Documents/SublimeFiles/Processing/proj34/Triangulation/data/happy.jpg");

boolean save = false;

void setup() {
	size(photo.width,photo.height,OPENGL);
	minim = new Minim(this);
	sound = minim.loadFile("/Users/Enrico/Documents/SublimeFiles/Processing/proj34/Triangulation/data/done.wav");
	smooth(8);
	noStroke();
	initPoints();
}

void draw() {
	background(255);
	for(Triangle t : triangles)
		t.draw();
	println("FINAL " + triangles.size());
	noLoop();
	//sound.play();
	if(save)
	{
		save = false;
		saveFrame();
	}
}

void addTriangle(Point i, Point j, Point k)
{
	triangles.add(new Triangle(i,j,k));
}

void initPoints()
{
	triangles.clear();
	for(int i = 0; i < NUM_POINTS; i++)
	{
		points.add(new Point(random(width),random(height)));
	}
	for(Point i : points)
	{
		for(Point j : points)
		{
			if(j == i) continue;

			for(Point k : points)
			{
				if(k == i || k == j) continue;

				boolean isAlone = true;

				for(Point a : points)
				{
					if(a == null)
						break;
					if(a == i || a == j || a == k) continue;

					if(a.inside(i,j,k))
					{
						isAlone = false;
						break;
					}
				}
				if(isAlone)
				{
					addTriangle(i,j,k);
				}
			}
		}
	}
}

void keyPressed()
{
	if(key == 's')
	{
		save = true;
		redraw();
	}
	if(key == 'r')
	{
		println("REDOING");
		initPoints();
		redraw();
	}
}

class Triangle
{
	Point a,b,c;
	color fillColor;
	Triangle(Point a, Point b, Point c)
	{
		this.a = a;
		this.b = b;
		this.c = c;

		fillColor = getColor();

	}

	color getColor()
	{
		return photo.get(int(map((a.x + b.x + c.x)/3f,0,width,0,photo.width)), int(map((a.y + b.y + c.y)/3f,0,height,0,photo.height)));
	}

	void draw()
	{
		fill(fillColor);
		beginShape(TRIANGLES);
		vertex(a.x,a.y);
		vertex(b.x,b.y);
		vertex(c.x,c.y);
		endShape(CLOSE);
	}
};

class Line
{
	Point a,b;

	Line(Point a, Point b)
	{
		this.a = a;
		this.b = b;
	}

	void draw()
	{
		line(a.x,a.y,b.x,b.y);
	}
};

class Point
{
	float x,y;

	Point(float x, float y)
	{
		this.x = x;
		this.y = y;
	}

	void draw()
	{
		ellipse(x,y,2,2);
	}

	boolean inside(Point a, Point b, Point c)
	{
		Point ac = new Point((a.x + c.x)/2,(a.y + c.y)/2);
		Point ab = new Point((a.x + b.x)/2,(a.y + b.y)/2);
		float mt = (c.x - a.x)/(a.y - c.y);
		float ms = (b.x - a.x)/(a.y - b.y);

		float x = (ms*ab.x - mt*ac.x - ab.y + ac.y)/(ms - mt);
		float y = mt*(x - ac.x) + ac.y;

		if(a.y == c.y)
		{
			x = ac.x;
			y = ms*(x - ab.x) + ab.y;
		}
		if(a.y == b.y)
		{
			x = ab.x;
			y = mt*(x - ac.x) + ac.y;
		}

		float r = dist(x,y,a.x,a.y);
		return dist(this.x,this.y,x,y) <= r;
	}
};