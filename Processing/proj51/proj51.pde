import java.util.*;

int num = 700;
float sphereRadius = .6;
ArrayList<Particle> particles = new ArrayList<Particle>();
float dampning = 1;
float t = 0;

float G = 1;
boolean paused = false;

float x,y,z;

void setup() 
{
	size(1200,800,OPENGL);
	smooth(8);
	sphereDetail(5);
	noStroke();
	initParticles();
	colorMode(HSB);
	lights();
}

void draw()
{
	background(35);
	translate(width/2, height/2, -width/2);

	rotateX(x);
	rotateY(y);
	rotateZ(z);

	x = 2 * PI * noise(t);
	y = 2 * PI * noise(t * 2);
	z = 2 * PI * noise(t + 100);
	for(int i = 0; i < particles.size(); i++)
	{
		particles.get(i).draw();
		if(!paused)
			particles.get(i).update();
	}
	t+= .001;
}

void initParticles()
{
	for(int i = 0; i < num; i++)
	{
		PVector pos = new PVector(random(-250,250), random(-250,250), random(-250,250));
		PVector vel = new PVector(0,0,0);
		particles.add(new Particle(pos, vel));
	}
}

void keyPressed()
{
	if(keyCode == UP)
		G *= 10;
	else if(keyCode == DOWN){
		G /= 10;
	}

	if(key == 'p')
		paused = !paused;
	if(key == 's')
		saveFrame("####.njpg");
}

class Particle
{
	PVector pos,vel;

	float radius;
	float mass;

	Particle(PVector pos, PVector vel)
	{
		this.pos = pos;
		this.vel = vel;
		radius = sphereRadius;
		mass = sphereRadius;
	}

	float getForceFrom(Particle p)
	{
		float d = dist(pos.x, pos.y, pos.z, p.pos.x, p.pos.y, p.pos.z);
		if(d < (radius + p.radius))
		{
			return -p.mass * pow(d,-2) * 0;
			/*
			mass += p.mass;
			radius += sphereRadius;
			p.mass = 0;
			p.radius = 0;
			return 0;
			*/
		}
		return p.mass * pow(d, -2) * G;
	}

	void update()
	{
		PVector accel = new PVector(0, 0, 0);
		for(int i = 0; i < particles.size(); i++)
		{
			Particle p = particles.get(i);
			if(p.mass == 0)
			{
				particles.remove(i);
				i--;
			}
			if(p == this)
			{
				continue;
			}
			PVector tempAccel = PVector.sub(p.pos,pos);
			tempAccel.normalize();
			tempAccel.mult(getForceFrom(p));
			accel.add(tempAccel);
		}
		vel.add(accel);
		vel.mult(dampning);
		pos.add(vel);

	}

	void draw()
	{
		fill(200 - vel.mag() * 50,200,200);
		pushMatrix();
		translate(pos.x, pos.y, pos.z);
		//ellipse(0,0,sphereRadius,sphereRadius);
		sphere(radius);
		popMatrix();
	}
}