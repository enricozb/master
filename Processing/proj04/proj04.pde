ArrayList<float[]> clicks = new ArrayList<float[]>();

float rSquareNum = 50;
float sqw = 500f/rSquareNum;
float speed = .005;
boolean lastPress = false;

void setup() {
	size(1200,800,OPENGL);
	smooth(8);	
	noStroke();
	fill(35);
	noCursor();
}

void draw() {
	background(255);
	if(mousePressed && !lastPress)
	{
		lastPress = true;
		clicks.add(new float[]{mouseX, mouseY, 0});
	}
	else
	{
		lastPress = false;	
	}

	for(float i = 0; i < width; i += sqw)
	{
		for(float j = 0; j < height; j += sqw)
		{
			float rotateVal = 0;
			pushMatrix();
			for(int k = 0; k < clicks.size(); k++)
			{
				float[] arr = clicks.get(k);
				rotateVal += rval(i + sqw/2, j + sqw/2, arr[0], arr[1], arr[2] += speed);
				if(arr[2] > 2000)
				{
					clicks.remove(k);
					k--;
				}
			}
			translate(i + sqw/2, j + sqw/2, 0);
			rotateX(rotateVal);
			rect(-sqw/2,-sqw/2,sqw,sqw);
			popMatrix();
		}
	}
}

float rval(float x, float y, float mx, float my, float time)
{
	float tmpD = dist(x, y, 0, mx, my, 0);
	float tval = 1 - abs(tmpD - time)/tmpD;
	return max(0, tval);
}