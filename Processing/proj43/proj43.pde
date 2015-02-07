float timex = 0;
float timey = 0;
float off = radians(1);
float thickness = 10;
float range = 20;
float timexRate = -radians(5);
float timeyRate = -radians(5);
void setup() {
	size(1200,800,OPENGL);
	smooth(8);
	fill(255);
	noStroke();
	rectMode(CENTER);
}

void draw() {
	background(35);
	for(int i = -20; i < width + 20; i += range)
	{
		fill(200,100,100);
		rect(i + range * sin(timey + i * off), height/2, thickness,height);
		fill(200);
		rect(width/2, i + range * sin(timex + i * off), width,thickness);
	}

	timex += timeyRate;
	timey += timexRate;
	//println(timexRate + " " + timeyRate);
}

void keyPressed()
{
	if(keyCode == RIGHT)
		timexRate -= radians(1);
	if(keyCode == LEFT)
		timexRate += radians(1);
	if(keyCode == UP)
		timeyRate += radians(1);
	if(keyCode == DOWN)
		timeyRate -= radians(1);
}