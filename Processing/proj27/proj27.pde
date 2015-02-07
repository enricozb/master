
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;

FFT fft;
float sampleRate;
float timeSize;

PrintWriter output;

int t = 0;

void setup() {

	size(500, 500);
	frame.setResizable(true); 
	minim = new Minim(this);
	song = minim.loadFile("voice.mp3");
	song.play();
	fft = new FFT(song.bufferSize(), song.sampleRate());
	sampleRate = song.sampleRate();
	timeSize = fft.timeSize();

	output = createWriter("fft.txt");

	writeStart(); 

}

void writeStart()
{
	output.println("var tau = Math.PI * 2;");
	output.println("function dsp(t) {");
	output.println("var ft = 0.0;");
	output.println("if(t<0){}");
}

void writeEnd()
{
	output.println("}return 0.02 * ft;\n}");
	output.close();

}

void draw() {
	background(0);
	fft.forward(song.mix);

	output.println("else if(t<=" + (song.position()/1000.0)+"){");

	strokeWeight(1.3);
	stroke(255);

	for(int i = 0; i < fft.specSize(); i++)
	{
		if(isPeak(fft,i))
			output.println("ft += Math.sin("+getFreq(i) + "*tau*t)*" + fft.getBand(i) + ";");
		//line(i * 1./fft.specSize() * width, height*4/5, i * 1./fft.specSize() * width, height*4/5 - fft.getBand(i)*4);
	}

	if(song.position() >= song.length() - 1)
	{
		noLoop();
		stop();
		background(255);
		writeEnd();
	}
	else
		output.println("}");

}

boolean isPeak(FFT fft, int i)
{
	float cf = fft.getBand(i);
	//return cf > .1;
	return (fft.getBand(i - 1) < cf && fft.getBand(i + 1) < cf) && cf > .1;
}

float getFreq(int index)
{
	return round(index/timeSize * sampleRate);
}