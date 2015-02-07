import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class proj43 extends PApplet {

float timex = 0;
float timey = 0;
float off = radians(1);
float thickness = 10;
float range = 20;
float timexRate = -radians(5);
float timeyRate = -radians(5);
public void setup() {
	size(1200,800,OPENGL);
	smooth(8);
	fill(255);
	noStroke();
	rectMode(CENTER);
}

public void draw() {
	background(35);
	for(int i = -20; i < width + 20; i += range)
	{
		fill(200,100,100);
		rect(i + range * sin(timey + i * off), height/2, thickness,height);
		fill(200);
		rect(width/2, i + range * sin(timex + i * off), width,thickness);
	}

	timex += timeyRate;
	timey += timexRate;
	//println(timexRate + " " + timeyRate);
}

public void keyPressed()
{
	if(keyCode == RIGHT)
		timexRate -= radians(1);
	if(keyCode == LEFT)
		timexRate += radians(1);
	if(keyCode == UP)
		timeyRate += radians(1);
	if(keyCode == DOWN)
		timeyRate -= radians(1);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "proj43" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
