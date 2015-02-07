/*
GOOGLE GLASS SPHERE SKETCH
*/
float t = 0;
void setup() {
	size(640,360,P3D);
	sphereDetail(15);
}
float x = 0;
float y = 0;
float z = 0;

void draw() {
	background(0);
	textSize(70);
	translate(320, 180);
	x = 360 * noise(t);
	y = 360 * noise(2 * t);
	z = 360 * noise(noise(t));
	rotateY(radians(-x));
	rotate (PI/2 - radians(y), sin(PI/2-radians(-x)), 0, cos(PI/2-radians(-x)));
	sphere(1000);
	t += .001;
	//rotate (radians(x), 0, cos(radians(x)), sin(radians(x)));
	//drawGrid();
	//rotate(radians(x), 0, 1, sin(radians(y))); //ROTATE Y by a
	//rotate (radians(z), );
	//sphere(1000);
	//text(x + "\n" + y + "\n" + z, 50,50);
}

void drawGrid()
{
	stroke(255,0,0);
	line(100,0,0,-100,0,0); //X AXIS IS RED
	stroke(0,255,0);
	line(0,100,0,0,-100,0); //Y AXIS IS GREEN
	stroke(0,0,255);
	line(0,0,100,0,0,-100); //Z AXIS IS BLUE
	stroke(0,255,0); 
	//line(0,0,0,0, 100*cos(radians(x)), 100*sin(radians(x)));
}

void keyPressed()
{
	if(keyCode == RIGHT)
		x++;
	else if(keyCode == LEFT)
		x--;
	else if(keyCode == UP)
		y++;
	else if(keyCode == DOWN)
		y--;
	else if(keyCode == TAB)
		z++;
	else if(keyCode == SHIFT)
		z--;
	else if(keyCode == BACKSPACE)
	{
		t++;
		t %= 3;
	}
}