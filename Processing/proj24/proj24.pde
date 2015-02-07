import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
float ls = 0;
float[] rectangles = new float[1024];

void setup() {
	size(1200,800,OPENGL);
	minim = new Minim(this);
	rectMode(CENTER);
	song = minim.loadFile("flim.mp3");
	colorMode(HSB);
	ortho();
}

void draw() {
	
	background(ls,100,100);
	translate(width/2,height/2,0);
	rotateY(PI/2);
	for(int i = 0; i < song.mix.size() - 1; i++)
	{
		fill(abs(song.mix.get(i)) * 255 + 127.5,200,200);
		stroke(abs(song.mix.get(i)) * 255 + 127.5,200,200);
		pushMatrix();

		rectangles[i] += 800*song.mix.get(i);
		rectangles[i] *= .1;
		translate(0,rectangles[i],i - 512);
		ellipse(0,0,10,10);

		popMatrix();
		ls = abs(song.mix.get(i)) * 100;

	}
}

void keyPressed()
{
	if(key == 'p')
			song.play();
}