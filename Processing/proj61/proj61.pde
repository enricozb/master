PImage photo;
int w = 3;
int h = 3;
float t = 0;

float rx, ry, rz;

void setup() {
	size(1000,1000,OPENGL);
	ortho();
	lights();
	photo = loadImage("img.jpg");
	noStroke();
	//makeGrayscale(photo);
}



void draw() {
	translate(width/2,height/2);
	background(255);
	rotateField();
	for(int i = 0; i < photo.width; i+=w){
		for(int j = 0; j < photo.height; j+=h){
			int g = getGray(photo.get(i,j));
			pushMatrix();
			translate(i-photo.width/2,j-photo.height/2,map(g,0,255,0,200));
			fill(photo.get(i,j));
			box(w,h,w);
			popMatrix();
		}
	}
	t+=.01;
}

void makeGrayscale(PImage photo){
	photo.loadPixels();
	for(int i = 0; i < photo.pixels.length; i++){
		photo.pixels[i] = grayscale(photo.pixels[i]);
	}
	photo.updatePixels();
}

void rotateField() {
	if(mousePressed){
		rx = mouseX/100f;
		ry = mouseX/100f;
		rz = mouseX*mouseY/10000f;
	}
	rotateX(t);
	rotateY(t);
	rotateZ(t);
}

int getGray(color c){
	return (c >> 16) & 0xFF;
}

color grayscale(color c){
	int r = (c >> 16) & 0xFF;  // Faster way of getting red(argb)
	int g = (c >> 8) & 0xFF;   // Faster way of getting green(argb)
	int b = c & 0xFF;
	return color(sqrt(pow(r,2) + pow(g,2) + pow(b,2))/sqrt(3));
}