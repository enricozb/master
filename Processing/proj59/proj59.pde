PVector a = new PVector(.5,.5,.5);
PVector b = new PVector(1.0,0,0);

void setup() {
	size(500,500,OPENGL);
	smooth(8);
	noStroke();
	sphereDetail(5);
}

void draw() {
	fill(a);
	rect(0,0,width/3f,height);
	fill(b);
	rect(2 * width/3f,0,width,height);
	fill(a.cross(b));
	rect(width/3f,0,width/3f,height);
	if(frameCount == 1)
		println(a.cross(b));
	/*
	for(int i = 0; i < width; i+=10){
		for(int j = 0; j < height; j+=10){
			for(int k = 0; k < width; k+=10){
				pushMatrix();
				translate(i,j,-k);
				fill(map(i,0,width,0,255), map(j,0,width,0,255), map(k,0,width,0,255));
				sphere(1);
				popMatrix();
			}
		}
	}
	*/
}

void fill(PVector v) {
	fill(v.x*255,v.y*255,v.z*255);
}

