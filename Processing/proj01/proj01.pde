ArrayList<float[]> clicks = new ArrayList<float[]>();

float r;
float gap;
int count = 0;
boolean lastPressed = false;

float elapTime;
float speed;

void setup() {
	r = 20;
	gap = r/2;
	elapTime = 0;
	speed = .05;
	noStroke();
	smooth(8);
	colorMode(HSB);
	fill(255);
	size(1200,800, OPENGL);
	background(0);
	noCursor();
}

void draw() {
	background(35);
	fill(255);

	if((mousePressed && !lastPressed) || (mousePressed && count % 10 == 0))
	{
		count++;
		lastPressed = true;
		clicks.add(new float[]{mouseX,mouseY,0});
	}
	else if(mousePressed)
	{
		count++;
	}
	else if(!mousePressed)
	{
		count = 0;
		lastPressed = false;
	}

	for(float y = gap + r; y < height; y += (2*r + gap))
	{
		for(float x = gap + r; x < width; x += (2*r + gap))
		{
			float tempR = 0;
			for(float[] gr : clicks)
			{
				float rt;
				rt = val(x, y, gr[0],gr[1], gr[2] += speed);
				if(rt < 0)
					rt = 0;
				tempR += rt;
				if(tempR >= 3 * r)
				{
					tempR = 3 * r;
					break;
				}
			}
			fill(255 - tempR/(3 * r) * 255, 255, 255);
			ellipse(x, y, tempR, tempR);
		}
	}
	for(int i = 0; i < clicks.size(); i++)
	{
		if(clicks.get(i)[2] > 1800)
		{
			clicks.remove(i);
			i--;		
		}
	}
}

float val(float x, float y, float lastX, float lastY, float eTime)
{
	float tmpD = dist(x, y, 0, lastX, lastY, 0);
	return 2 * r - 3 * abs(tmpD - eTime)/tmpD * r;
}