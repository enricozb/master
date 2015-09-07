//0, 0, 100 stroke(176,31,101);
//88, 0, 78 stroke(212,23,114);

void setup() {
	size(800, 800);
	smooth(8);
	strokeWeight(20);
	textAlign(CENTER,CENTER);
	noFill();
	textFont(createFont("KeepCalm-Medium", 150));
}

int tnum = 15;
int time = 0;

void draw() {
	background(35);
	translate(width/2 - tnum, height/2);
	rotate(-PI/6);

	if(time < 100) {
		stage_1();
	}
	else if(100 <= time && time < 200) {
		stage_2();
	}
	else if(time < 400) {
		stage_3();
	}
	else {
		exit();
	}
	saveFrame("out/###.png");
	noStroke();
	//ellipse(88, 0, 1, 1);
	time+=2b;
}

void stage_1() {

	stroke(176,31,101);
	hex(0, 0, 100);
	float percentage = pow((time)/100.0, 3);

	float r = (100 - 78) * (1 - percentage) + 78;

	hex(0, 0, r);
}

// void stage_2() {

// }

void stage_2() {
	stroke(176,31,101);
	hex(map(pow(map(time, 100, 200, 0, 1), .8), 0, 1, 0, 88), 0, 78);


	hex(0, 0, 100);
}

void stage_3() {
	stroke(lerpColor(color(176,31,101), color(212,23,114), map(time, 200, 300, 0, 1)));
	hex(88, 0, 78);

	stroke(176,31,101);
	hex(0, 0, 100);
	noStroke();
	fill(142, 29, 89, map(time, 200, 300, 0, 255));

	beginShape();
	vertex(42, 77);
	vertex(55, 57);
	vertex(79, 57);
	vertex(67, 77);
	vertex(42, 77);
	endShape();

	beginShape();
	vertex(42, 77 - 153);
	vertex(55, 57 - 113);
	vertex(79, 57 - 113);
	vertex(67, 77 - 153);
	vertex(42, 77 - 153);
	endShape();

	fill(255);
	rotate(PI/6);

	fill(255,255,255,map(time, 200, 300, 0, 255));
	text("MOSTEC", tnum, 200);
	noFill();
}

void hex(float x, float y, float r) {
	beginShape();

	float xi = x + r;
	float yi = y;
	vertex(xi, yi);

	for (int i = 1; i < 7; i++) {
		float xf = x + r * cos(map(i, 0, 6, 0, 2 * PI));
		float yf = y + r * sin(map(i, 0, 6, 0, 2 * PI));
		vertex(xf, yf);
		//line(xi, yi, xf, yf);
		xi = xf;
		yi = yf;
	}

	vertex(xi, yi);
	endShape();

}