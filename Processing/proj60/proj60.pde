final PVector R_UNIT = new PVector(1,0,0);
final PVector G_UNIT = new PVector(0,1,0);
final PVector B_UNIT = new PVector(0,0,1);

float rx, ry, rz;

float t = 0;

PVector a = copy(R_UNIT);
PVector b = copy(G_UNIT);
void setup() {
	size(800,800,OPENGL);
	sphereDetail(5);
}

void draw() {
	//background(map(abs(a.dot(b)),0,2.828427125,0,255));
	background(35);
	translate(width/2,height/2,-width/2);
	scale(1,-1);
	rotateField();
	//rotateX(PI/4);
	//rotateY(-PI/4);

	//drawSphere();

	drawAxis();
	drawVectors();
	constrain(a);
	constrain(b);
	t += radians(.01);
}

void rotateField() {
	if(mousePressed){
		rx = mouseX/100f;
		ry = mouseX/100f;
		rz = mouseX*mouseY/10000f;
	}
	rotateX(rx);
	rotateY(ry);
	rotateZ(rz);
}

void drawSphere(){
	float r = 1;
	float rs = 100;
	for(float theta = 0; theta < 2 * PI; theta += radians(5)){
		for(float phi = 0; phi < 2 * PI; phi += radians(5)){
			pushMatrix();
			float x = r * sin(theta) * cos(phi);
			float y = r * sin(theta) * sin(phi);
			float z = r * cos(theta);
			stroke(new PVector(x,y,z));
			line(0,0,0,rs * x,rs*y,rs*z);
			noStroke();
			translate(rs * x,rs * y,rs * z);
			fill(new PVector(x,y,z));
			sphere(2);
			popMatrix();
		}		
	}
}

void drawVectors(){
	pushStyle();
	strokeWeight(5);
	line(a);
	line(b);
	line(a.cross(b));
	popStyle();
}

void constrain(PVector v){
	v.x = constrain(v.x,-1,1);
	v.y = constrain(v.y,-1,1);
	v.z = constrain(v.z,-1,1);
}


void line(PVector v){

	pushStyle();
	strokeWeight(1);
	stroke(0);
	line(0,0,0,255 * v.x,0,255 * v.z);
	line(255 * v.x,0,255 * v.z,255 * v.x,255 * v.y,255 *v.z);
	popStyle();

	pushStyle();
	stroke(v);
	line(0,0,0,255 * v.x,255* v.y,255 * v.z);
	popStyle();

}

void stroke(PVector v){
	stroke(255*v.x,255*v.y,255*v.z);
}

void fill(PVector v){
	fill(255*v.x,255*v.y,255*v.z);
}

void drawAxis(){
	stroke(R_UNIT);
	line(0,0,0,width,0,0);
	stroke(G_UNIT);
	line(0,0,0,0,width,0);
	stroke(B_UNIT);
	line(0,0,0,0,0,width);
}

PVector copy(PVector vector){
	return new PVector(vector.x,vector.y,vector.z);
}
int mult = 10;
void keyPressed(){
	if(keyCode == SHIFT)
		mult = -10;
	switch((key + "").toLowerCase().charAt(0)){
		case 'i':a.x+=.01 * mult;
		break;
		case 'j':a.y+=.01 * mult;
		break;
		case 'k':a.z+=.01 * mult;
		break;
		case 'w':b.x+=.01 * mult;
		break;
		case 'a':b.y+=.01 * mult;
		break;
		case 's':b.z+=.01 * mult;
		break;
	}
}

void keyReleased(){
	if(keyCode == SHIFT)
		mult = 10;
}