import java.util.ArrayList;

void setup() {
	size(600,600);
	noFill();
	stroke(255);
	textAlign(LEFT, TOP);
}

float time = 0;

ArrayList<float[]> points = new ArrayList<float[]>();

void draw() {
	background(45);
	drawCircle(time);
	drawPoints();
	drawText();
	time += 0.01;
}

void circle(float x, float y, float r) {
	ellipse(x, y, r * 2, r * 2);
}

	float r1 = 1;
	float f1 = 1;
	float r2 = 1;
	float f2 = 1;

void drawCircle(float t) { 

	circle(width/2, height/2, 50 * r1);

	float x1 = width/2 + 50 * r1 * cos(f1 * t);
	float y1 = height/2 + 50 * r1 * sin(f1 * t);

	circle(x1, y1, 5);

	circle(x1, y1, 50 * r2);

	float x2 = x1 + 50 * r2 * cos(f2 * t);
	float y2 = y1 + 50 * r2 * sin(f2 * t);

	circle(x2, y2, 5);

	points.add(new float[]{t*20, y2});
}

void drawPoints() {
	for(float[] p: points) {
		circle(p[0], p[1], 2);
	}
}

void drawText() {
	text("UP\tOuter circle frequency increase.\n" + 
		"DOWN\tOuter circle frequency decrease.\n" + 
		"RIGHT\tOuter circle radius increase.\n" + 
		"LEFT\tOuter circle radius decrease.\n" + 
		"W\tInner circle frequency increase.\n" + 
		"S\tInner circle frequency decrease.\n" + 
		"D\tInner circle radius increase.\n" + 
		"A\tInner circle radius decrease.\n", 0, 0);

	text(String.format("%.0fsin(%.0fx) + %.0fsin(%.0fx)", r1, f1, r2, f2), 0, height - 20);
}

void keyPressed() {
	if(keyCode == UP) 	 f1++;
	if(keyCode == DOWN)  f1 = f1 - 1 <= 0 ? 1 : f1 - 1;
	if(keyCode == LEFT)  r1 = r1 - 1 <= 0 ? 1 : r1 - 1;
	if(keyCode == RIGHT) r1++;

	if(key == 'w') f2++;
	if(key == 's') f2 = f2 - 1 <= 0 ? 1 : f2 - 1;
	if(key == 'd') r2 = r2 - 1 <= 0 ? 1 : r2 - 1;
	if(key == 'a') r2++;

	points.clear();
	time = 0;
}