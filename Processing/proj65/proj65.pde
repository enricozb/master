import processing.video.*;
import fisica.*;

FWorld world;

int w = 10;
FBox[] ground;

Capture cam;

void initCam() {
	cam = new Capture(this, Capture.list()[3]);
	cam.start();   
}

void initFisica() {
	Fisica.init(this);
	world = new FWorld();
	world.setEdges();
	world.setGravity(0,1e3);
	FBox ball = new FBox(50,50);
	ball.setPosition(width/2,height/2);
	world.add(ball);
	ground = new FBox[width/w];
	for(int i = 0; i < ground.length; i++) {
		FBox body = new FBox(w,w);
		body.setPosition(i*w,height);
		body.setStatic(true);
		ground[i] = body;
		world.add(body);
	}
}

void paintAndUpdateCam() {
	if(cam.available())
		cam.read();
	image(cam, width/4, height/4,178,100);
}

void drawRects(PImage p) {
	for(int i = 0; i < p.width; i+=w) {
		int g = getGray(p.get(i,p.height/2));
		pushMatrix();
		fill(p.get(i,p.height/2));
		ground[round(map(i,0,p.width-1,0,ground.length))].setHeight(map(g,0,255,1,400));
		rect(map(i,0,p.width,width/2,-width/2),height/2,w,-map(g,0,255,0,200));
		popMatrix();
	}
}

void stepDrawWorld() {
	world.step();
	pushMatrix();
	scale(-1,1);
	translate(-width/2,-height/2);
	world.draw();
	popMatrix();
}

int getGray(color c){
	int r = (c >> 16) & 0xFF;  // Faster way of getting red(argb)
	int g = (c >> 8) & 0xFF;   // Faster way of getting green(argb)
	int b = c & 0xFF;
	return int(sqrt(pow(r,2) + pow(g,2) + pow(b,2))/sqrt(3));
}


void setup() {
	size(800, 800, OPENGL);
	ortho();
	noStroke();
	initCam(); 
	initFisica(); 
}

void draw() {
	background(35);
	translate(width/2,height/2);
	paintAndUpdateCam();
	drawRects(cam);
	stepDrawWorld();
}