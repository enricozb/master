boolean running = false;
boolean offClick = false;
long last;

void setup() 
{
	size(500,500,OPENGL);
	smooth(8);
	textAlign(CENTER,CENTER);
	textSize(100);
	last = millis();
	stroke(0);
	fill(0);
}

float getCurTime()
{
	return (millis() - last)/1000f;
}

void draw() 
{	
	if(running)
	{
		background(255);
		text(getCurTime(),width/2,height/2);
	}
}

void keyPressed()
{
	offClick = running;
	running = false;
}

void keyReleased()
{
	if(!running && !offClick)
	{
		running = true;
		last = millis();
	}
	else if(!offClick)
	{
		running = false;
	}
}
