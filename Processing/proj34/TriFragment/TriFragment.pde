int num = 500;

int SEED = 0;
float MAX_DIST = 10;


ArrayList<Object> objects = new ArrayList<Object>();
void setup() 
{
	size(500,500,OPENGL);
	smooth(8);
	//randomSeed(SEED);
	stroke(255);
	initTriangles();
	strokeWeight(1);
	background(0);
}

void draw() 
{
	for(Object t : objects)
		if(t instanceof Triangle)
			((Triangle) t).draw();
		else if(t instanceof Line)
			((Line) t).draw();
}

void initTriangles()
{
	for(int i = 0; i < num; i++)
	{
		Point temp = new Point(int(random(height)),int(random(width)));
		ArrayList<Object> tempadd = new ArrayList<Object>();
		for(Object p : objects)
		{
			if(p instanceof Point && dist(temp, p) <= MAX_DIST)
			{
				tempadd.add(new Line(temp,(Point) p));
			}
		}
		objects.addAll(tempadd);
		objects.add(temp);
	}
}

float dist(Object ai, Object bi)
{
	Point a = (Point) ai;
	Point b = (Point) bi;
	return dist(a.x,a.y,b.x,b.y);
}

class Point
{
	int x,y;

	Point(int x, int y)
	{
		this.x = x;
		this.y = y;
	}

	void draw()
	{
		//ellipse(x,y,1,1);
	}
};

class Line
{
	Point a,b;
	int c;
	Line(Point a, Point b)
	{
		this.a = a;
		this.b = b;

		this.c = int(map(dist(a.x,a.y,b.x,b.y), 0, MAX_DIST, 0, 100));

	}

	void draw()
	{
		line(a.x,a.y,b.x,b.y);
	}
};

class Triangle
{
	Line a,b,c;

	Triangle(Line a, Line b, Line c)
	{
		this.a = a;
		this.b = b;
		this.c = c;
	}

	void draw()
	{
		beginShape(TRIANGLES);
		vertex(a.a.x,a.a.y);
		vertex(b.a.x,b.a.y);
		vertex(c.a.x,c.a.y);
		endShape(CLOSE);
	}
};
