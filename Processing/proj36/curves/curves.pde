float x = 200;
float y = 400;
float off = 0;
void setup() {
	size(800,800,OPENGL);
	smooth(8);
	noStroke();
}

void draw() {
	pushStyle();
	fill(0,120);
	rect(0,0,width,height);
	popStyle();
	for(int i = 0; i < width; i++)
		ellipse(i,noise(i/1000f + off)*height, 2,2);
	off += .01;
}