import java.util.Map;
import java.util.TreeMap;

/**
 * Node.java
 * A node class for edges and nodes with values of Strings
 * @author Enrico Borba
 */

public class Node implements Comparable<Node> {
	private String value;
	private Map<String, Node> edges;

	/** 
	 * Creates a Node instance object.
	 * @param value The string value which the node holds.
	 */
	public Node(String value) {
		this.value = value;
		edges = new TreeMap<String, Node>();
	}

	/**
	 * Gets the edges available to the node.
	 * @return edges The edges available to the node.
	 */
	public Map<String, Node> getEdges() {
		return edges;
	}

	/**
	 * Gets the value stored at the node.
	 * @return value The string value stored by the node.
	 */
	public String getValue() {
		return value;
	}

	/**
	 * Resets the string value held by the Node to a new value.
	 * @param value The new string value to be held by the Node.
	 */
	public void setValue(String value) {
		this.value = value;
	}

	/**
	 * Adds a new edge-to-node mapping.
	 * @param string The string value of the edge.
	 * @param node The node to be pointed to by the new edge.
	 */
	public void addEdge(String string, Node node) {
		edges.put(string, node);
	}

	/**
	 * Attempts to get a node at a specific edge.
	 * @param string The edge attempting to be traversed.
	 * @return The Node reached by the edge traversed, null if no such edge exists.
	 */
	public Node nodeAtEdge(String string) {
		return edges.get(string);
	}

	/**
	 * @see java.lang.Comparable#compareTo(T o)
	 */
	public int compareTo(Node node) {
		return this.getValue().compareTo(node.getValue());
	}
}