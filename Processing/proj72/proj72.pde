void setup() {
	size(2880, 1800, OPENGL);
	background(35);
	colorMode(HSB);
	//stroke(255, 255, 255, 5);
	strokeWeight(5);
	strokeCap(SQUARE);
	noFill();
	//frameRate(10);
}


/*
void make(float x, float y, int n) {
	for(int i = 0; i < random(n_c - n_d * n); i++) {
		int dir = (int) random(4);
		
		float dx = random(d) - d/2;
		float dy = random(d) - d/2;
		

		float dx, dy;
		switch(dir) {

			case 0: dx = d; dy = d; break;
			case 1: dx = -d; dy = d; break;
			case 2: dx = d; dy = -d; break;
			default: dx = -d; dy = -d; break;
		}

		line(x, y, x+dx, y+dy);
		make(x + dx, y + dy, n + 1);
	}
}
*/

Path p = new Path(0, 0, 0, -1);

void draw() {
	translate(width/2, height/2);
	if(!p.draw()) {
		println("Done!");
		saveFrame("###.png");
		noLoop();
	}
	//make(0, 0, 0);
	//noLoop();
}

int sign(float x) {
	return x < 0 ? -1 : 1;
}

class Path {
	ArrayList<Path> paths;

	boolean sleep;
	float x, y;
	int n;
	int prev;

	Path(float x, float y, int n, int prev) {
		this.x = x;
		this.y = y;
		this.n = n;
		this.prev = prev;
		paths = new ArrayList<Path>();
	}

	float d = 15;
	float n_d = 0.3;
	int n_c = 7;
	float padding = 3;

	boolean check(float d, float x, float y){
		if(x == y && x == 0)
			return false;
		if(x > 0 && y > 0) return d == 2;
		if(x < 0 && y > 0) return d == 3;
		if(x < 0 && y < 0) return d == 0;
		if(x > 0 && y < 0) return d == 1;
		return false;
	}

	boolean draw() {
		boolean didDraw = false;
		if(sleep) {
			for(Path p : paths) {
				didDraw = didDraw | p.draw();
			}
			return didDraw;
		}
		float limit = random(n_c - n_d * n);
		if(n == 0) limit = 10;
		for(int i = 0; i < limit; i++) {
			int dir = (int) random(4);
			while(check(dir, x, y) || dir == prev) {
				dir = (int) random(4);
			}
			/*
			float dx = random(d) - d/2;
			float dy = random(d) - d/2;
			*/

			float dx, dy;
			switch(dir) {
				case 0: dx = d; dy = d; break;
				case 1: dx = -d; dy = d; break;
				case 2: dx = -d; dy = -d; break;
				default: dx = d; dy = -d; break;
			}

			stroke(n * n_d / n_c * 255, 200, 200, 255);
			//strokeWeight(n_c/n_d - n);
			
			line(x + sign(dx) * padding, y + sign(dy) * padding, x+dx - sign(dx) * padding, y+dy - sign(dy) * padding);
			this.x = x+dx;
			this.y = y+dy;
			n++;
			paths.add(new Path(x, y, n, (dir + 2) % 4));
			didDraw = true;
		}
		sleep = true;
		return didDraw;
	}
}