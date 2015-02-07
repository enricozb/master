int[][][] fills = new int[2][13][13];
float R;
float time;
int inCount;
boolean t;

void setup() {
	size(500,500,OPENGL);
	smooth(1024);
	background(0);
	initfills();
	ortho();
	time = -50;
	R = 50/sqrt(3);
	inCount = 0;
	frameRate(60);
}

void draw() {

	if(t)
	{
		draws();
		return;
	}
	background(0);
	stroke(179,36,42);
	strokeWeight(8);
	fill(199,103,104);

	for(int i = -1; i < 10; i++)
	{
		for(int k = -1; k < 12; k++)
		{
			pushMatrix();
			if(cVal(k) < PI/2)
				check(i,k);
			else
				checks(i,k);
				//fill(199,103,104);
			translate(25 + i * 50 + 25 * (k & 1), 2 * R + 75/sqrt(3) * k);
			rotateX(cVal(k));
			translate(-(25 + i * 50 + 25 * (k & 1)), -(2 * R + 75/sqrt(3) * k));
			hex(25 + i * 50 + 25 * (k & 1), 2 * R + 75/sqrt(3) * k, R);
			popMatrix();
		}
	}
	overlay(time);

	if(inCount++ > 30)
	{
		time += 2;
		time = min(time, 180);
	}

	if(time == 180)
	{
		inCount = 0;
		time = -50;
		t = true;
	}
}

//Flip back over

void draws()
{
	background(0);
	stroke(179,36,42);
	strokeWeight(8);
	fill(199,103,104);

	for(int i = -1; i < 10; i++)
	{
		for(int k = -1; k < 12; k++)
		{
			pushMatrix();
			if(cVal(k) < PI/2)
				checks(i,k);
			else
				check(i,k);
			translate(25 + i * 50 + 25 * (k & 1), 2 * R + 75/sqrt(3) * k);
			rotateX(cVal(k));
			translate(-(25 + i * 50 + 25 * (k & 1)), -(2 * R + 75/sqrt(3) * k));
			hex(25 + i * 50 + 25 * (k & 1), 2 * R + 75/sqrt(3) * k, R);
			//fill(0);
			popMatrix();
		}
	}
	/*
	for(int i = -1; i < 10; i++)
	{
		for(int k = -1; k < 12; k++)
		{
			fill(0);
			text((i+1) + " " + (k+1), 25 + i * 50 + 25 * (k & 1) - 10, 2 * R + 75/sqrt(3) * k);	
		}
	}
	*/
	overlay(time);
	if(inCount++ > 30)
	{
		time += 2;
		time = min(time, 180);
	}
	if(time == 180)
	{
		time = -100;
		t = false;
	}
}

float cVal(float k)
{
	return max(0,min(radians(180), radians(time) + (k+3)/12f*PI/2));
}

void overlay(float time)
{
	//Do not try to understand these random measurements.
	noStroke();
	fill(255);
	translate(0, 0, 2 * R);
	rect(0,0,100,500);
	rect(400,0,100,500);

	pushMatrix();
	translate(0, 500 - R * 3/4f);
	rotate(radians(30));
	rect(-200, -201,700,300);
	rect(-140, -802,700,300);
	popMatrix();

	pushMatrix();
	translate(0, 500 - R * 3/4f);
	rotate(radians(-30));
	rect(0, R * 2 - 9.1,700,300);
	rect(100, -552,500,300);
	popMatrix();
}

void check(int i , int k)
{
	if(fills[0][i + 1][k + 1] == 1)
	{
		fill(255,255,255);
	}
	else if(i > 1 && i < 8 && k > 3)
	{
		fill(95,23,27);
	}
	else
	{
		fill(199,103,104);
	}
}

void checks(int i , int k)
{
	if(fills[1][i + 1][k + 1] == 1)
	{
		fill(255,255,255);
	}
	else
	{
		fill(199,103,104);
	}
}

//One of the only things that are possibly useful from this sketch 

void hex(float x, float y, float r)
{
	beginShape();
	for(int i = 0; i <= 6; i++)
	{
		vertex(x + r * cos(i * PI/3 + PI/6), y + r * sin(i * PI/3 + PI/6));
	}
	endShape();
}

void initfills()
{
	fills[0][2][6] = 1;
	fills[0][3][4] = 1;
	fills[0][3][5] = 1;
	fills[0][4][3] = 1;
	fills[0][4][4] = 1;
	fills[0][4][4] = 1;
	fills[0][5][5] = 1;
	fills[0][5][6] = 1;
	fills[0][6][4] = 1;
	fills[0][6][5] = 1;
	fills[0][7][3] = 1;
	fills[0][7][4] = 1;
	fills[0][7][4] = 1;
	fills[0][8][5] = 1;
	fills[0][8][6] = 1;

	fills[1][4][2] = 1;
	fills[1][5][2] = 1;
	fills[1][6][2] = 1;
	fills[1][4][3] = 1;
	fills[1][7][3] = 1;
	fills[1][6][4] = 1;
	fills[1][6][5] = 1;
	fills[1][5][5] = 1;
	fills[1][4][6] = 1;
	fills[1][4][7] = 1;
	fills[1][5][7] = 1;
	fills[1][6][7] = 1;
	fills[1][7][7] = 1;

}