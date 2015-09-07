import java.util.Map;
import java.util.TreeMap;
import java.util.Scanner;
import java.io.File;
import java.io.IOException;
import java.util.TreeSet;
import java.util.Stack;

/**
 * StateMachine.java
 */

public class StateMachine {
	
	private Map<String, Node> nodes; //Used for random access of any Node. The String keys are the values of the Nodes to which they map.
	private Node root;				 //The root node, always has a value of "#"

	/** 
	 *	Creates a new StateMachine. Initializes its root and nodes Map 
	 */
	public StateMachine() {
		root = new Node("#");
		nodes = new TreeMap<String, Node>();
		nodes.put("#", root);
	}

	/** 
	 *	Takes input from user to build a StateMachine with the given instructions.
	 */
	public void build() throws IOException{
		Scanner scan = new Scanner(new File("in.txt"));
		System.out.println("How many instructions?");
		int n = scan.nextInt();
		System.out.println(n);
		System.out.printf("Type out %d instruction%s%n", n, n == 1 ? "" : "s");

		for(int i = 0; i < n; i++) {
			String a = scan.next();
			String b = scan.next();
			String c = scan.nextLine().trim();
			System.out.printf("%s %s %s\n", a, b, c);
			if(nodes.get(a) == null) {
				nodes.put(a, new Node(a));
			}
			if(nodes.get(c) == null) {
				nodes.put(c, new Node(c));
			}
			nodes.get(a).addEdge(b, nodes.get(c));
		}
	}

	/**
	 * Encodes the path taken in order to reach the Node containing the target value.
	 * Uses a recursive depth first search with a TreeSet containing the visited nodes.
	 * @param target The value of the Node which is trying to be reached.
	 * @return The path taken to reach the node with the target value. Null if no path.
	 */
	public String encode(String target) {
		Stack out = new Stack<String>();
		if(encode(target, root, new TreeSet<Node>(), out)) {
			String path = "";
			while(!out.isEmpty()) {
				path = out.pop() + path;
			}
			return path;
		}
		return null;
	}

	/**
	 * The helper method for the encode subroutine. 
	 * Uses a recursive depth first search with a TreeSet containing the visited nodes.
	 * Uses a Stack in order to pass in the current path as a reference and not by value.
	 * @param target The value of the Node which is trying to be reached.
	 * @param currNode The current Node which the depth first search is at
	 * @param visited The Nodes that have been visited.
	 * @param currEncoded The path currently taken as a Stack
	 * @return Whether or not it has found it's target
	 */
	private boolean encode(String target, Node currNode, TreeSet<Node> visited, Stack<String> currEncoded) {
		if(currNode.getValue().equals(target))
			return true;
		for(String edge : currNode.getEdges().keySet()) {
			Node node = currNode.nodeAtEdge(edge);
			if(!visited.contains(node)) {
				visited.add(node);
				currEncoded.push(edge);
				if(encode(target, node, visited, currEncoded)) {
					return true;
				}
				currEncoded.pop();
				visited.remove(node);
			}
		}
		return false;
	}

	public String decode(String instructions) {
		String s = instructions;
		String out = "";
		String curr = "#";
		for (char a : s.toCharArray()) {
			out += nodes.get(curr).nodeAtEdge("" + a).getValue();
			curr = nodes.get(curr).nodeAtEdge("" + a).getValue();
		}
		return out;
	}
}