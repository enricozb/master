import java.util.Arrays;
public class Bounded {
	 
	static int[] v = {0, 1, 5, 7, 12};
	static int[] w = {0, 2, 3, 5, 9};

	static int maxWeight = 15;

	public static void main(String... args) {
		int[][] dp = new int[maxWeight + 1][v.length];

		for(int weight = 1; weight < dp.length; weight++) {
			for(int i = 1; i < v.length; i++) {
				if(weight >= w[i]) {
					dp[weight][i] = Math.max(dp[weight][i - 1], dp[weight-w[i]][i - 1] + v[i]);					
				}
				else if(i > 0){
					dp[weight][i] = dp[weight][i - 1];
				}
			}
		}

		for(int i = 0; i < dp.length; i++) {
			System.out.println(Arrays.toString(dp[i]));
		}
	}

}