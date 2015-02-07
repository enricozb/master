float time1 = 0;
float time2 = 0;
float time3 = 0;
float speedF = radians(4);
float speedS = 3;
void setup() {
	size(500,500,P3D);
	smooth(8);

	colorMode(HSB);
	
	noStroke();
	lights();
	spotLight(255, 0, 0, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
}

void draw() {

	fill(255,100);
	rect(0,0,500,500);
	fill(0,255,255);

	if(time1 < PI)
	{
		translate(250,250);
		rect(-50 - 50 * (time1/PI),-50 - 50 * (time2/PI),100,100);
		translate(50 - 50 * (time1/PI),-50 - 50 * (time2/PI));
		rotateY(time1 - PI);
		rect(0,0,100,100);
		time1 += speedF;
	}
	else if(time2 < PI)
	{
		translate(300 - 50 * (time1/PI),200 - 50 * (time2/PI));
		rect(-100,0,200,100);
		time1 = PI;
		translate(-100,100);
		rotateX(-time2 + PI);
		rect(0,0,200,100);
		time2 += speedF;
	}
	else if(time3 <= 100)
	{
		time2 = PI;
		translate(200 - 50 * (time1/PI),300 - 50 * (time2/PI));
		rect(0 + time3 - .5 * time3,-100 + time3 - .5 * time3,200 - time3,200 - time3);
		time3 += speedS;
	}
	else
	{
		time1 = 0;
		time2 = 0;
		time3 = 0;
		draw();
	}
}