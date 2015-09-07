String RETINA2D = "processing.core.PGraphicsRetina2D";
Widget root_widget;
void setup() {
	size(1200, 800, JAVA2D);
	smooth(8);
	//frame.setResizable(true);
	textFont(createFont("Courier New", 16, true));
	textAlign(CENTER,CENTER);
	hint(ENABLE_RETINA_PIXELS);
	initWidgets();
	println(PFont.list());
}

void draw() {
	root_widget.draw();
	update();
}

void update() {
	if(!focused) 
		root_widget.defocus();
}

void initWidgets() {
	root_widget = new Widget(new Rect(0, 0, width, height), "root");
	TextWidget t = new TextWidget(new Rect(50, 50, 500, 500), "text");
	root_widget.addSubWidget(t);
}
void mousePressed() {
	root_widget.focus(mouseX, mouseY);
}

void keyTyped() {
	root_widget.type(key);
}

class Rect {
	float x, y, w, h;
	Rect(float x, float y, float w, float h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	boolean contains(float x, float y) {
		return (x > this.x && x < this.x + this.w) && (y > this.y && y < this.y + this.h);
	}
};

class Widget {
	Widget super_widget;
	ArrayList<Widget> sub_widgets;
	Rect bounds;
	String id;
	boolean focus;
	float xoff, yoff;
	Widget(Rect bounds, String id) {
		this.bounds = bounds;
		this.id = id;
		this.focus = false;
		sub_widgets = new ArrayList<Widget>();
		updateOffset();
	}
	private void updateOffset() {
		Widget temp_widget = this;
		xoff = 0; 
		yoff = 0;
		while(temp_widget.super_widget != null) {
			temp_widget = temp_widget.super_widget;
			xoff += temp_widget.bounds.x;
			yoff += temp_widget.bounds.y;
		}
	}
	void addSubWidget(Widget w){
		w.super_widget = this;
		this.sub_widgets.add(w);
		w.updateOffset();
	}
	void draw() {
		if(focus)
			fill(255);
		else 
			fill(100);
		rect(this.bounds.x + xoff, this.bounds.y + yoff, this.bounds.w, this.bounds.h);
		fill(0);
		text(this.id, this.bounds.x + xoff + this.bounds.w/2, this.bounds.y + yoff + this.bounds.h/2);
		for (Widget widget : sub_widgets) {
			widget.draw();
		}
	}
	void focus(float x, float y) {
		this.focus = false;
		for(Widget widget : sub_widgets) {
			if(widget.bounds.contains(x - widget.xoff, y - widget.yoff)) {
				widget.focus(x, y);
				return;
			}
			else {
				widget.defocus();
			}
		}
		this.focus = true;
	}
	void defocus() {
		this.focus = false;
		for(Widget widget : sub_widgets) {
			widget.defocus();
		}
	}
	void type(char chr) {
		for(Widget widget : sub_widgets) {
			widget.type(chr);
		}
	}
};

class ScrollWidget extends Widget {
	float sbar_proportion, ymin, ymax;
	ScrollWidget(Rect bounds, String id, float sbar_proportion, float ymin, float ymax) {
		super(bounds, id);
		this.sbar_proportion = sbar_proportion;
		this.ymin = ymin;
		this.ymax = ymax;
	}
};

class TextWidget extends Widget{
	float LINE_NUMBER_PADDING = 20;
	String line_data;

	ArrayList<StringBuilder> data;
	int ticker_r, ticker_c;
	TextWidget(Rect bounds, String id) {
		super(bounds, id);
		data = new ArrayList<StringBuilder>();
		data.add(new StringBuilder(""));
		this.ticker_r = 0;
		this.ticker_c = 0;
		line_data = "";
		for(int i = 0; i < 20; i++) {
			line_data += i + "\n";
		}
	}

	void type(char chr) {
		if(!focus)
			return;
		pushMatrix();
		
		if(chr == BACKSPACE) {
			if(ticker_c == 0)
				return;
			data.get(ticker_r).deleteCharAt(ticker_c - 1);
			ticker_c--;
		}
		else if(key != CODED) {
			data.get(ticker_r).insert(ticker_c, chr);
			ticker_c++;
		}
		popMatrix();
	}

	void draw() {
		super.draw();
		pushStyle();
		textAlign(LEFT, TOP);
		text(data.get(0).toString(), this.bounds.x + this.xoff + LINE_NUMBER_PADDING, this.bounds.y + this.yoff);
		textAlign(RIGHT, TOP);
		text(line_data, this.bounds.x + this.xoff, this.bounds.y + this.yoff);
		popStyle();
	}
};