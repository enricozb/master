int block_size = 5;
int[][] blocks;
void setup() {
	size(500,500);
	noStroke();
	blocks = new int[100][100];
	for(int x = 0; x < 50; x++) {
		for(int y = 0; y < 100; y++) {
			blocks[x][y] = 1;
		}
	}
}

void draw() {
	for(int x = 0; x < blocks.length; x++) {
		for(int y = 0; y < blocks[x].length; y++) {
			if(blocks[x][y] == 1)
				fill(0);
			else 
				fill(255);
			rect(block_size * x, block_size * y, block_size, block_size);
		}
	}
}