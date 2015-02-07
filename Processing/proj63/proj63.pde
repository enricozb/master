import processing.video.*;

float DEGREE_EDGE_THRESHOLD = radians(2);
float DIFF_EDGE_THRESHOLD = 5;

int w = 2;
int h = 2;

Capture cam;

void setup() {
	size(800, 800, OPENGL);
	noStroke();
	cam = new Capture(this, Capture.list()[3]);
	cam.start();
}

void draw() {
	background(35);
	translate(width/2,height/2);
	if(cam.available())
		cam.read();
	paint(cam);
}

void paint(PImage photo) {
		for(int i = 0; i < photo.width; i+=w){
		for(int j = 0; j < photo.height; j+=h){
			for(int k = -1; k < 1; k++){
				for(int l = -1; l < 1; l++){
					if(abs(l) == abs(k)) //If they are corners or itself. So only neighbors of edges will be checked.
						continue;
					if(i + k < 0 || i + k >= photo.width || j + l < 0 || j + l >= photo.width) //Check if it's a valid location.
						continue;
					noFill();
					color currentColor = photo.get(i,j);
					if(getDifference(currentColor, photo.get(i+k,j+l)) >= DEGREE_EDGE_THRESHOLD 
						|| abs(getGrayColorVal(currentColor) - getGrayColorVal(photo.get(i+k,j+l))) >= DIFF_EDGE_THRESHOLD) {

						fill(255,0,0);
					}
					rect(i-photo.width/2,j-photo.height/2,w,h);

				}
			}
		}
	}
}

void keyPressed(){
	if(keyCode == UP)
		DEGREE_EDGE_THRESHOLD += radians(.1);
	if(keyCode == DOWN)
		DEGREE_EDGE_THRESHOLD -= radians(.1);
}

float getDifference(color a, color b){
	PVector i = getColorVector(a);
	PVector j = getColorVector(b);
	float angle = PVector.angleBetween(i,j);
	return angle;
}

PVector getColorVector(color c){
	return new PVector(getRed(c),getGreen(c),getBlue(c));
}

int getGrayColorVal(color c){
	int r = (c >> 16) & 0xFF;  // Faster way of getting red(argb)
	int g = (c >> 8) & 0xFF;   // Faster way of getting green(argb)
	int b = c & 0xFF;
	return int(sqrt(pow(r,2) + pow(g,2) + pow(b,2))/sqrt(3));
}

int getRed(color c){
	return (c >> 16) & 0xFF;
}

int getGreen(color c){
	return (c >> 8) & 0xFF;
}

int getBlue(color c){
	return c & 0xFF;
}