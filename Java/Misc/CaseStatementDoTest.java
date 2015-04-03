public class CaseStementDoTest {
	public static void main(String[] args) {
		int i = 0;
		switch(i) {
			case 1: do{

				case 2: break;
				case 3: break;

			} while(i++ < 5);
			
			default: break;
		}
	}
}