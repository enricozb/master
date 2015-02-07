int dw = 100;
int dh = 100;
float off = 0;
float offr = 0;

void setup() {
	size(500,500,OPENGL);
	rectMode(CENTER);
	colorMode(HSB);
	noStroke();
}

void draw() {
	background(0);
	//fill(0,100);
	//rect(width/2,height/2,width,height);
	fill(255);
	for(int i = -height/2; i < 3 * height/2; i += dh)
	{
		for(int k = -width/2; k < 3 * width/2; k += dw)
		{
			rect(k + dw/2 + dh * cos(offr + i/100f),i + dh/2 + dh * sin(offr + k/100f),dw,dh);
		}
	}
	offr += .1;
}