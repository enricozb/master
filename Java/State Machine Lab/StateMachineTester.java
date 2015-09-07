import java.util.Scanner;
import java.io.IOException;
public class StateMachineTester {
	public static void main(String[] args) throws IOException {
		StateMachine machine = new StateMachine();
		machine.build();

		Scanner scan = new Scanner(System.in);

		System.out.println("Target node value to encode:");
		String target = scan.nextLine();

		System.out.printf("Encoded instructions: %s\n", machine.encode(target));

		System.out.println("Instruction set to decode:");
		String instructions = scan.nextLine().trim();

		System.out.printf("Nodes found: %s\n", machine.decode(instructions));
	}
}