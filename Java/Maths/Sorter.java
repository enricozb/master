public class Sorter {

	// Digit at index i, of number x in base b
	public static int dat(int x, int b, int i) {
		return (int) ( x / Math.pow(b,i) ) % b;
	}

	// Returns 0 if x and y are equal; 1 otherwise
	public static int eq(int x, int y) {
		return 1 - (int) Math.ceil(Math.abs(x - y) / ( (float) Math.abs(x - y) + 1));
	}

	// Compares x and y. {x < y : -1, x = y: 0, x > y: 1}
	public static int com(int x, int y) {
		return Math.abs(x - y) / ( (x - y) + eq(x - y, 0) );
	}

	// Number of digits of number x in base b
	public static int nd(int x, int b) {œ
		return (int) Math.ceil(Math.log(x + 1)/Math.log(b));
	}

	// Counts how many digits less than n in x, and how many instances of n in x
	// in an index prior to j
	public static int c(int x, int n, int j ) {
		int s1 = 0;
		for(int i = 0; i <= nd(x, 10) - 1; i++) {
			s1 += eq(-1, com(n, dat(x, 10, i)));
		}
		int s2 = 0;
		for(int i = 0; i <= j - 1; i++) {
			s2 += eq(n, dat(x, 10, i));
		}
		return s1 + s2;
	}

	// Sorts x in ascending order right ot left
	public static int sort(int x) {
		int s = 0;
		for(int i = 0; i <= nd(x, 10) - 1; i++) {
			s += dat(x, 10, i) * (int) Math.pow(10, nd(x, 10) - 1 - c(x, dat(x, 10, i), i));
		}
		return s;
	}

	public static void main(String[] args) {
		int x = 12043;
		System.out.println(sort(x));
	}
}