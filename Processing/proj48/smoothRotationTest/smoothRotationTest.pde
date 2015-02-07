boolean r,l,u,d;
float amt = 0;
float speed = radians(15);
void setup() {
	size(500,500,OPENGL);
	stroke(0);
	//lights();
}

void draw() {
	background(35);
	translate(width/2,height/2);
	if(!(r || l || u || d))
	{
		amt = 0;
	}
	else
	{
		amt += constrain(speed*sin(2 * amt),radians(1),speed);
	}
	if(amt > radians(90))
	{
		r = l = u = d = false;
		amt = 0;
	}
	doRotation();
	box(200,200,200);
}

void doRotation()
{
	if(r)
	{
		rotateY(amt);
	}
	else if(l)
	{
		rotateY(-amt);
	}
	else if(u)
	{
		rotateX(amt);
	}
	else if(d)
	{
		rotateX(-amt);
	}
}

void keyPressed()
{
	if(r || l || u || d)
		return;
	if(keyCode == RIGHT)
	{
		r = true;
	}
	else if(keyCode == LEFT)
	{
		l = true;
	}
	else if(keyCode == UP)
	{
		u = true;
	}
	else if(keyCode == DOWN)
	{
		d = true;
	}
}
