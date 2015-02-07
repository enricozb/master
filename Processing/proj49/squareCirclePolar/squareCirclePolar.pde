boolean on = true;
float time = 0;
float rate = .001;
void setup() 
{
	size(500,500,OPENGL);
	smooth(8);
	noStroke();
	colorMode(HSB);
}

void draw() 
{
	background(25);
	translate(width/2, height/2);
	normStuff();

}

void normStuff()
{
	noFill();
	stroke(255);
	for(float k = 1; k < 200; k += 20)
	{
		pushMatrix();
		rotateZ(radians(k));
		beginShape();
		for(float i = 0; i < 360; i += 1)
		{
			float r = k * getLengthForDeg(i);
			if(on)
			{
				float x = lerp(getX(r,i), k * cos(radians(i)), time);
				float y = lerp(getY(r,i), k * sin(radians(i)), time);
				vertex(x,y);
			}
			else
			{
				ellipse(getX(r, i), getY(r, i), 4,4);
			}
		}
		endShape(CLOSE);
		popMatrix();
	}
	if(on)
	{
		time = tan(rate);
		rate += radians(1);
	}
}

void oddStuff()
{
	for(float k = 1; k < 200; k += 2)
	{
		for(float i = 0; i < 360; i += 20)
		{
			float si = (1 - k/200) * 4;
			fill(k*1.3,250,250);
			i += time + .5 * k;
			float r = k * getLengthForDeg(i + time + k);
			if(on)
			{
				float x = lerp(getX(r,i), k * cos(radians(i)), 0);
				float y = lerp(getY(r,i), k * sin(radians(i)), 0);
				ellipse(x,y, si,si);
			}
			else
			{
				ellipse(getX(r, i), getY(r, i), si,si);
			}
			i -= (time + .5 * k);

		}
	}
	if(on)
	{
		time += 1;
		rate += 1;
	}
}

void keyPressed()
{
	if(key == 's')
		on = true;
}

float getLengthForDeg(float theta)
{
    theta = radians((theta+45)%90-45);
    return 1/cos(theta);
}

float getX(float r, float theta)
{
	return r * cos(radians(theta));
}

float getY(float r, float theta)
{
	return r * sin(radians(theta));
}