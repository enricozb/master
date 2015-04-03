final String s_main = "THIS IS A TEST\nOF SWANK AND MONEY";
int currChar = 0;

String make(String s) {
	return make(s, currChar);
}

String make(String s, int currChar) {
	for(int i = 'A' + currChar; i <= 'Z'; i++) {
		s = s.replace((char) i, ' ');
	}
	return s;
}

void setup() {
	size(500, 500);
	textFont(createFont("Consolas", 42));
	textAlign(CENTER, CENTER);
}

void draw() {
	background(0);
	text(make(s_main),width/2,height/2);
}

void keyPressed() {
	currChar++;
	while(make(s_main, currChar).equals(make(s_main, currChar - 1)))
		currChar++;
}