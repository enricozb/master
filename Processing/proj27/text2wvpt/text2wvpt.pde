BufferedReader read;
String line;

float sampleRate = 44100;
float timeSize = 1024;
void setup() {
	read = createReader("fft.txt");
}

String newLine()
{
	try{
		return read.readLine();
	}
	catch(IOException e)
	{
		return null;
	}
}

void draw() {
	String line = newLine();
	while(line != null)
	{
		println(line);
		line = newLine();
	}
}