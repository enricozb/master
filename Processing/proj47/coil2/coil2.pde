float dt = 10;
float t = PI * 10;
float ti = 0;
float f = 0;
float td = 0;
float rate = radians(10);
void setup() 
{
	size(500,500,OPENGL);
	smooth(8);
	colorMode(HSB);
}

void draw() 
{
	background(35);
	translate(width/2,0);
	for(float i = 100; i <= 400; i += .5)
	{
		stroke(map(i,100,400,0,255),200,200);
		strokeWeight(map(i,100,400,10,0));
		beginShape();
		curveVertex(100 * sin(t * map(i,100,400,0,1)), i + 10 * sin(f * i + ti),100 * cos(t * map(i,100,400,0,1)));
		curveVertex(100 * sin(t * map(i,100,400,0,1)), i + 10 * sin(f * i + ti),100 * cos(t * map(i,100,400,0,1)));
		i += 1;
		curveVertex(100 * sin(t * map(i,100,400,0,1)), i + 10 * sin(f * i + ti), 100 * cos(t * map(i,100,400,0,1)));
		curveVertex(100 * sin(t * map(i,100,400,0,1)), i + 10 * sin(f * i + ti), 100 * cos(t * map(i,100,400,0,1)));
		i -= 1;
		endShape();
	}
	//ti += radians(10);
	//f += radians(.0010);
	td += rate;
	t += 5 * sin(td);
}

void keyPressed()
{
	if(keyCode == UP)
		rate += radians(10);
	if(keyCode == DOWN)
		rate -= radians(10);
}