ArrayList<Shape> shapes = new ArrayList<Shape>();

float dampening = .1f;
float mLastPressX = -1;
float mLastPressY = -1;

final float speed = 3;

boolean userInteractive = true;
void setup() 
{
	size(1200,800,OPENGL);
	colorMode(HSB);
	noStroke();
	smooth(12);
	ArrayList<float[]> vTemp = new ArrayList<float[]>();
	vTemp.add(new float[]{400,200});
	vTemp.add(new float[]{400,600});
	vTemp.add(new float[]{800,600});
	vTemp.add(new float[]{800,200});
	Shape q = new Shape(vTemp, 0.0, 0);
	shapes.add(q);
}

void draw() 
{
	background(35);
	fill(0);
	//println(shapes.size());
	for(int i = 0; i < shapes.size(); i++)
	{
		shapes.get(i).updraw();
		if(shapes.get(i).gArea() < 20)
		{
			shapes.remove(i);
			i--;
		}
		
	}
	if(userInteractive)
	{
		if(!mousePressed && mLastPressX == -1 && mLastPressY == -1)
		{
			mLastPressX = -1;
			mLastPressY = -1;
		}
		else if(mLastPressX == -1 && mLastPressY == -1)
		{
			mLastPressX = mouseX;
			mLastPressY = mouseY;
		}
		else if(mousePressed)
		{
			stroke(0,255,255);
			strokeWeight(1);
			line(mLastPressX, mLastPressY, mouseX, mouseY);
			noStroke();
		}
		else 
		{
			slice(mouseX, mouseY);
			mLastPressX = -1;
			mLastPressY = -1;
			//userInteractive = false;
		}
	}
	else
	{
		mLastPressX = random(0,1440);
		mLastPressY = random(0, 800);
		float xTemp = random(0, 1440);
		float yTemp = random(0,800);
		slice(xTemp, yTemp);
	}
}

void slice(float x, float y)
{
	ArrayList<Shape> temp = new ArrayList<Shape>(shapes);
	for(Shape q : shapes)
	{
		ArrayList<Shape> temp2 = new ArrayList<Shape>();
		try
		{
			temp2 = q.slice(x, y);
		}
		catch(Exception e)
		{

		}
		if(temp2 != null && temp2.size() != 0)
		{
			temp.addAll(temp2);
			temp.remove(q);
		}
	}
	shapes = temp;
}

void keyPressed()
{
	if(key =='p')
		userInteractive = false;
}

class Shape
{
	ArrayList<float[]> vertexes;
	float col;
	float degree; //in radians
	float magnitude;

	Shape(ArrayList<float[]> vertexes, float degree, float magnitude)
	{
		this.vertexes = vertexes;

		this.degree = degree;
		this.magnitude = magnitude;
		col = random(0,255);
	}

	//Update and Draw :D
	void updraw() 
	{
		fill(col,200,200);
		beginShape();
		for(float[] v : vertexes)
		{
			vertex(v[0],v[1]);
		}
		endShape();
		noFill();
		update();
	}

	void update()
	{
		float xTransform = magnitude * cos(degree);
		float yTransform = magnitude * sin(degree);

		for(float[] v : vertexes)
		{
			v[0] += xTransform;
			v[1] += yTransform;
		}

		magnitude = max(0, magnitude - dampening);
	}

	float gArea()
	{
		float tempA = 0;
		for(int i = 0; i < vertexes.size() - 1; i++)
		{
			tempA += abs(vertexes.get(i)[0] - vertexes.get(i + 1)[0]);
			tempA += abs(vertexes.get(i)[1] - vertexes.get(i + 1)[1]);
		}
		tempA += abs(vertexes.get(vertexes.size() - 1)[0] - vertexes.get(0)[0]);
		tempA += abs(vertexes.get(vertexes.size() - 1)[1] - vertexes.get(0)[1]);
		return tempA/2;
	}

	ArrayList<Shape> slice(float x, float y)
	{
		ArrayList<Shape> tempQ = new ArrayList<Shape>();
		int m = vertexes.size();
		float[][] pts = new float[vertexes.size()][2];
		for(int i = 0; i < vertexes.size(); i++)
		{
			pts[i][0] = vertexes.get(i)[0];
			pts[i][1] = vertexes.get(i)[1];
		}
		ArrayList<float[]> pTemp = new ArrayList<float[]>();
		int i = 0;
		while(intersect(pts[i][0], pts[i][1], pts[(i + 1) % m][0], pts[(i + 1) % m][1], mLastPressX, mLastPressY, x, y) == null)
		{
			i++;
			if(i == m)
				return null;
		}
		pTemp.add(intersect(pts[i][0], pts[i][1], pts[(i + 1) % m][0], pts[(i + 1) % m][1], mLastPressX, mLastPressY, x, y));
		i++;
		i %= m;
		while(intersect(pts[i][0], pts[i][1], pts[(i + 1) % m][0], pts[(i + 1) % m][1], mLastPressX, mLastPressY, x, y) == null)
		{
			i %= m;
			pTemp.add(pts[i]);
			i++;
			
		}
		pTemp.add(pts[i]);
		pTemp.add(intersect(pts[i][0], pts[i][1], pts[(i + 1) % m][0], pts[(i + 1) % m][1], mLastPressX, mLastPressY, x, y));
		tempQ.add(new Shape(pTemp, atan((y - mLastPressY)/(x - mLastPressX)), speed));
		pTemp = new ArrayList<float[]>();
		pTemp.add(intersect(pts[i][0], pts[i][1], pts[(i + 1) % m][0], pts[(i + 1) % m][1], mLastPressX, mLastPressY, x, y));
		i++;
		i %= m;
		while(intersect(pts[i][0], pts[i][1], pts[(i + 1) % m][0], pts[(i + 1) % m][1], mLastPressX, mLastPressY, x, y) == null)
		{
			pTemp.add(pts[i]);
			i++;
			i %= m;
		}
		pTemp.add(pts[i]);
		pTemp.add(intersect(pts[i][0], pts[i][1], pts[(i + 1) % m][0], pts[(i + 1) % m][1], mLastPressX, mLastPressY, x, y));
		
		tempQ.add(new Shape(pTemp, atan((y - mLastPressY)/(x - mLastPressX)) + PI, speed));
		
		return tempQ;
	}

	float[] intersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
	{
		float bx = x2 - x1; 
		float by = y2 - y1; 
		float dx = x4 - x3; 
		float dy = y4 - y3;
		float b_dot_d_perp = bx * dy - by * dx;
		if(b_dot_d_perp == 0) 
		{
			return null;
		}
		float cx = x3 - x1;
		float cy = y3 - y1;
		float t = (cx * dy - cy * dx) / b_dot_d_perp;
		if(t < 0 || t > 1) 
		{
			return null;
		}
		float u = (cx * by - cy * bx) / b_dot_d_perp;
		if(u < 0 || u > 1) 
		{ 
			return null;
		}
			return new float[] {x1+t*bx, y1+t*by};
	}
};