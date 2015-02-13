import java.util.*;

Tree t = new Tree();

void setup() {
	size(500,500,OPENGL);
	noStroke();
	fill(255);
	t.add("banana");
}

void draw() {
	background(0);
}

class Node {
	Node pnode;
	String pedge;
	Map<String, Node> children;
	boolean value;

	float x, y;

	Node() {
		this.pnode = null;
		this.pedge = null;
		this.children = new TreeMap<String, Node>();
		this.value = false;
	}	

	Node(Node pnode, String pedge, Map<String, Node> children, boolean value) {
		this.pnode = pnode;
		this.pedge = pedge;
		if(children == null)
			this.children = new TreeMap<String, Node>();
		else
			this.children = children;
		this.value = value;
	}

	void draw() {
		ellipse(x, y, 5, 5);
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
};

class GNode {
	Node n;
	ArrayList<GEdge> childrenEdges;
	GEdge parentEdge;
	PVector loc;
	PVector acc;
	boolean fixed;
	GNode(Node n, boolean fixed) {
		this.n = n;
		loc = new PVector(0, 0);
		acc = new PVector(0, 0);
		this.fixed = fixed;
	}

	GNode(Node n) {
		this(n, false);
	}

	void setLoc(float x, float y) {
		this.loc.x = x;
		this.loc.y = y;
	}

	void addEdge(GEdge ge) {
		childrenEdges.add(ge);
	}	
};

class GEdge {
	String s;
	Node a;
	Node b;
	GEdge(Node a, Node b) {
		this.a = a;
		this.b = b;
	}
};

class GTree {
	Tree t;
	ArrayList<GNode> nodes;
	ArrayList<GEdge> edges;
	GTree(Tree t) {
		this.t = t;
		this.nodes = new ArrayList<GNode>();
		this.edges = new ArrayList<GEdge>();
	}

	void make(Tree t) {
		Node r = t.root;
		GNode gr = new GNode(r, true);
		//gr.setLoc();
		while(r.children.size() != 0) {

		}
	}
};