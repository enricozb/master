//Line 67 mother fucking can't fucking get these values to look good damnit. [5,7,15] & [7] (.11)

int N;
int S;
boolean[][][] board;
int count = 0;
float t = 0;

void setup() {
	size(800,800,OPENGL);
	smooth(8);
	sphereDetail(5);
	N = 50;
	S = 8;
	board = new boolean[N][N][N];
	randomize(board, .17);
}

void draw() {
	background(35);
	translate(width/2,height/2,-width/2);
	rotatePerspective(t);
	updateBoard(board);
	drawBoard(board);
	t+=.01;
}

void keyPressed() {
	updateBoard(board);
}

void rotatePerspective(float t) {

	rotateX(t);
	rotateY(t);
	rotateZ(t);

	/*
	rotateX(2 * PI * noise(t));
	rotateY(2 * PI * noise(t * 2));
	rotateZ(2 * PI * noise(t + 100));
	*/
}

void drawBoard(boolean[][][] b) {
	for(int i = 0; i < b.length; i++) {
		for(int j = 0; j < b[i].length; j++) {
			for(int k = 0; k < b[i][j].length; k++) {
				if(b[i][j][k]) {
					pushMatrix(); {
						translate(map(i,0,b.length,-width/2,width/2), map(j,0,b[i].length,-width/2,width/2), map(k,0,b[i][j].length,-width/2,width/2));
						box(S);
					} popMatrix();
				}
			}
		}
	}
}

void updateBoard(boolean[][][] b) {
	count = 0;
	boolean[][][] tb = new boolean[b.length][b[0].length][b[0][0].length];
	for(int i = 0; i < b.length; i++) {
		for(int j = 0; j < b[i].length; j++) {
			for(int k = 0; k < b[i][j].length; k++) {
				int n = getNumNext(b,i,j,k);
				if((!b[i][j][k] && n == 5 || n == 7 || n == 16) || (b[i][j][k] && n == 7)) {
					tb[i][j][k] = true;
					count++;
				}
			}
		}
	}
	println(count);
	board = tb; //change this
}

//Randomize sthe given board
void randomize(boolean[][][] b, float chance) {
	for(int i = 0; i < b.length; i++) {
		for(int j = 0; j < b[i].length; j++) {
			for(int k = 0; k < b[i][j].length; k++) {
				if(random(1) < chance)
					b[i][j][k] = true;
			}
		}
	}
}

//Get the number of living neighbors around a cell
int getNumNext(boolean[][][] b, int i, int j, int k) {
	int c = 0;
	for(int ii = -1; ii < 2; ii++) {
		for(int ji = -1; ji < 2; ji++) {
			for(int ki = -1; ki < 2; ki++) {
				if(!inRange(ii + i, b.length) || !inRange(ji + j, b[ii + i].length) || !inRange(ki + k, b[ii + i][ji + j].length))
					continue;
				if(b[ii + i][ji + j][ki + k])
					c++;
			}
		}
	}
	if(b[i][j][k])
		c--;
	c = max(c,0);
	return c;
}

//Returns true if i is in range [minim,maxim)
boolean inRange(int i, int minim, int maxim) {
	return i >= minim && i < maxim;
}

//Returns true if i is in range [0,maxim)
boolean inRange(int i, int maxim) {
	return i >= 0 && i < maxim;
}