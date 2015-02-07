float timex = 0;
float timey = 0;
float ratex = radians(50);
float ratey = radians(50);
void setup() {
	size(800,800,OPENGL);
	smooth(8);
	noStroke();
	fill(83,119,122);

}

void draw() {
	background(236,208,120);

	ellipse(width/2,height/2, 600,600);
	stroke(192,41,66);
	for(int i = 0; i < width; i+=10)
	{
		strokeWeight(sin(radians(i + timex)) * 10);
		line(i,0,i,height);
	}
	stroke(217,91,67);
	for(int i = 0; i < height; i+=10)
	{
		strokeWeight(sin(radians(i + timey)) * 10);
		line(0, i,width,i);
	}
	noStroke();

	timex += ratex;
	timey += ratey;
}

void keyPressed()
{
	if(keyCode == RIGHT)
	{
		ratex -= radians(5);
	}
	else if(keyCode == LEFT)
	{
		ratex += radians(5);
	}
	else if(keyCode == UP)
	{
		ratey += radians(5);
	}
	else if(keyCode == DOWN)
	{
		ratey -= radians(5);
	}
}