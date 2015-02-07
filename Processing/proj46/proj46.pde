float time = 0;
float rate = radians(1);
Orbit orbit = new Orbit(1, 10,30, 60);


void setup() {
	size(1200,800, OPENGL);
	smooth(8);
	noStroke();
	colorMode(HSB);
}

void draw() { 
	background(35);
	fill(255);
	translate(width/2, height/2);
	for(int i = 0; i < 10; i++)
	{
		orbit.draw(time + i/5f * PI * 3, 150 * cos(time + (float) i * PI * .2), 150 * sin(time + (float) i * PI * .2), i/10f);
	}
	time += rate;
}

class Orbit
{
	
	int n; 			//num of outer bodies
	float d1, d2;	//diameters of inner body and outer bodies
	float r; 		//distance from outer bodies to inner one

	Orbit(int n, float d1, float d2, float r)
	{
		this.n = n;
		this.d1 = d1;
		this.d2 = d2;
		this.r = r;
	}

	void draw(float t, float x, float y, float fillProp)
	{
		fill(fillProp * 255, 200 ,200);
		ellipse(x,y,d1,d1);
		for(int i = 0; i < n; i++)
		{
			ellipse(x + r * cos(-t + (float) i/n * PI * 2), y + r * sin(-t + (float) i/n * PI * 2), d2, d2);
		}
	}
}