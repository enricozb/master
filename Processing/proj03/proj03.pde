float time = 0;

void setup() {
	size(500,500,OPENGL);
	smooth(8);
	background(255);
}

void draw() {
	
	background(255);
	fill(0);
	noStroke();
	translate(250,250);
	rotateX(time);
	rect(-125,-125,250,250);

}

void mouseWheel(MouseEvent e)
{
	time += e.getAmount()/10f;
}