
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Insets;
import java.awt.Point;
import java.awt.Rectangle;
import javax.swing.JComponent;
import java.util.Queue;
import java.util.LinkedList;

public class ScreenSaverComponent extends JComponent
{
	// Starting color for drawing
	private static final Color STARTING_COLOR = Color.magenta;
	
	// Min and max values for translations of x and y
	private static final int MIN_CHANGE = 5;
	private static final int MAX_CHANGE = 50;
	
	private Queue<Circle> circles;
	private int max;
	private int diameter;
	private int chgX;
	private int chgY;
	private int x;
	private int y;
	private Color currentColor;
	public ScreenSaverComponent(int max, int diameter, int chgX, int chgY) 
	{
		this.max = max;
		this.diameter = diameter;
		this.chgX = chgX;
		this.chgY = chgY;
		this.x = getWidth()/2;
		this.y = getHeight()/2;
		this.circles = new LinkedList<>();
		this.currentColor = STARTING_COLOR;
	}

	/** Add a new circle to be drawn and then draw all circles.
	 *  @param g the Graphics object for drawing in this component
	 */
	public void paintComponent(Graphics g) 
	{
		Graphics2D gr2 = (Graphics2D) g;
		int maxWidth = getWidth();
		int maxHeight = getHeight();
		
		x += chgX;
		y += chgY;
		if(checkEdge()) {
			currentColor = new Color((int) (Math.random() * 255), (int) (Math.random() * 255), (int) (Math.random() * 255), (int) (Math.random() * 255));
		}
		addCircle();
		drawAll(gr2);
	}
	
	private void drawAll(Graphics2D gr)
	{
		for(Circle c : circles) {
			c.draw(gr, diameter);
		}
	}
	
	private void addCircle() 
	{	
		circles.add(new Circle(new Point(x, y), currentColor));
		if(circles.size() > max)
			circles.poll();
	}
		
	private boolean checkEdge() 
	{
		if(x + diameter > getWidth()) {
			chgX = -(int) (Math.random() * (MAX_CHANGE - MIN_CHANGE + 1) + MIN_CHANGE);
			return true;
		}
		else if(x < 0) {
			chgX = (int) (Math.random() * (MAX_CHANGE - MIN_CHANGE + 1) + MIN_CHANGE);	
			return true;
		}		
		if(y + diameter > getHeight()) {
			chgY = -(int) (Math.random() * (MAX_CHANGE - MIN_CHANGE + 1) + MIN_CHANGE);	
			return true;
		}
		else if(y < 0) {
			chgY = (int) (Math.random() * (MAX_CHANGE - MIN_CHANGE + 1) + MIN_CHANGE);	
			return true;
		}

		return false;
	}
}