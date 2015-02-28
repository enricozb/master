import javax.swing.*;
import java.awt.event.*;
import fisica.*;
ArrayList<Window> ws = new ArrayList<Window>();

boolean key_up = false;
boolean key_down = false;
boolean key_right = false;
boolean key_left = false;

PVector loc;

void setup() {

	loc = new PVector(displayWidth/2, displayHeight/2);

	size(200,200);
	for (int i = 0; i < 3; ++i) {
		ws.add(new Window(displayWidth/2,displayHeight/2,200,200));
	}
}

void draw() {
	background(255);
	for(Window w : ws) {
		w.updateApplet();
	}
	move();
}

void refront() {
	for(Window w : ws) {
		w.toFront();
	}
}

void pressKey(int keyCode) {
	if (keyCode == ALT) {refront();}
	if (keyCode == UP) {key_up = true;}
	if (keyCode == DOWN) {key_down = true;}
	if (keyCode == RIGHT) {key_right = true;}
	if (keyCode == LEFT) {key_left = true;}
}

void releaseKey(int keyCode) {
	if (keyCode == UP) {key_up = false;}
	if (keyCode == DOWN) {key_down = false;}
	if (keyCode == RIGHT) {key_right = false;}
	if (keyCode == LEFT) {key_left = false;}
}

void keyPressed() {pressKey(keyCode);}
void keyReleased() {releaseKey(keyCode);}

void move() {
	if( key_up ) { loc.y--; }
	if( key_down ) { loc.y++; }
	if( key_right ) { loc.x++; }
	if( key_left ) { loc.x--; }
}

class Window extends JFrame{
	int x, y, w, h;
	Applet applet;

	Window(int x, int y, int w, int h) {

		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.applet = new Applet();
		reSize();
		setLocation(x, y);
		setResizable(false);
		add(applet);
    	applet.init();
    	show();

    	applet.setSelfLoc(x, y);

	}

	void setWidth(int w) { this.w = w; }

	void setHeight(int h) { this.h = h; }

	void reSize() {
		setSize(w, h);
	}
	
	void setLocation(int x, int y) {
		super.setLocation(x, y);
	}
	
	void setLocation(float x, float y) {
		this.setLocation(round(x), round(y) );
	}

	void updateLocation() {
		this.x = (int) getLocation().getX();
		this.y = (int) getLocation().getY();
	}

	void updateApplet() {
		updateLocation();
		applet.setSelfLoc(x, y);
	}
};

class Applet extends PApplet {

	PVector selfLoc = new PVector(0,0);

	void setup() {
		noStroke();
	}

	void setSelfLoc(int x, int y) {
		selfLoc.x = x;
		selfLoc.y = y;
	}

	void draw() {
		background(0);
		this.drawCircle();
	}
	void drawCircle() {
		ellipse(loc.x - selfLoc.x, loc.y - selfLoc.y, 20, 20);
	}

	void keyPressed() {pressKey(keyCode);}
	void keyReleased() {releaseKey(keyCode);}
};
