//NONWORKING

int s = 200;

Walker[] w = new Walker[s];

float a = 250;
float b = 250;
float t = 0;
void setup() {
	size(500,500,P3D);

	for(int i = 0; i < s; i++)
	{
		w[i] = new Walker();
	}
	smooth(8);
	sphereDetail(6);
	noStroke();
	fill(255,0,0);
}

float xr = 0; //X-rotation
float yr = 0; //Y-rotation
void draw() {
	println(frameCount);
	background(10);
	translate(width/2,height/2,width/2);

	rotateY(t);
	rotateX(t);
	rotateZ(t);

	rotateY(-radians(xr));
	rotate (PI/2 - radians(yr), sin(PI/2+radians(xr)), 0, cos(PI/2+radians(xr)));
	for(Walker p : w)
	{
		p.update();
		p.paint();
	}
	//t += .001;
}

void drawVector(PVector a, PVector b)
{
	stroke(0,255,0);
	line(a.x, a.y, a.z, b.x, b.y, b.z);
	noStroke();
}

void keyPressed()
{
	if(keyCode == UP)
		yr++;
	else if(keyCode == DOWN)
		yr--;
	else if(keyCode == RIGHT)
		xr++;
	else if(keyCode == LEFT)
		xr--;
}

class Walker
{
	PVector accel;
	PVector vel;
	PVector pos;

	Walker()
	{
    	pos = new PVector(0,0,0);
    	accel = new PVector(0,0,0);
    	vel = new PVector(0,0,0);

		pos.x = random(-200,200);
    	pos.y = random(-200,200);
    	pos.z = random(-200,200);
	}

	void update()
	{
		accel = new PVector(0,0,0);
		for(Walker walk : w)
		{
			float a = getForce(walk.pos.x, walk.pos.y, walk.pos.z);
			PVector direction = PVector.add(PVector.mult(pos, -1), walk.pos);
			direction.normalize();
			direction.mult(a);
			accel.add(direction);
		}
	}

	void paint()
	{	
		vel.add(accel);
		vel.mult(.001);
		pos.add(vel);
		System.out.printf("%f %f %f", pos.x, pos.y, pos.z);
		drawVector(pos,accel);
		pushMatrix();
		translate(pos.x,pos.y,pos.z);
		sphere(.6);
		popMatrix();
	}

	float getForce(float x, float y, float z)
	{
		float d = dist(x,y,z,pos.x,pos.y,pos.z);
		float a = pow(d,-2);
		return a;
	}
}