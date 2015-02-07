float t = 0.0;
float tr = 0.0;
void setup() {
	size(500,500,P3D);
	stroke(255);
	strokeWeight(5);
	noFill();
	colorMode(HSB);
}

void draw() {
	background(35);
	translate(width/2,height/2);
	//beginShape();
	//curveVertex(getWidth(-width/4f) * cos(t * -width/4f), -width/4f, getWidth(-width/4f) * sin(t * -width/4f));
	for(float i = -width/4f; i < width/4f; i++)
	{
		stroke(map(i,-width/4f, width/4, 0, 255), 200, 200);
		beginShape();
		curveVertex(getWidth(i) * cos(t * i), i, getWidth(i) * sin(t * i));
		curveVertex(getWidth(i) * cos(t * i), i, getWidth(i) * sin(t * i));
		curveVertex(getWidth(i + 1) * cos(t * (i + 1)), i + 1, getWidth(i + 1) * sin(t * (i + 1)));
		curveVertex(getWidth(i + 1) * cos(t * (i + 1)), i + 1, getWidth(i + 1) * sin(t * (i + 1)));
		endShape();
	}
	for(float i = width/4f; i >= -width/4f; i--)
	{
		stroke(map(i,width/4f, -width/4, 0, 255), 200, 200);
		beginShape();
		curveVertex(-getWidth(i) * cos(t * i), i, -getWidth(i) * sin(t * i));
		curveVertex(-getWidth(i) * cos(t * i), i, -getWidth(i) * sin(t * i));
		curveVertex(-getWidth(i - 1) * cos(t * (i - 1)), i - 1, -getWidth(i - 1) * sin(t * (i - 1)));
		curveVertex(-getWidth(i - 1) * cos(t * (i - 1)), i - 1, -getWidth(i - 1) * sin(t * (i - 1)));
		endShape();
	}
	//curveVertex(getWidth(-width/4f) * cos(t * -width/4f), -width/4f, getWidth(-width/4f) * sin(t * -width/4f));
	//endShape(CLOSE);

	t = sin(tr)/20;
	tr += .05;
}

float getWidth(float x){
	return sqrt(pow(width/4f,2) - pow(x,2));
}