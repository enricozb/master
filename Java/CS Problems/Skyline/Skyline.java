import java.util.*;
import java.io.*;

public class Skyline {

	public static void main(String... args) throws IOException{
		Scanner scan = new Scanner(new File("dat.txt"));
		int n = scan.nextInt();
		int[][] buildings = new int[n][3];

		int maxh = 0;
		int maxy = 0;

		while(n-- != 0) {
			buildings[n][0] = scan.nextInt(); //x, w, h
			buildings[n][1] = scan.nextInt();
			buildings[n][2] = scan.nextInt();
			maxh = Math.max(maxh, buildings[n][2]);
			maxy = Math.max(maxy, buildings[n][1] + buildings[n][2] - 1);
		}
		char[][] board = new char[maxh][maxy];
	}
}