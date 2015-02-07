import gifAnimation.*;
GifMaker gifExport;

int diameter = 10;
float index = 0;
float time = 0;
float TAU = 2 * PI;
float rate = radians(3);
boolean last = false;

void setup() {
	size(500, 500, OPENGL);
	smooth(8);
	noStroke();
	fill(0);
	rectMode(CENTER);
	background(0);
	gifExport = new GifMaker(this, "Test.gif");
  	gifExport.setRepeat(0);
  	gifExport.setDelay(1000/60);
}

void draw() {
	background(255);
	//fill(35,100);
	//rect(width/2,height/2,width,height);
	if(time >= 0)
		for(int i = diameter; i < width; i += diameter)
		{
			for(int j = diameter; j < height; j += diameter)
			{
				
				fill(0);
				float tempDiameter = pow((width - dist(i,j,getX(time),getY(time)))/width,30) * diameter;
				//float tempDiameter = pow((width - dist(i,j,pmouseX,pmouseY))/width,30) * diameter;
				rect(i,j,tempDiameter,tempDiameter);
				
				
				for(float k = 0; k <= 30 * rate; k += rate)
				{
					fill(0, pow((rate - k)/rate,1) * 150);
					tempDiameter = pow((width - dist(i,j,getX(time - k),getY(time - k)))/width,30) * diameter;
					//float tempDiameter = pow((width - dist(i,j,pmouseX,pmouseY))/width,30) * diameter;
					ellipse(i,j,tempDiameter,tempDiameter);
				}
				
				
			}
		}
	if(time > 2 * TAU)
	{
		//gifExport.finish();
		//exit();
	}
	if(time >= TAU && last)
	{
		//gifExport.addFrame();
		//saveFrame("####.jpg");
	}
	last = !last;
	time += rate;
}

float getX(float t)
{
	return width/4 * cos(3 * t) + width/2;
}

float getY(float t)
{
	return height/4 * sin(2 * t) + height/2;
}