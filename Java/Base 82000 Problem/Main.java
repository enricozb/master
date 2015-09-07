public class Main {

	public static boolean isBinal(int n, int base) {
		return Integer.toString(n, base).matches("[01]+");
	}

	public static void displayPattern(int start, int end, int base) {
		int isBinalCount = -1;
		boolean binalSection = false;

		for(int i = start; i <= end; i++) {
			boolean isBinal = isBinal(i, base);
			if(isBinalCount == -1) {
				isBinalCount = 1;
				binalSection = isBinal;
			}
			else {
				if(binalSection != isBinal) {
					System.out.printf("%-5d: %d : %d\n", i-1, binalSection ? 1 : 0, isBinalCount);
					isBinalCount = 1;
					binalSection = isBinal;
				}
				else {
					isBinalCount += 1;
				}
			}
		}
		//System.out.println(isBinalCount);
	}

	public static void main(String[] args) {
		displayPattern(0, 1000, 7);
	}
}