import processing.video.*;

Capture cam;

int BLOCK_WIDTH = 32;
int BLOCK_HEIGHT = 16;

void setup() {
	size(1280, 720);
	cam = new Capture(this, Capture.list()[0]);
	cam.start();
	initPThreads();
	noStroke();
}

void draw() {
	if (cam.available()) {
		cam.read();
		//cam.loadPixels();
		if(!initDone)
			initPThreads();
	}
	//image(cam, 0, 0);
}

boolean initDone = false;

void initPThreads() {
	if(cam.width == cam.height && cam.height == 0)
		return;
	println(String.format("initPThreads for %dx%d", cam.width, cam.height));

	int count = 0;

	for(int x = 0; x < cam.width; x += BLOCK_WIDTH ) {
		for(int y = 0; y < cam.height; y += BLOCK_HEIGHT) {
			//println(String.format("init %d %d", x, y));
			PThread p = new PThread(this, x, y);
			p.start();
			count++;
		}		
	}
	//println(String.format("Started %d threads", count));
	initDone = true;
}

class PThread implements Runnable {
	Thread camThread;
	String name;
	int x, y;

	PThread(PApplet p, int x, int y) {
		this.x = x;
		this.y = y;
		name = String.format("(%d, %d)", x, y);
	}

	synchronized void drawrect(color c) {
		for(int i = 0; i < BLOCK_WIDTH; i++) {
			for(int j = 0; j < BLOCK_HEIGHT; j++) {
				fill(cam.get(i + x, j + y));
				rect(i + x, j + y, 1, 1);
			}
		}
	}

	void run() {
		while(true) {
			this.drawrect(cam.get(x,y));
			//delay(200);
		}
	}

	void start() {
		//println("Starting Thread: " + name);
		if(camThread == null) {
			camThread = new Thread(this, name);
			camThread.start();
		}
	}
};