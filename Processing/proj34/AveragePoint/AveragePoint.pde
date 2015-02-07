ArrayList<Point> points = new ArrayList<Point>();

void setup() {
	size(500,500,OPENGL);
}

void draw() {
	background(0);
	float x = 0;
	float y = 0;
	fill(0,255,0);
	for(Point p : points)
	{
		x+=p.x;
		y+=p.y;
		p.draw();
	}
	fill(255,0,0);
	ellipse(x/points.size(),y/points.size(),5,5);

	fill(0,0,255);
	if(points.size() == 3)
		drawCenter();

}

void drawCenter()
{

	Point a = points.get(0);
	Point b = points.get(1);
	Point c = points.get(2);

	Point ac = new Point((a.x + c.x)/2,(a.y + c.y)/2);
	Point ab = new Point((a.x + b.x)/2,(a.y + b.y)/2);
	float mt = (c.x - a.x)/(a.y - c.y);
	if((a.y - c.y) == 0)
		mt = 0;
	float ms = (b.x - a.x)/(a.y - b.y);
	if((a.y - b.y) == 0)
		ms = 0;

	float x = (ms*ab.x - mt*ac.x - ab.y + ac.y)/(ms - mt);
	float y = mt*(x - ac.x) + ac.y;
	float r = dist(x,y,a.x,a.y);

	ellipse(x,y,5,5);
}

void keyPressed()
{
	if(key == 'e')
		points.clear();
}

void mousePressed()
{
	points.add(new Point(mouseX,mouseY));
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
		ellipse(x,y,5,5);
	}
};