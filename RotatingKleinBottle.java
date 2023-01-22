//generate a java program that shows a visualization of a rotating klein bottle



import java.awt.*;
import java.awt.geom.*;
import javax.swing.*;

public class RotatingKleinBottle extends JPanel {
	
	// instance variables
	private double angle;
	private GeneralPath kleinBottle;
	
	// constructor
	public RotatingKleinBottle() {
		angle = 0;
		kleinBottle = new GeneralPath();
	}
	
	// paint the klein bottle
	public void paintComponent(Graphics g) {
		Graphics2D g2d = (Graphics2D) g;
		
		// rotate the klein bottle
		g2d.rotate(Math.toRadians(angle), getWidth()/2, getHeight()/2);
		
		// create the klein bottle
		kleinBottle.moveTo(getWidth()/2, getHeight()/2);
		kleinBottle.curveTo(getWidth()/2 - 60, getHeight()/2 - 100, getWidth()/2 - 100, getHeight()/2 + 60, getWidth()/2 + 100, getHeight()/2 + 60);
		kleinBottle.curveTo(getWidth()/2 + 60, getHeight()/2 - 100, getWidth()/2, getHeight()/2, getWidth()/2, getHeight()/2);
		
		// draw the klein bottle
		g2d.setColor(Color.BLUE);
		g2d.fill(kleinBottle);
		
		// update the angle
		angle += 1;
		
		// repaint the klein bottle
		repaint();
	}
	
	public static void main(String[] args) {
		JFrame frame = new JFrame("Rotating Klein Bottle");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(400, 400);
		frame.setLocationRelativeTo(null);
		frame.setVisible(true);
		
		RotatingKleinBottle panel = new RotatingKleinBottle();
		frame.add(panel);
	}

}
