BufferedReader reader;
String file_name_unformated = "dna_unformatted.txt";
String file_name = "dna.txt";

void createFormattedDNAfile() {
	BufferedReader in = createReader(file_name_unformated);
	PrintWriter out = createWriter(file_name);
	String line;
	boolean done = false;

	int count = 0;

	while(!done) {
		try {
			line = in.readLine();
			done = line == null;

			if(done)
				break;

			for (char a : line.toCharArray()) {
				out.print(a);

				count++;
				count %= 3;				

				if(count % 3 == 0)
					out.println();
			}
		}
		catch (IOException e) {
			println("NO SOURCE DNA FILE");
		}
	}
}

import java.util.*;

Map<String, String> notes = new HashMap<String, String>();

void initNotes() {

	/* Amino Acid to Note
	Gly C3
	Ala	D3
	Val	E3
	Leu	F3
	Ile	G3
	Phe A3
	Pro B3
	Ser C4
	Thr D4
	Tyr E4
	Cys F4
	Met G4
	Lys A4
	Arg B4
	His C5
	Trp D5
	Asp E5
	Glu F5
	Asn G5
	Gln A5
	STOP B5
	*/

	notes.put("AAA", "A4"); //Lys
	notes.put("AAT", "G5"); //Asn
	notes.put("AAG", "A4"); //Lys
	notes.put("AAC", "G5"); //Asn

	notes.put("ATA", "G3"); //Ile
	notes.put("ATT", "G3"); //Ile
	notes.put("ATG", "G4"); //Met
	notes.put("ATC", "G3"); //Ile

	notes.put("AGA", "B4"); //Arg
	notes.put("AGT", "C4"); //Ser
	notes.put("AGG", "B4"); //Arg
	notes.put("AGC", "C4"); //Ser

	notes.put("ACA", "D4"); //Thr
	notes.put("ACT", "D4"); //Thr
	notes.put("ACG", "D4"); //Thr
	notes.put("ACC", "D4"); //Thr

	notes.put("TAA", "B5"); //STOP
	notes.put("TAT", "E4"); //Tyr
	notes.put("TAG", "B5"); //STOP
	notes.put("TAC", "E4"); //Tyr

	notes.put("TTA", "F3"); //Leu
	notes.put("TTT", "A3"); //Phe
	notes.put("TTG", "F3"); //Leu
	notes.put("TTC", "A3"); //Phe

	notes.put("TGA", "B5"); //STOP
	notes.put("TGT", "F4"); //Cys
	notes.put("TGG", "D5"); //Trp
	notes.put("TGC", "F4"); //Cys

	notes.put("TCA", "C4"); //Ser
	notes.put("TCT", "C4"); //Ser
	notes.put("TCG", "C4"); //Ser
	notes.put("TCC", "C4"); //Ser

	notes.put("GAA", "F5"); //Glu
	notes.put("GAT", "E5"); //Asp
	notes.put("GAG", "F5"); //Glu
	notes.put("GAC", "E5"); //Asp

	notes.put("GTA", "E3"); //Val
	notes.put("GTT", "E3"); //Val
	notes.put("GTG", "E3"); //Val
	notes.put("GTC", "E3"); //Val

	notes.put("GGA", "C3"); //Gly
	notes.put("GGT", "C3"); //Gly
	notes.put("GGG", "C3"); //Gly
	notes.put("GGC", "C3"); //Gly

	notes.put("GCA", "D3"); //Ala
	notes.put("GCT", "D3"); //Ala
	notes.put("GCG", "D3"); //Ala
	notes.put("GCC", "D3"); //Ala

	notes.put("CAA", "A5"); //Gln
	notes.put("CAT", "C5"); //His
	notes.put("CAG", "A5"); //Gln
	notes.put("CAC", "C5"); //His

	notes.put("CTA", "F3"); //Leu
	notes.put("CTT", "F3"); //Leu
	notes.put("CTG", "F3"); //Leu
	notes.put("CTC", "F3"); //Leu

	notes.put("CGA", "B4"); //Arg
	notes.put("CGT", "B4"); //Arg
	notes.put("CGG", "B4"); //Arg
	notes.put("CGC", "B4"); //Arg

	notes.put("CCA", "B3"); //Pro
	notes.put("CCT", "B3"); //Pro
	notes.put("CCG", "B3"); //Pro
	notes.put("CCC", "B3"); //Pro

}

import ddf.minim.*;
import ddf.minim.ugens.*;

String currCodon;
int delay = 2;

Minim minim;
AudioOutput out;
Oscil wave;

void setup() {
	size(500,500,OPENGL);
	createFormattedDNAfile();
	initNotes();
	reader = createReader(file_name);

	minim = new Minim(this);
	out = minim.getLineOut();

	wave = new Oscil( 440, 0.5f, Waves.TRIANGLE );
	wave.setPhase(0);
	wave.patch(out);

	textAlign(CENTER, CENTER);
	textMode(SHAPE);
	textFont(createFont("Consolas", 42));
}

void updateCodon() {
	if((frameCount-1) % delay != 0)
		return;
	try {
		String line = reader.readLine();
		if (line == null) {
			println("REACHED END OF FILE");
			noLoop();
			return;		
		}
		currCodon = line;
	}
	catch(IOException e) {
		println("NO FORMATTED DNA FILE");
	}
}

void updateNote() {
	println(notes.get(currCodon));
	wave.setFrequency(Frequency.ofPitch(notes.get(currCodon)));
}

void draw() {
	background(0);
	translate(width/2, height/2);
	updateCodon();
	updateNote();
	text(currCodon, 0,0);
}