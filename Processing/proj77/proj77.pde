import java.util.*;

int MAX_DIST = 90;
int NUM = 50;
int RAD = 7;

ArrayList<Pt> ps = new ArrayList<Pt>();

void setup() {
	size(1300,800,P2D);
	hint(ENABLE_RETINA_PIXELS);
	smooth(8);
	stroke(40);
	strokeWeight(1);
	fill(60);
}

void draw() {
	background(25);
	if(ps.size() == 0){
		for (int i = 0; i < NUM; i++) {
			ps.add(new Pt(random(width), random(height)));
		}
	}
	for (int i = 0; i < ps.size(); i++) {
		Pt p = ps.get(i);
		if(p.update()) {
			ps.remove(i);
			i--;
		}

		for( int j = 0; j < ps.size(); j++) {
			Pt q = ps.get(j);
			if(q == p)
				continue;
			float d = q.p.dist(p.p);
			if(d < MAX_DIST) {
				line(q.p.x, q.p.y, p.p.x, p.p.y);
			}
		}
	}

	for (int i = 0; i < ps.size(); i++) {
		Pt p = ps.get(i);
		p.draw();
	}
	while(ps.size() < NUM) {
		ps.add(new Pt());
	}
}

class Pt {
	float SPEED = .4;
	int wall;
	PVector p;
	PVector v;
	Pt() {
		this.wall = int(random(4));
		this.p = randp();
		this.v = randv();
	}

	Pt(float x, float y) {
		this.wall = int(random(4));
		this.p = new PVector(x, y);
		this.v = randv();
	}

	void draw() {
		pushStyle();
		noStroke();
		ellipse(p.x, p.y, RAD, RAD);
		popStyle();
	}

	boolean update() {
		p.x += v.x;
		p.y += v.y;
		return (p.x - RAD > width || p.x + RAD < 0 || p.y - RAD> height || p.y + RAD < 0);
	}

	private PVector randp() {
		switch(this.wall) {
			case 0: return new PVector(-RAD, random(height));
			case 1: return new PVector(random(width), -RAD);
			case 2: return new PVector(width + RAD, random(height));
			case 3: return new PVector(random(width), height + RAD);
			default: return null;
		}
	}

	private PVector randv() {
		float v_x = random(SPEED);
		float v_y = random(SPEED);
		switch(wall) {
			case 0: 
			case 1: return new PVector(v_x, v_y);
			case 2: return new PVector(-v_x, v_y);
			case 3: return new PVector(v_x, -v_y);
			default: return null;
		}
	}
};