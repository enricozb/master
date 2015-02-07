int a = 0;
float time = 0;
float scale = 1.5;
void setup() {
	size(500,500,OPENGL);
	smooth(16);
	ortho();
}

void draw() {
	background(35);
	translate(250, 250, 0);
	rotateZ(radians(time));
	translate(-250, -250, 0);
	translate(250, 250, 0);
	rotateX(radians(-36));

	pushMatrix();
	rotateY(radians(45));
	fill(244,117,117);
	rect(0,0,100 * scale,100 * scale);
	popMatrix();

	pushMatrix();
	rotateY(radians(45));
	rotateX(radians(90));
	fill(100,52,96);
	rect(0,-100 * scale,100 * scale,100 * scale);
	popMatrix();

	pushMatrix();
	rotateY(radians(-45));
	fill(200,52,96);
	rect(-100 * scale,0,100 * scale,100 * scale);
	popMatrix();

	time++;
}
