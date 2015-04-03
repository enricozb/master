final float S = 100;
float s = 10;
float f = 3;
float ts = 0;
float tf = .1;

//float t = -10;
void setup() {
	size(400,400,OPENGL);
	smooth(8);
	stroke(255);
	strokeWeight(4);
	noFill();
	background(0);
	colorMode(HSB);
}

void draw() {
	background(35);
	translate(width/2,height/2);
	for(float t = -200; t < 200; t+=tf)
	{
		stroke(map(t,-70,70,0,255),200,200);
		beginShape();
		curveVertex(x(t),y(t));
		curveVertex(x(t),y(t));
		curveVertex(x(t+tf),y(t+tf));
		curveVertex(x(t+tf),y(t+tf));		
		endShape();
	}
	//println(frameCount);
	ts += radians(30);
	if(frameCount == 80)
		exit();

	saveFrame("####.jpg");
}

void point(float x, float y, float z)
{
	pushMatrix();
	translate(x, y, z);
	ellipse(0,0,5,5);
	popMatrix();
}

float x(float t)
{
	return f * t;
}

float y(float t)
{
	return s(t) * cos(2 * t + ts);	
}

float z(float t)
{
	return s(t) * sin(2 * t + ts) * abs(sin(ts/12)) * 0;
}

float s(float t)
{
	return S * pow(cos((t + ts)/12),3);
}