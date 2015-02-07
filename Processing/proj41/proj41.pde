final float TAU = PI * 2;
final float s = 400;
float off = 0;
float r = 0;
float f = (r + s)/2;

float offr = .1;

float maxi = 1;
float maxk = 50;

void setup() {
	size(500,500,OPENGL);
	smooth(8);
	colorMode(HSB);
}

void draw() {
	background(255);
	translate(width/2, height/2);
	noFill();
	for(int i = 0; i <= maxi; i++)
	{	
		fill(i/maxi * 255, 200, 200);
		beginShape();
		curveVertex(0,0);
		int k = 0;
		for(k = 0; k <= maxk; k++)
		{
			curveVertex(k/maxk * width * cos(i/maxi * TAU + radians(off * k)), k/maxk * width * sin(i/maxi * TAU + radians(off * k)));
			//ellipse(k/maxk * width * cos(i/maxi * TAU + radians(off * k)), k/maxk * width * sin(i/maxi * TAU + radians(off * k)), 5, 5);
		}
		curveVertex(width * cos(i/maxi * TAU + radians(off * k)), width * sin(i/maxi * TAU + radians(off * k)));
		endShape();
	}

	/*
	for(int i = 0; i < 20; i++)
	{
		//fill(i/20f * 255);
		//ellipse(s * cos(i/20f * TAU), s * sin(i/20f * TAU), 5, 5);
		//ellipse(r * cos(i/20f * TAU - radians(off)), r * sin(i/20f * TAU - radians(off)), 5, 5);
		//ellipse(f * cos(i/20f * TAU - radians(.5 * off)), f * sin(i/20f * TAU - radians(.5 * off)), 5, 5);

		noFill();
		beginShape();
		curveVertex(s * cos(i/20f * TAU), s * sin(i/20f * TAU));
		curveVertex(s * cos(i/20f * TAU), s * sin(i/20f * TAU));
		curveVertex(f * cos(i/20f * TAU - radians(.5 * off)), f * sin(i/20f * TAU - radians(.5 * off)));
		curveVertex(r * cos(i/20f * TAU - radians(off)), r * sin(i/20f * TAU - radians(off)));
		curveVertex(r * cos(i/20f * TAU - radians(off)), r * sin(i/20f * TAU - radians(off)));
		endShape();


		//line(s * cos(i/20f * TAU), s * sin(i/20f * TAU), r * cos(i/20f * TAU - radians(off)), r * sin(i/20f * TAU - radians(off)));
		//line(r * cos(i/20f * TAU - radians(off)), r * sin(i/20f * TAU - radians(off)),r/1.2 * cos(i/20f * TAU - radians(2 * off)), r/1.2 * sin(i/20f * TAU - radians(2 * off)));
	}	
	*/
	f = (r + s)/2;
}
void keyPressed()
{
	if(keyCode == RIGHT)
		off -= offr;
	if(keyCode == LEFT)
		off += offr;
	if(keyCode == DOWN)
		offr /= 2.;
	if(keyCode == UP)
		offr *= 2;
}