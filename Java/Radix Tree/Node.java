import java.util.*;

public class Node {
	Node pnode;
	String pedge;
	Map<String, Node> children;
	boolean value;

	public Node() {
		this.pnode = null;
		this.pedge = null;
		this.children = new TreeMap<String, Node>();
		this.value = false;
	}	

	public Node(Node pnode, String pedge, Map<String, Node> children, boolean value) {
		this.pnode = pnode;
		this.pedge = pedge;
		if(children == null)
			this.children = new TreeMap<String, Node>();
		else
			this.children = children;
		this.value = value;
	}
}