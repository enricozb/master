public class Test {
	
	public static void f() {
		
	}

	public static void main(String... args) {
		System.out.printf("%s", 1);
		if(true) 
			f(),
			f();
	}
}