import processing.video.*;
import fisica.*;

PVector DETECT_COLOR = new PVector(62.0, 238.0, 163.0);
float COLOR_THRESHOLD = radians(5);
int COUNT_THRESHOLD = 50;

String PLATFORM_NAME = "plat";

PImage PLATFORM_IMAGE;
PImage PLAYER_IMAGE;

Player player;
Platform platform;

Capture cam;
FWorld world;

void initCam() {
	cam = new Capture(this, Capture.list()[3]); //1280x720 30fps
	cam.start();
}

void initFisicaWorldAndObjects() {
	Fisica.init(this);
	world = new FWorld();
	world.setEdges();
	world.setGravity(0,1e3);
	platform = new Platform(100,25);
	player = new Player(50,50);
}

void initImages() {
	PLATFORM_IMAGE = loadImage("block.png");
	//PLAYER_IMAGE = loadImage("player.png");
}

void paintCamera() {
	if(cam.available()) {
		cam.read();
	}
}
 
PVector colorToPVector(color c) {
	int r = (c >> 16) & 0xFF;
	int g = (c >> 8) & 0xFF;
	int b = c & 0xFF;
	return new PVector(r, g, b);
}

void updatePlatformPosition() {
	noFill();
	pushMatrix();
	translate(-cam.width/2f,-cam.height/2f);
	stroke(255,0,0);
	int xsum = 0;
	int ysum = 0;
	float count = 0;
	for(int i = 0; i < cam.width; i += 10) {
		for(int j = 0; j < cam.height; j += 10) {
			PVector a = colorToPVector(cam.get(i,j));
			float angle = PVector.angleBetween(a,DETECT_COLOR);
			if(angle < COLOR_THRESHOLD) {
				xsum += i;
				ysum += j;
				count++;
			}
		}
	}
	if(count > COUNT_THRESHOLD) {
		platform.setPosition(width-xsum/count, ysum/count + 3 * width/4f);
	}
	popMatrix();
}

void stepDrawWorld() {
	world.step();
	world.draw();
	platform.draw();
	player.draw();
	player.update();
}

void setup() {
	size(600,800,OPENGL);
	initCam();
	initFisicaWorldAndObjects();
	rectMode(CENTER);
	imageMode(CENTER);
	initImages();
}

void draw() {
	background(255);
	stepDrawWorld();
	translate(width/2, height/2);
	paintCamera();
	updatePlatformPosition();
}

class Platform {
	FBox body;
	Platform(float dx, float dy) {
		body = new FBox(dx, dy);
		body.setStatic(true);
		body.setPosition(width/2,3 * height/4);
		body.setNoStroke();
		body.setName(PLATFORM_NAME);
		world.add(body);
	}

	void draw() {
		image(PLATFORM_IMAGE,body.getX(), body.getY(), body.getWidth(), body.getHeight());
	}

	void setPosition(float x, float y) {
		body.setPosition(x,y);
	}
};

class Player {
	FBox body;
	Player(float dx, float dy) {
		body = new FBox(dx, dy);
		body.setPosition(width/2,height/2);
		body.setNoStroke();
		world.add(body);
	}

	void draw() {

		image(PLATFORM_IMAGE,body.getX(), body.getY(), body.getWidth(), body.getHeight());
	}

	void update() {
		for(Object bo : body.getTouching()) {
			if(((FBody) bo).getName() == PLATFORM_NAME) {
				body.addImpulse(0,-1000);
			}
		}
		body.setRotation(0);
	}
}