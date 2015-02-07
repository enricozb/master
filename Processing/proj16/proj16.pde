import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

void setup() {
	size(500,500);
	minim = new Minim(this);
	song = minim.loadFile("song.mp3");
	song.play();
	fft = new FFT(song.bufferSize(), song.sampleRate());
}

void draw() {
	fft.forward(song.mix);
	background(0);
	stroke(255);
	beginShape();
	noFill();
	for(int i = 0; i < fft.specSize(); i++)
	{
		if((i & 1) == 0)
			curveVertex(i * 500f/fft.specSize(), 250 -  5 * fft.getBand(i));
		else
			curveVertex(i * 500f/fft.specSize(), 250 + 5 * fft.getBand(i));
		//ellipse(i * 500f/fft.specSize(), 250 - 5 * fft.getBand(i), 5,5);
	}
	endShape();
}
