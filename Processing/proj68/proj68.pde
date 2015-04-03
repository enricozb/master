color c_water = color(117,150,125);
color c_sun = color(239,191,110);
color c_sky = color(72,65,75);
color c_rays = color(213,93,64);
color c_cloud = color(72 + 100,65 + 100,75 + 100);

void setup() {
	size(300,300,OPENGL);
	noStroke();
	smooth(8);
}

void draw() {
	background(c_sky);

	sun(frameCount/50f);
	water(frameCount/50f);
	cloud(100 + frameCount/10f, 100, 1);
}

void sun(float t) {
	int x = width/2;
	int y = height/2;
	rectMode(CENTER);
	fill(c_rays);
	for(int i = 0; i < 360; i+= 30) {
		pushMatrix();
		translate(x + cos(radians(i + t)), y + sin(radians(i + t)));
		rotate(radians(i + t));
		rect(0, 0, 1000, 40);
		popMatrix();
	}
	rectMode(CORNER);

	fill(c_sun);
	ellipse(x, y, 250, 250);
}

void water(float t) {
	fill(c_water);
	//rect(0, height/1.5f + 1, width, 300);
	
	beginShape();
	vertex(0, height);
	for(int i = 0; i < width; i++) {
		vertex(i, height/1.5f + 2 * sin(i/50f + t));
	}
	vertex(width, height);
	endShape();
}

void cloud(float x, float y, float scale) {
	fill(c_cloud);
	rect(x, y, 115 * scale, 25 * scale);
	ellipse(x, y, 50 * scale, 50 * scale);
	ellipse(x + 25 * scale, y - 10 * scale, 50 * scale, 50 * scale);
	ellipse(x + 75 * scale, y - 20 * scale, 75 * scale, 75 * scale);
	ellipse(x + 115 * scale, y - 5 * scale, 60 * scale, 60 * scale);
}