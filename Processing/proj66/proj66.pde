import java.util.*;

void setup() {
	size(500,500,OPENGL);
}

void draw() {
	
}

class Node {
	Node pnode;
	String pedge;
	Map<String, Node> children;
	boolean value;

	Node() {
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
};

class Tree {
	Node root;

	Tree() {
		root = new Node();
	}

	void add(String s) {
		Node t = root;
		int c = 0;
		A: while(c < t.children.size() && s.length() > 0) {
			for(String e : t.children.keySet()) {
				if(e.charAt(0) != s.charAt(0)) {
					c++;
					continue;
				}
				if(s.indexOf(e) == 0) {
					s = s.substring(e.length());
					t = t.children.get(e);
					c = 0;
					continue A;
				}

				int i = 1;
				while(i < s.length() && i < e.length() && s.charAt(i) == e.charAt(i)) 
					i++;
				String comm = s.substring(0, i);
				s = s.substring(i);
				Node n = new Node(t, comm, null, false);
				t.children.put(n.pedge, n);

				if(s.length() > 0)
					n.children.put(s, new Node(n, s, null, true));
				else
					n.value = true;
				Node m = t.children.get(e);
				m.pnode = n;
				m.pedge = e.substring(i);	
				n.children.put(m.pedge, m);

				t.children.remove(e);
				return;
			}
		}
		if(s.length() == 0)
			t.value = false;
		else
			t.children.put(s, new Node(t, s, null, true));
	}
}