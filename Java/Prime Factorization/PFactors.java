public class PFactors {
	public static void main(String[] args) {
		for(int i = 0; i < 36; i++) {
			for(int k = 0; k < 20; k++) {
				if (i == 0) {
					if (isPrime(k))
						System.out.printf("%-7d", k);
					continue;
				}
				if (k == 0) {
					System.out.printf("%-7d", i);
				} else if (!isPrime(k)) {
					continue;
				} 		
				else {
					System.out.printf("%-7s", Integer.toString(i, k));
				}	
			}
			System.out.println();
		}
	}

	public static boolean isPrime(int n) {
		for(int i = 2; i < n; i++) {
			if (n % i == 0) {
				return false;
			}
		} 
		return true;
	}
}