import java.util.Map;
import java.awt.Polygon;

final color BACKGROUND = color(255);

PShape trackin,trackout;
Polygon tin, tout;

Car c = new Car(80,0);

void setup() {
	size(500,500,P2D);
	createTrack();
}

void draw() 
{
	c.makeMove();
	applyStyle();

	if(frameCount == 1)
	{
		drawTrack();
	}

	pushStyle();
	noFill();
	stroke(0,255,0);
	ellipse(0,0,160,200);
	popStyle();

	pushStyle();
	fill(255,0,0);
	noStroke();
	ellipse(c.p.x,c.p.y,5,5);
	popStyle();
}

boolean isPosValid(int x, int y)
{
	return tout.contains(x,y) && !tin.contains(x,y);
}

float ellipseError(int x, int y)
{
	return Math.abs(1 - (pow(x,2)/6400f + pow(y,2)/10000f));
}

void applyStyle()
{
	translate(width/2,height/2);
	scale(2);
}

void drawTrack()
{
	background(BACKGROUND);
	shape(trackout);
	shape(trackin);
}

void createTrack()
{
	PShape s;

	//OUTSIDE
	s = createShape();
	s.beginShape();
	s.fill(0);
	s.vertex(-60,100);
	s.vertex(-80,80);
	s.vertex(-80,-80);
	s.vertex(-60,-100);
	s.vertex(60,-100);
	s.vertex(80,-80);
	s.vertex(80,80);
	s.vertex(60,100);
	s.endShape();
	trackout = s;

	//INSIDE
	s = createShape();
	s.beginShape();
	s.fill(BACKGROUND);
	s.vertex(-60,60);
	s.vertex(-40,80);
	s.vertex(40,80);
	s.vertex(60,60);
	s.vertex(60,-60);
	s.vertex(40,-80);
	s.vertex(-40,-80);
	s.vertex(-60,-60);
	s.endShape();
	trackin = s;

	//******JAVA POLYGONS******
	tin = new Polygon();
	tout = new Polygon();

	tin.addPoint(-60,60);
	tin.addPoint(-40,80);
	tin.addPoint(40,80);
	tin.addPoint(60,60);
	tin.addPoint(60,-60);
	tin.addPoint(40,-80);
	tin.addPoint(-40,-80);
	tin.addPoint(-60,-60);

	tout.addPoint(-60,100);
	tout.addPoint(-80,80);
	tout.addPoint(-80,-80);
	tout.addPoint(-60,-100);
	tout.addPoint(60,-100);
	tout.addPoint(80,-80);
	tout.addPoint(80,80);
	tout.addPoint(60,100);

}

class Car
{
	HashMap<Integer,int[]> accels = new HashMap<Integer,int[]>();

	PVector a;
	PVector v;
	PVector p;

	int move;

	Car(int x, int y)
	{
		p = new PVector(x,y);
		v = new PVector(0,0);
		a = new PVector(0,0);
		move = 0;
		initAccelOptions();
	}

	float[] getBestVal(int ax, int[] ayOptions)
	{
		float[] val = new float[3]; //To hold [bestVal, ax, ay]
		for(int i = -1; i < 2; i += 2)
			for(int k = -1; k < 2; k += 2)
				for(int ay : ayOptions)
				{
					float accelMag = (new PVector(ax,ay)).mag();
					PVector avgV = new PVector((2 * v.x + i * ax)/2,(2 * v.y + k * ay)/2);
					float ellipseErr = ellipseError(int(p.x + avgV.x), int(p.y + avgV.y));
					float tempVal = avgV.mag()/ellipseErr;

					if(val[0] < tempVal && isPosValid(int(p.x + avgV.x),int(p.y + avgV.y)))
					{
						val[0] = tempVal;
						val[1] = i * ax;
						val[2] = k * ay;
					}
				}
		return val;
	}

	void makeMove()
	{
		float[] val = new float[3]; //To hold [bestVal, ax, ay]

		for(Map.Entry acc : accels.entrySet())
		{
			float[] tempArr = getBestVal((Integer)acc.getKey(), (int[])acc.getValue());
			if(val[0] < tempArr[0])
			{
				val[0] = tempArr[0];
				val[1] = tempArr[1];
				val[2] = tempArr[2];
			}
		}
		for(float vall : val)
		{
			print(vall +" ");
		}
		println();
		a = new PVector(val[1],val[2]);
		p.x += (2 * v.x + a.x)/2;
		p.y += (2 * v.y + a.y)/2;
		v.add(a);
		move++;
		println("MOVE " + move);
	}

	void initAccelOptions()
	{
		accels.put(0 , new int[]{0,2,4,6,8,10});
		accels.put(2 , new int[]{0,2,4,6,8,10});
		accels.put(4 , new int[]{0,2,4,6,8});
		accels.put(6 , new int[]{0,2,4,6,8});
		accels.put(8 , new int[]{0,2,4,6});
		accels.put(10, new int[]{0});
	}
};