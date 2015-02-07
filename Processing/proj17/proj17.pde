BufferedReader reader;
String line;
int mintime = 2009050000;
int maxtime = 2009062107;
int scale = maxtime - mintime;
float s = 5;
float lastx = 0;
float lasty = 500;
boolean t = true;
void setup()
{
	size(500,500);
	reader = createReader("sim.csv");
	background(0);
	noFill();
}

String parse(String b)
{
	char[] a = b.toCharArray();
	return ( "" + a[0] + a[1] + a[2] + a[3] + " " + a[4] + a[5] + " " + a[6] + a[7] + " " + a[8] + a[9]);
}

void draw()
{
	if(t)
	{
		t = false;
		stroke(255,0,0);
		beginShape();
		vertex(0,400);
	}
	try 
	{
		line = reader.readLine();
	} catch (IOException e)
	{
		println("DONE");
		vertex(500,400);
		endShape();
		noLoop();
		return;
	}
	if(line == null || line.length() == 0)
	{
		println("DONE");
		vertex(500,400);
		endShape();
		noLoop();
		return;
	}
	String[] a = line.split(",");
	if(int(a[1]) < mintime)
		return;
	else if(int(a[1]) > maxtime)
	{
		println("DONE");
		vertex(500,400);
		endShape();
		noLoop();
		return;
	}
	stroke(255,0,0);
	translate(0, -100);
	line(lastx, lasty, 500 - (maxtime - int(a[1])) * 500f/scale, 500 - s * int(a[2]));
	lastx = 500 - (maxtime - int(a[1])) * 500f/scale;
	lasty = 500 - s * int(a[2]);

	if(int(a[2]) > 50)
	{
		println(parse(a[1]) + "-" + a[2]);
	}
	if(int(a[2]) > 0)
	{
		vertex(lastx,lasty - 100);
	}
}