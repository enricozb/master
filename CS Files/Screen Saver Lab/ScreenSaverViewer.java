
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Timer;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

public class ScreenSaverViewer
{
	/** Timer to repaint component */
	private static Timer drawTimer;

	public static void main(String[] args) 
	{
		int maxCircles = getPositiveInt(
				"Enter maximum number of circles to display at one time:");
		int diameter = getPositiveInt("Enter diameter of circles:");
		int chgX = getInt("Enter initial change value for x:");
		int chgY = getInt("Enter initial change value for y:");
		
		JFrame frame = new JFrame();
		frame.setSize(800, 600);
		frame.setTitle("Screen Saver");
		frame.setLocation(0, 0);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		final ScreenSaverComponent screen = new ScreenSaverComponent(maxCircles, diameter, chgX, chgY);
		frame.add(screen);
		frame.setVisible(true);
		
		// Listener for timer to re-draw circles
		class AdvanceTimerListener implements ActionListener
		{
			public void actionPerformed(ActionEvent event)
			{
				drawTimer.stop();
				screen.repaint();
				drawTimer.start();
			}
		}
		ActionListener advanceListener = new AdvanceTimerListener();

		final int DELAY = 50; // Milliseconds between timer ticks
		drawTimer = new Timer(DELAY, advanceListener);
		drawTimer.start();      
	}
	
	/** Retrieve a positive integer from the user with a given prompt
	 *  @param prompt the request to be given to the user
	 *  @return a positive integer
	 */
	public static int getPositiveInt(String prompt) 
	{
		String input;
		int posInt;
		while (true) 
		{
			try 
			{
				input = JOptionPane.showInputDialog(null, prompt);
				posInt = Integer.parseInt(input);
				if (posInt < 1) 
				{
					throw new Exception("Must be positive value.  Try again");
				}
				return posInt;
			} 
			catch (NumberFormatException e) 
			{
				JOptionPane.showMessageDialog(null, "Numbers only.  Try again.");
				
			} 
			catch (Exception e) 
			{
				JOptionPane.showMessageDialog(null, e.getMessage());
			}
		}
	}

	/** Retrieve an integer from the user with a given prompt
	 *  @param prompt the request to be given to the user
	 *  @return an integer
	 */
	public static int getInt(String prompt) 
	{
		String input;
		int newInt;
		while (true) 
		{
			try 
			{
				input = JOptionPane.showInputDialog(null, prompt);
				newInt = Integer.parseInt(input);
				return newInt;
			} 
			catch (NumberFormatException e) 
			{
				JOptionPane.showMessageDialog(null, "Numbers only.  Try again.");
			}
		}
	}
}