import processing.video.*;

float t = 0;

float rx, ry, rz;

int w = 2;
int h = 2;

Capture cam;

void setup() {
	size(800, 800, OPENGL);
	noStroke();
	for(String s : Capture.list())
		println(s);

	cam = new Capture(this, Capture.list()[3]);
	cam.start();     
}

void draw() {
	background(35);
	translate(width/2,height/2);
	rotateField();
	if(cam.available())
		cam.read();
	paint(cam);
	t += .01;

}

void rotateField() {
	if(mousePressed){
		rx = mouseX/100f;
		ry = mouseX/100f;
		rz = mouseX*mouseY/10000f;
	}
	rotateX(rx);
	rotateY(ry);
	rotateZ(rz);
}

void paint(PImage p) {
	for(int i = 0; i < p.width; i+=w){
		for(int j = 0; j < p.height; j+=h){
			int g = getGray(p.get(i,j));
			pushMatrix();
			translate(i-p.width/2,j-p.height/2,map(g,0,255,0,200));
			fill(p.get(i,j));
			box(w,h,w);
			popMatrix();
		}
	}
}

int getGray(color c){
	int r = (c >> 16) & 0xFF;  // Faster way of getting red(argb)
	int g = (c >> 8) & 0xFF;   // Faster way of getting green(argb)
	int b = c & 0xFF;
	return int(sqrt(pow(r,2) + pow(g,2) + pow(b,2))/sqrt(3));
}
