import java.util.*;

public class Tree {
	Node root;

	public Tree() {
		root = new Node();
	}

	public void add(String s) {
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

	public String toString() {
		return toString(root, "");
	}

	public String toString(Node n, String off) {
		String s = "[" + off;
		int size = n.children.size();
		int i = 0;
		for(String e : n.children.keySet()) {
			String comma = (i == size - 1 ? "" : ", ");
			s += e + toString(n.children.get(e), off + "\t") + comma;
			i++;
		}
		s += "]";
		if(i == 0)
			return "[]";
		return s;
	}

}