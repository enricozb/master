float time = 0;
float r = 40;
float roff = 0;
float speed = radians(1);
float speedf = .1;
float amt = 0;
void setup() {
	size(500,500,OPENGL);
	colorMode(HSB);
	smooth(8);
	fill(35);
	strokeWeight(12);
	strokeWeight(5);
	background(255);
}

void draw() {
	time += speed;

	fill(255,100);
	noStroke();
	rect(0,0,500,500);
	noFill();

	for(int i = 0; i < 10; i++)
	{
		stroke(255, 255,2 * roff);
		ellipse((100 + roff) * cos(i/10f * 2*PI + time) + 250, (100 + roff) * sin(i/10f * 2*PI + time) + 250, r, r);
	}
	if(mousePressed)
	{
		speed += radians(speedf);
		roff += .5 + speed;
	}
	else
	{
		speed = max(speed - radians(speedf), radians(1));
		roff = max(roff - .5 - speed, 0);
	}

}