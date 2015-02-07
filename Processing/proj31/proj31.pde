float t = 0;
float dt = radians(.1);

void setup() 
{
	size(500,500,P3D);
	background(0);
	fill(255);
	noStroke();
}

void draw() 
{
	translate(3*width/4,height/2);

	rotateX(radians(25));
	rotateY(radians(25));

	if(t < 2 * PI)
	{
		polar(t);
		t+=dt;
	}
}

void polar(float t)
{
	ellipse(f(t) * cos(t),f(t) * sin(t),3,3);
}

float f(float t)
{
	return 100 * cos(10 * t);
}