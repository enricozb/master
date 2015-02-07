import java.util.*;
ArrayList<int[]> points = new ArrayList<int[]>();

int num = 100;
byte[][] pts = new byte[500][500];


void setup() {

	size(500,500,OPENGL);
	background(0);
	stroke(255);
	strokeWeight(1);
	while(points.size() < num)
	{
		int[] p = {int(random(height)),int(random(width))};
		points.add(p);
		pts[p[0]][p[1]] = 1;
	}
}

void draw() {
	
	int x = points.get(0)[0];
	int y = points.get(0)[1];

	for(int[] p : points)
	{

		line(x,y,p[0],p[1]);
		x = p[0];
		y = p[1];
	}

}