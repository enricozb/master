float time = 0;
float s = 2;
void setup() {
	size(1200,800,OPENGL);
	smooth(8);
	rectMode(CENTER);
	colorMode(HSB);
	noStroke();
}

void draw() {
	translate(width/2, height/2);
	background(35);
	for(float i = 0; i < 2*PI; i+=radians(10))
	{
		fill(map((time + i + PI)%(PI*2), 0, 2 * PI, 0, 255), 200, 200);
		float w = map((i + PI)%(PI*2), 0, 2 * PI, 0, 100) * s;
		pushMatrix();
		translate(s * 100 * cos(i + sin(time + i)),s * 100 * sin(i + sin(time + i)));
		rotate(i + sin(time + i));
		rect(0,0,w,5 * s,10);
		popMatrix();
	}
	time += .07;

}

void keyPressed()
{
	if(keyCode == RIGHT)
			time += .03;
	if(keyCode == LEFT)
			time -= .03;
}