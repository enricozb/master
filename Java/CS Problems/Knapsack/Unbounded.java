import java.util.Arrays;
public class Unbounded {
	 
	static int[] v = {1, 5, 7, 12};
	static int[] w = {2, 3, 5, 9};

	static int maxWeight = 15;

	public static void main(String... args) {
		int[][] dp = new int[maxWeight + 1][v.length];

		for(int weight = 1; weight < dp.length; weight++) {
			for(int i = 0; i < v.length; i++) {
				if(weight >= w[i]) {
					int max = 0;
					for(int k = 0; k < v.length; k++) {
						max = Math.max(max, dp[weight - w[i]][k]);
					}
					dp[weight][i] = max + v[i];
				}
			}
		}

		for(int i = 0; i < dp.length; i++) {
			System.out.println(Arrays.toString(dp[i]));
		}
	}

}