import java.math.BigDecimal;

void setup() {
	strokeWeight(0.01);
	stroke(255);
	fill(255);
	size(1000,800);
	background(35);
	noLoop();
}

int NUM = 100;

BigDecimal init = new BigDecimal(0);
BigDecimal delta = new BigDecimal(".00001");
int i = 0;

void draw() {
	for(; i <= 100000; i++) {
		if(i % 10000 == 0) {
			println(i);
		}
		plot(init);
		init = init.add(delta);
	}
}

int xi = 0;
int yi = height;

void plot(BigDecimal d) {
	float x = map(d.floatValue(), 0, 1, 0, width);
	d = d.stripTrailingZeros();
	int y = height - 10 * d.toPlainString().length();
	line(xi, yi, x, y);
	xi = int(x);
	yi = int(y);
}