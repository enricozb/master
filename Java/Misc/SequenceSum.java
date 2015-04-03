import java.util.*;

public class SequenceSum {

	public static void main(String... args) {
		System.out.println(Arrays.toString(sumOfN(-5)));
	}

	public static int[] sumOfN(int n) {
	    int sign = n < 0 ? -1 : 1;
	    int[] arr = new int[Math.abs(n) + 1];
	    for(int i = 0; i < arr.length; i++)
	      arr[i] = arr[(int) Math.max(i-1, 0)] + i * sign;
	    return arr;
  	}
