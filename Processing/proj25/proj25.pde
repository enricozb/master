import java.util.Map;
import gifAnimation.*;

PImage base = loadImage("/Users/Enrico/Documents/SublimeFiles/Processing/proj25/data/temp.jpg");

GifMaker g;

int[][] noise = new int[500][500];
Map<PVector, int[]> lines = new HashMap<PVector, int[]>();

float r = 500 * sqrt(2);
float sq3 = sqrt(3);

int fCount = -20;

int ti = 0;

void setup() {
	size(1200,800,OPENGL);
	smooth(8);
	noStroke();
	background(35);
	initDataFields();
	//initGifMaker();
	ortho();
}

void initGifMaker()
{
	frameRate(30);
	g = new GifMaker(this,"out2.gif");
	g.setRepeat(0);
	g.setDelay(1000/30);
}

void initDataFields()
{
	//initNoiseData();
	//initLinesData();
}

void initNoiseData()
{
	println("MAKING NOISE DATA");
	for(int i = 0; i < width; i++)
		for(int k = 0; k < height; k++)
		{
			noise[i][k] = int(random(50));
		}
}

void initLinesData()
{
	println("MAKING LINE DATA");
	boolean horizontalLine = true;
	for(int i = -height; i < 2 * height; i += 20)
	{
		if(horizontalLine && i >= 0)
		{
			horizontalLine = false;
			newLineDataEntry(i * sq3,0, PI/2);
		}
		else if(!horizontalLine){
			horizontalLine = true;
		}
		newLineDataEntry(-10*sq3,i,PI/6);
		newLineDataEntry(-10*sq3,i,-PI/6);
	}

}

void newLineDataEntry(float x, float y, float theta)
{
	int[] temp = new int[3];
	temp[0] = int(random(200));
	temp[1] = int(random(200,256));
	temp[2] = int(random(-10,10));
	lines.put(new PVector(x,y,theta),temp);
}

void drawRhombus(float t, boolean f)
{
	println("DRAWING SHAPES");
	boolean h = f;
	fill(255,0,0);
	int k = 0;

	for(float i = -10*sq3 + t * 10*sq3; i < t * 10*sq3; i += 10*sq3)
	{
		if(h)
			k = 0;
		else
			k = 10;
		h = !h;
		for(k = k; k <= height; k += 20)
			drhombus(i,k,20);
	}
}

void drawLines()
{
	println("DRAWING LINES");
	for(PVector key : lines.keySet())
	{
		dline(key.x, key.y, key.z, lines.get(key));
	}
}

void drawNoise()
{
	println("DRAWING NOISE");
	for(int i = 0; i < width; i++)
		for(int k = 0; k < height; k++)
		{
			stroke(0,noise[i][k]);
			point(i,k);
		}
}

void setRandFill(float x, float y)
{
	fill(base.get(int(x/(width + 100) * base.width), int(y/(height + 100) * base.height)));
}

void drhombus(float x, float y, float d1)
{
	pushMatrix();
	/*
	if(fCount >= 0)
	{
		translate(x + 10 * sq3, y, 0);
		rotateY(radians(fCount - 1));
		translate(-(x+ 10 * sq3), -y, 0);
	}
	else
	{
		translate(x + 10 * sq3, y, 0);
		rotateY(radians(random(-10,10)));
		translate(-(x+ 10 * sq3), -y, 0);
	}
	*/
	setRandFill(x + 20,y);
	noStroke();
	beginShape();
	vertex(x,y);
	vertex(x + d1 * cos(PI/6),y + d1/2);
	vertex(x + sq3 * d1, y);
	vertex(x + d1 * cos(PI/6),y - d1/2);
	endShape(CLOSE);
	popMatrix();

}

void dline(float x, float y, float theta, int[] currLine) {

	stroke(60,currLine[0]);
	line(x, y, x + r * cos(theta), y + r * sin(theta));
	
	stroke(60,currLine[1]);
	float offset = currLine[2];
	float num = 1000;

	float x2 = x + r * cos(theta);
	float y2 = y + r * sin(theta);

	beginShape(LINES);
	for(int i = 0; i < num; i++)
	{
		float tx = lerp(x,x2,(i + offset)/num);
		float ty = lerp(y,y2,(i + offset)/num);
		vertex(tx,ty);
	}
	endShape();
}

void addFrame()
{
	if(fCount == 181)
		g.finish();
	else if(fCount < 181 && (fCount & 1) == 0) {
		g.addFrame();
		//saveFrame();
	}
}

void keyPressed()
{
	drawRhombus(ti, ti % 2 == 0);
	ti++;
}

void draw() {
	//drawRhombus(ti);
	//ti++;
	//drawLines();
	//drawNoise();

	//addFrame();
	//println(fCount);
	//saveFrame();
	//noLoop();
}

class rhombus
{
	float x;
	float y;
	float d1;
	float[] rgb;
	rhombus(float x, float y, float d1, float[] rgb)
	{
		this.x = x;
		this.y = y;
		this.d1 = d1;
		this.rgb = rgb;
	}

	void draw()
	{
		noStroke();
		beginShape();
		vertex(x,y);
		vertex(x + d1 * cos(PI/6),y + d1 * sin(PI/6));
		vertex(x + 2 * d1, y);
		vertex(x + d1 * cos(-PI/6),y + d1 * sin(-PI/6));
		endShape();

	}
}