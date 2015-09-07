void setup() {
	
}

int n = 0;
String o = "";
void draw() {
	String s = "";
	for(int i = 4; i <= 4; i++ ) {
		s += eval(n, i);
	}
	if(o.length() == 0) {
		o = s;
	}
	else {
		if(o.charAt(0) == s.charAt(0)) {
			o += s;
		}
		else {
			System.out.println(o.charAt(0) + " : " + o.length());
			o = s;
		}
	}
	n++;
}

String eval(int n, int b){
	boolean s = Integer.toString(n, b).matches("[01]+");
	if(s) {
		return "1";
	}
	else {
		return "0";
	}
} 