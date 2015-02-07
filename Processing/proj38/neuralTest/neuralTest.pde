Perceptron p = new Perceptron(3);
Trainer[] t = new Trainer[2000];
int count = 0;

void setup() {
	size(800,800,OPENGL);
	smooth(8);
	for(int i = 0; i < t.length; i++)
	{
		float x = random(width);
		float y = random(height);

		int answer = 1;
		if(y < f(x))
			answer = -1;
		t[i] = new Trainer(x,y,answer);
	}
}

void draw() {
	p.train(t[count].in,t[count].answer);
	int guess = p.feed(t[count].in);
	if(guess == 1)
		noFill();
	else 
		fill(0);
	line(0,f(0),width,f(width));
	ellipse(t[count].in[0],t[count].in[1],8,8);
	count = (count + 1) % t.length;
	if(count == 300)
		saveFrame("####.jpg");
}

float f(float x)
{
	return 2*x;
}

int sign(float a)
{
	if(a > 0)
		return 1;
	return -1;
}

class Perceptron
{
	float c = .01;

	float[] weights;

	Perceptron(int n)
	{
		weights = new float[n];
		for(int i = 0; i < n; i++)
		{
			weights[i] = random(-1,1);
		}
	}

	void train(float[] inputs, int desired)
	{
		int guess = feed(inputs);
		int err = desired - guess;
		for(int i = 0; i < weights.length; i++)
		{
			weights[i] += inputs[i] * err * c;
		}
	}

	int feed(float[] inputs)
	{
		float sum = 0;
		for(int i = 0; i < weights.length; i++)
		{
			sum += weights[i]*inputs[i];
		}
		return sign(sum);
	}
};

class Trainer
{
	float[] in;
	int answer;
	Trainer(float x, float y, int a)
	{
		in = new float[] {x,y,1};
		answer = a;
	}
};