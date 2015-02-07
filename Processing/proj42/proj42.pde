void setup() {
	size(800,800);
}

void draw() {
	background(255);
}

class TTTGame
{
	Tic[][] board = new Tic[3][3];

	void drawBoard()
	{
		for(Tic[] b : board)
		{
			for(Tic t : b)
			{
				t.draw();
			}
		}
	}

	void add(Tic )
};

class Tic
{
	boolean type; //Denotes type: X = true, O = false
	void draw(int x, int y)
	{
		if(type)
		{
			
		}
		else
		{
			
		}
	}
};