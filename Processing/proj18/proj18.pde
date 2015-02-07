float lx = -1;
float ly = -1;
int[][] keys = {
	{192,49,50,51,52,53,54,55,56,57,48,45,61,8},
	{9,81,87,69,82,84,89,85,73,79,80,91,93,92},
	{20,65,83,68,70,71,72,74,75,76,59,222,10},
	{90,88,67,86,66,78,77,44,46,47},
};

void setup() {
	size(500,500,OPENGL);
}

void draw() {
	fill(255,100);
	rect(0,0,width,height);
}

void keyPressed()
{
	A: for(int i = 0; i < keys.length; i++)
	{
		for(int k = 0; k < keys[i].length; k++)
		{
			if(keyCode == keys[i][k])
			{
				float x = k * 500f/keys[i].length;
				float y = i * 125f;
				if(lx != -1 && ly != -1)
				{
					line(lx,ly,x,y);
				}
				lx = x;
				ly = y;
				break A;
			}
		}
	}
}