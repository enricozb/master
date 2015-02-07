//import Minim library
  import ddf.minim.*;
  
//for displaying the sound's frequency
  import ddf.minim.analysis.*;

  Minim minim;
//to make it play song files
  AudioPlayer song;
  
//for displaying the sound's frequency
  FFT fft;
  boolean it = true;
void setup() {

  //sketch size
    size(500, 500);
    frame.setResizable(true); 
    minim = new Minim(this);
  
  //load the song you want to play
  //drag the file into your sketch window
  //and replace "mysong.mp3" with the file name
    song = minim.loadFile("test.mp3");
    song.play();
  
  //an FFT needs to know how 
  //long the audio buffers it will be analyzing are
  //and also needs to know 
  //the sample rate of the audio it is analyzing
    fft = new FFT(song.bufferSize(), song.sampleRate());
}
 
float getFreq(int index)
{
  return 5/1024.0 * 44100;
}

void draw() {
    background(0);
    //first perform a forward fft on one of song's buffers
    //I'm using the mix buffer
    //but you can use any one you like
    fft.forward(song.mix);
    println(song.position());
    //line characteristics
    strokeWeight(1.3);
    stroke(#FFF700);

    //processing's transform tool
    pushMatrix(); 

    //draw the frequency spectrum as a series of vertical lines
    //I multiple the value of getBand by 4 
    //so that we can see the lines better
    for(int i = 2; i < fft.specSize() - 2; i++)
    {
        float cf = fft.getBand(i);
        if(fft.getBand(i - 2 ) < fft.getBand(i - 1) && fft.getBand(i - 1) < cf && fft.getBand(i + 1) < cf && fft.getBand(i + 2) < fft.getBand(i + 1))
          println(getFreq(i) + " " + cf);
        line(i * 1./fft.specSize() * width, height*4/5, i * 1./fft.specSize() * width, height*4/5 - cf*4);
    }

    if(song.position() == song.length() - 1)
    {
      noLoop();
      stop();
    }
    popMatrix();

}
 
void stop()
{
  //close the AudioPlayer you got from Minim.loadFile()
    song.close();
  
    minim.stop();
 
  //this calls the stop method that 
  //you are overriding by defining your own
  //it must be called so that your application 
  //can do all the cleanup it would normally do
    super.stop();
}