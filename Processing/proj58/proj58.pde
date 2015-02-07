import fisica.*;

ArrayList<Blob> blobs;
FWorld world;
float t = 0;
int N = 5;
boolean paused = true;

void initFisicaWorld() {
	Fisica.init(this);
	world = new FWorld();
	world.setEdges();
	world.setGravity(0,0);
}

void initBlobs(int n) {
	for(int i : new int[n]) {
		blobs.add(new Blob());
	}
}

void stepWorld() {
	for(int i = 0; i < blobs.size(); i++) {
		Blob b = blobs.get(i);
		b.update();
	}
	world.step();
}

void drawWorld() {
	world.draw();
}

boolean isNumber(String s) {
	try {
		Double.parseDouble(s);
	}
	catch(Exception e) {
		return false;
	}
	return true;
}

void keyPressed() {
	if(key == 'p') {
		paused = !paused;
	}
}

void setup() {
	size(500,500,OPENGL);
	blobs = new ArrayList<Blob>();
	initFisicaWorld();
	initBlobs(N);
}

void draw() {
	background(35);
	if(!paused) {
		stepWorld();
	}
	drawWorld();
	t += .01;
}

int BlobID = 0;
class Blob {

	static final float CHANCE_DOUBLE = .005;
	static final float CHANCE_RELEASE = .05;
	static final String REGULATOR = "regulator";
	static final String ACTIVE = "active";
	static final String DORMANT = "dormant";
	static final float RADIUS = 20;
	static final int MAX_COUNT = 60;
	static final float SPEED = 200;

	FCircle b;
	float offset;
	String ID;
	int count;
	Blob(float x, float y) {
		count = 0;
		b = new FCircle(RADIUS);
		b.setPosition(x, y);
		b.setName(DORMANT);
		b.setFill(0,0,0);
		world.add(b);
		offset = BlobID;
		ID = "" + BlobID;
		BlobID++;
	}

	Blob() {
		this(random(width/4f, 3 * width/4f),random(height/4f, 3 * height/4f));
	}

	void update() {
		b.addForce(random(-SPEED,SPEED),random(-SPEED,SPEED));
		if(random(1) < CHANCE_DOUBLE && b.getTouching().size() < 3) {
			float theta = random(2 * PI);
			float x = RADIUS * cos(theta);
			float y = RADIUS * sin(theta);
			x = constrain(x, RADIUS, width - RADIUS);
			y = constrain(y, RADIUS, height - RADIUS);
			blobs.add(new Blob(b.getX() + x, b.getY() + y));
		}
		if(random(1) < CHANCE_RELEASE && count < MAX_COUNT) {

			float theta = random(2 * PI);
			float x = RADIUS * cos(theta);
			float y = RADIUS * sin(theta);

			FBox box = new FBox(5,5);
			box.setFill(200,0,0);
			box.setName(ID);
			box.setVelocity(x, y);
			box.setPosition(b.getX() + x, b.getY() + y);

			world.add(box);
		}

		ArrayList<FBody> touchingBodies = b.getTouching();
		for(FBody body : touchingBodies) {
			if(body instanceof FBox && isNumber(body.getName()) && body.getName() != ID) {
				count++;
				world.remove(body);
				body.removeFromWorld();
			}
			else if(body.getName() == ACTIVE) {
				count = MAX_COUNT;
			}
		}

		if(count < MAX_COUNT)
			b.setFill(map(count,0,MAX_COUNT,0,255),0,0);
		if(count >= MAX_COUNT)
		{
			b.setName(ACTIVE);
			b.setFill(0,255,0);
		}
	}
};