void setup() {
	size(500,500,OPENGL);
	smooth(8);
	rectMode(CENTER);
}

int z = 0;

void draw() {
	background(255);
	translate(width/2,height/2 + 255*sin(radians(z)),z);
	for(int i = 0; i < 1000; i++)
	{
		fill(255);
		pushMatrix();

		translate(0,255,i);
		rect(0,0,10,10);

		popMatrix();
	}
}

void keyPressed()
{
	if(keyCode == UP)
	{
		z++;
	}
	else if(keyCode == DOWN)
	{
		z--;
	}
}