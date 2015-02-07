float t = 0;
float tr = 0;
void setup() 
{
	size(500,500,OPENGL);
	strokeWeight(5);
	//rectMode(CENTER);
	stroke(255);
	noFill();
}

void draw() 
{	
	translate(width/2, 0);
	background(0);

	beginShape();
	for(int i = 0; i < height; i += 1)
	{
		rotateY(t * i);
		curveVertex(getWidth(i),i);
		rotateY(-t * i);
	}
	endShape();
	//curveVertex(0,height);
	/*
	for(int i = height - 1; i >= 0; i -= 1)
	{
		pushMatrix();
		rotateY(t * i);
		rect(-getWidth(i),i,5,5);
		curveVertex(-getWidth(i),i);
		popMatrix();
	}
	curveVertex(0,0);
	endShape();
	*/
	t += .01;
}

float getWidth(int x){
	return sqrt(pow(width/4f,2) - pow(x-width/2f,2));
}