float degree = PI/2;
float time = 0;

void setup() 
{
	size(1200,800,OPENGL);
	smooth(8);
	strokeWeight(5);
	stroke(255);
	colorMode(HSB);
	noFill();
}

int times = 20;

void draw() 
{
	background(35);
	translate(width/2,150);
	rotateY(time);
	for(float i = 100; i <= 400; i += .1)
	{
		stroke(map(i,100,400,0,255),200,200);
		beginShape();
		curveVertex(100 * cos(i/500f * PI * times * sin(degree)), i, 100 * sin(i/500f * PI * times * sin(degree)));
		curveVertex(100 * cos(i/500f * PI * times * sin(degree)), i, 100 * sin(i/500f * PI * times * sin(degree)));
		i+=1;
		curveVertex(100 * cos(i/500f * PI * times * sin(degree)), i + 10 * cos(i/10 - 4 * time), 100 * sin(i/500f * PI * times * sin(degree)));
		curveVertex(100 * cos(i/500f * PI * times * sin(degree)), i + 10 * cos(i/10 - 4 * time), 100 * sin(i/500f * PI * times * sin(degree)));
		endShape();
		i-=1;
	}
	time+=radians(2);
}