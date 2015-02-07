float time = 0;
float rate = radians(2);

void setup() {
	size(1200,800,OPENGL);
	noStroke();
	colorMode(HSB);
	sphereDetail(12);
}

void draw() {
	background(35);
	for(int i = 0; i < 100; i++)
	{
		fill(i * 2.55,200,200);
		pushMatrix();
		translate(getX(time - radians(i)),getY(time - radians(i)), getZ(time - radians(i)));
		sphere((100-i)/10f);
		popMatrix();
	}
	time += rate;
	if(time <= radians(360))
	{
		//saveFrame("###.jpg");
	}
	else
	{
		//exit();
	}
}

float getX(float t)
{
	return width/4 * cos(3 * t) + width/2;
}

float getY(float t)
{
	return height/4 * sin(2 * t) + height/2;
}
float getZ(float t)
{
	return height/4 * cos(t);
}