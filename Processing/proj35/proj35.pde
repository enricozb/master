float t = 0;

void setup() {
	size(500,500,OPENGL);
	smooth(8);
	noStroke();
	background(0);
}

void draw() {
	pushStyle();
	fill(0,120);
	rect(0,0,width,height);
	popStyle();
	translate(width/2,height/2);
	ellipse(x(t),y(t), 20,20);
	t += radians(1);

}

float x(float t)
{
	return 200 * cos(3 * t);
}

float y(float t)
{
	return 200 * sin(t);
}
