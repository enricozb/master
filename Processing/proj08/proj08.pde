float time;

void setup() {
	size(displayWidth,displayHeight,OPENGL);
	smooth(16);
	noFill();
	background(255);
	colorMode(HSB);
	time = -3;
}

void draw() {
	if(time > displayHeight)
		return;
	stroke(0);
	translate(displayWidth/2, displayHeight/2);
	rotateZ(radians(time / 2));
	rect(-(displayHeight - time),-(displayHeight - time),2 * (displayHeight - time),2 * (displayHeight - time));
	time += .8;
}