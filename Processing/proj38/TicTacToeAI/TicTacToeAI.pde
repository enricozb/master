TTTGame game = new TTTGame(3);

boolean playerTurn = true;

int move = 0;
int best = 0;

void setup() {
	size(1, 1);
	game.print();
}

void draw() {
	
}

void keyPressed()
{
	if(playerTurn)
	{
		move = int(key + "");
		println("Queued Move: " + move);
	}
	else
	{
		best = int(key + "");
		println("Best Move: " + best);
		game.play();
		game.print();
	}
	playerTurn = !playerTurn;
}

class TTTGame
{
	int[][] board; //-1 = X, 1 = O
	Neuron brain;

	TTTGame(int n)
	{
		board = new int[n][n];
		brain = new Neuron(n * n);
	}

	void play()
	{
		if(board[move/board.length][move%board.length] == 0)
		{
			println("Player played at " + move);
			board[move/board.length][move%board.length] = 1;
		}
		makeMove();
	}

	void makeMove()
	{
		int guess = brain.guess(board);
		int err = best - guess;

		brain.adjust(err,board);

		board[guess/board.length][guess%board.length] = -1;
		println("Brain played at " + guess);
	}

	void print()
	{
		for(int b[] : board)
		{
			for(int i : b)
			{
				System.out.printf("%2d ",i);
			}
			println();
		}
		brain.printWeights();
	}
};

class Neuron
{
	float[] weights;
	float c = 0.01;

	Neuron(int numIn)
	{
		weights = new float[numIn];
		for(int i = 0; i < weights.length; i++)
		{
			weights[i] = random(-1,1);
		}
	}

	Neuron(float[] weights)
	{
		this.weights = weights;
	}

	void adjust(int err, int[][] board)
	{
		for(int i = 0; i < weights.length; i++)
		{
			weights[i] += board[i/board.length][i%board.length] * err * c;
		}
	}

	int guess(int[][] board)
	{
		float sum = 0;
		for(int i = 0; i < weights.length; i++)
		{
			sum += weights[i] + board[i/board.length][i%board.length];
		}
		int guess = abs(int(sum * 100)) % weights.length;
		return abs(int(sum * 100)) % weights.length;
	}

	void printWeights()
	{
		println("Current Weights: ");
		for(int i = 0; i < weights.length; i++)
		{
			print(weights[i] + " ");
		}
		println();
	}
};