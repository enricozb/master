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

String currCodon;
int delay = 2;
void setup() {
	size(500,500,OPENGL);
	createFormattedDNAfile();
	reader = createReader(file_name);

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

void updateNote() {}

void draw() {
	background(0);
	translate(width/2, height/2);
	updateCodon();
	updateNote();
	text(currCodon, 0,0);
}