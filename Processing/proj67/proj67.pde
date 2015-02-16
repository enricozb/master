//Ocean - 0B 48 6B
//Sun - f8ca00
//Sand - ebc288
//Cloud - 80
//Sky - 09 73 8a


void setup()
{
	size(800, 500, OPENGL);
	smooth(8);
	noStroke();
}

void draw()
{
	background(0x09738a);
	sun();
	//rect(x, y, w, h);
	fill(1, 62, 97);
	rect(0, 300, 800, 200);

	fill(255);
	cloud1((width/2 - (2*frameCount) +30), height/2, .75);
	cloud2((width/2 - frameCount/3f) - 380, height/2 - 66, 1);
	cloud3((width/2 - frameCount/3f) + 150, height/2 - 150, .9);
	//horizon();
	println(frameCount);

	if(frameCount > 300)
	{
		drawcloud();
	}

	if(frameCount > 100)
		drawcloud();
}

void drawcloud1()
 {
 	cloud4(((width/2 - (2*(frameCount - 300)) % (width + 300)) + 430), height/2, .75);
 }

void drawcloud2()
 {
 	cloud2((width/2 - 2*frameCount) % width + 100 - 380, height/2 - 66, 1);
 }

void sun() {
	for(float i = 1; i >= 0; i -= .01) {
		fill(lerpColor(color(248, 202, 0), color(9, 115, 138), i));
		ellipse(400, 250, lerp(300, 600, i), lerp(300, 600, i));
	}
	fill(270, 210, 0);
	ellipse(400, 250, 300, 300);
}

void horizon() {
	beginShape();
	fill(1, 62, 97);
	vertex(0,300);
	for(int i = 0; i < width; i++) {
		vertex(i, 290 + 1 * sin(i/3f + frameCount/10f));
	}
	vertex(width, 300);
	endShape();
}

void cloud1(float x, float y, float s)
{
	beginShape();
	curveVertex(x + 50, y);
	curveVertex(x, y);
	curveVertex(x + 25 * s, y - 50 * s);
	curveVertex(x + 50 * s, y - 37 * s);
	curveVertex(x + 80 * s, y - 60 * s);
	curveVertex(x + 100 * s, y - 40 * s);
	curveVertex(x + 120 * s, y - 53 * s);
	curveVertex(x + 140 * s, y - 35 * s);
	curveVertex(x + 150 * s, y - 38 * s);
	curveVertex(x + 160 * s, y - 25 * s);
	curveVertex(x + 200 * s, y);
	curveVertex(x, y);
	curveVertex(x, y);
	endShape();
}

void cloud2(float x, float y, float s)
{
	beginShape();
	curveVertex(x, y);
	curveVertex(x, y);
	curveVertex(x + 30 * s, y - 25 * s);
	curveVertex(x + 66 * s, y - 24 * s);
	curveVertex(x + 76 * s, y - 42 * s);
	curveVertex(x + 105 * s, y - 37 * s);
	curveVertex(x + 122 * s, y - 52 * s);
	curveVertex(x + 145 * s, y - 35 * s);
	curveVertex(x + 170 * s, y - 40 * s);
	curveVertex(x + 180 * s, y - 20 * s);
	curveVertex(x + 200 * s, y);
	curveVertex(x, y);
	curveVertex(x, y);
	endShape();
}

void cloud3(float x, float y, float s)
{
	beginShape();
	curveVertex(x, y);
	curveVertex(x, y);
	curveVertex(x + 20 * s, y - 35 * s + 5);
	curveVertex(x + 35 * s, y - 35 * s + 5);
	curveVertex(x + 55 * s, y - 53 * s + 5);
	curveVertex(x + 75 * s, y - 42 * s + 5);
	curveVertex(x + 90 * s, y - 40 * s + 5);
	curveVertex(x + 100 * s, y - 35 * s + 5);
	curveVertex(x + 120 * s, y - 36 * s + 5);
	curveVertex(x + 150 * s, y - 25 * s + 5);
	curveVertex(x + 170 * s, y - 25 * s + 5);
	curveVertex(x + 200 * s, y);
	curveVertex(x, y);
	curveVertex(x, y);
	endShape();
}

void cloud4(float x, float y, float s)
{
	beginShape();
	curveVertex(x + 50, y);
	curveVertex(x, y);
	curveVertex(x + 25 * s, y - 50 * s);
	curveVertex(x + 50 * s, y - 37 * s);
	curveVertex(x + 80 * s, y - 60 * s);
	curveVertex(x + 100 * s, y - 40 * s);
	curveVertex(x + 120 * s, y - 53 * s);
	curveVertex(x + 140 * s, y - 35 * s);
	curveVertex(x + 150 * s, y - 38 * s);
	curveVertex(x + 160 * s, y - 25 * s);
	curveVertex(x + 200 * s, y);
	curveVertex(x, y);
	curveVertex(x, y);
	endShape();
}