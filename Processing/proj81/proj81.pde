import java.util.*;
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Serial port;

Minim minim;
AudioOutput out;
Oscil wave;

void setup() {
	String[] list = Serial.list();
	String name = list[list.length - 1];
	port = new Serial(this, name, 9600);

	minim = new Minim(this);
	out = minim.getLineOut();
	wave = new Oscil( 440, 0.5f, Waves.SQUARE );
	wave.patch( out );
}

float scale = 2.5;

void draw() {
	if(port.available() > 0) {
		String val = port.readStringUntil('\n');
		if (val == null)
			return;
		val = val.replaceAll("\n","");
		println(val);
		try {
			int int_val = Integer.parseInt(val.substring(0, val.length() -1));
			float new_freq = int_val * scale;
			wave.setFrequency(new_freq);
		}
		catch(NumberFormatException e) {
			println(e);
		}
	}
}