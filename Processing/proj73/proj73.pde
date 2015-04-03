void setup() {
	size(800, 800, P2D);
	background(35);
	//noStroke();
	stroke(255);
	strokeCap(ROUND);
	fill(255);
	strokeWeight(3);

}
ArrayList<Spark> sparks = new ArrayList<Spark>();
void draw() {
	background(35);
	/*
	pushStyle();
	fill(35,110);
	noStroke();
	rect(0,0,width, height);
	popStyle();
	*/
	for(int i = 0; i < sparks.size(); i++) {
		if(!sparks.get(i).draw()) {
			sparks.remove(i);
			i--;
		}
	}
	/*
	if(frameCount % 50 == 0) {
		sparks.add(new Spark(random(width), random(height), (int) random(3,12)));
	}
	*/
}


void keyPressed() {
	if(key == 'c') {
		background(35);
		return;
	}
	mousePressed();

	//saveFrame("######.png");
}

int randomSign() {
	return random(1) < .5 ? -1 : 1;
}

class Beam {

	PVector loc_init, loc, dest;
	float t_elapsed, t_required, t_rate;
	float x_off, y_off;
	float c_off = 200;
	int NOISE_OFF;

	Beam(PVector loc, PVector dest, float t_r, float r) {
		this.loc_init = new PVector(loc.x, loc.y);
		this.loc = loc;
		this.dest = dest;
		this.t_elapsed = 0;
		this.t_required = t_r;
		this.t_rate = r;
		this.x_off = this.y_off = 0;
		NOISE_OFF = (int) random(100);
	}

	boolean draw() {
		if(t_elapsed > t_required)
			return false;
		float x = loc.x;
		float y = loc.y;
		loc.x = lerp(loc_init.x, dest.x, t_elapsed/t_required);
		loc.y = lerp(loc_init.y, dest.y, t_elapsed/t_required);
		x_off = c_off*(noise(t_elapsed + NOISE_OFF) - noise(NOISE_OFF));
		y_off = c_off*(noise(t_elapsed + 100 + NOISE_OFF) - noise(100 + NOISE_OFF));
		loc.x += x_off;
		loc.y += y_off;
		if(t_elapsed != 0) {
			pushStyle();
			colorMode(HSB);
			strokeWeight(3);
			strokeWeight(50 * (t_elapsed)/t_required);
			stroke(255);
			stroke(t_elapsed/t_required * 500, 200, 200,100);
			float off = 5 * (t_elapsed)/t_required;
			line(x + off, y + off, loc.x + off, loc.y + off);
			popStyle();
			/*
			stroke(t_elapsed/t_required * 500, 200, 200, 100);
			line(x, y, loc.x, loc.y);
			popStyle();
			*/
		}
		t_elapsed += t_rate;
		return true;
	}
};

void mousePressed() {
	//background(35);
	sparks.add(new Spark(mouseX, mouseY, (int)  random(5,10)));
}

class Spark {
	ArrayList<Beam> beams = new ArrayList<Beam>();
	Spark(float x, float y, int n) {
		for(int i = 0; i < n; i++) {
			beams.add(new Beam(new PVector(x, y), new PVector(random(width) + (randomSign() * width), random(height) + (randomSign() * height)), 10, .1));
		}
	}

	boolean draw() {
		boolean didDraw = false;
		for(Beam b : beams) {
			didDraw = didDraw | b.draw();
		}
		return didDraw;
	}
}