float time = 0;
void setup() {
	size(500,500);
}

void draw() {
	background(0);
	noFill();
	stroke(255);
	beginShape();
	for(int i = 0; i < 50; i++)
	{
		curveVertex(i * 10, 250 + 50 *sin(radians(i*10 + time)));
		ellipse(i * 10, 250 + 50 *sin(radians(i*10 + time)), 5,5);
	}
	endShape();

	time += 10;
}