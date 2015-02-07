ArrayList<Point> points = new ArrayList<Point>();

Point a,b,c;
float xi,yi,ri;
void setup() 
{
	size(500,500,OPENGL);
	a = new Point(100,20);
	b = new Point(200,400);
	c = new Point(400,40);
}

void draw() 
{
	a.draw();
	b.draw();
	c.draw();
	ellipse(xi,yi,2*ri,2*ri);
}

void mousePressed()
{
	Point p = new Point(mouseX,mouseY);
	println(p.inside(a,b,c));
}

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
		float r = dist(x,y,a.x,a.y);

		xi = x;
		yi = y;
		ri = r;

		return dist(this.x,this.y,x,y) < r;
	}
};