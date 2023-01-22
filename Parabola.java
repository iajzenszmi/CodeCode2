
import java.awt.Graphics;  
import javax.swing.JFrame;  
  
public class Parabola extends JFrame {  
    public Parabola() {  
        super("Parabola");  
        setSize(400,250);  
        setVisible(true);  
    }  
    public void paint(Graphics g) {  
        g.drawLine(20,230,380,230);  
        g.drawLine(20,230,200,30);  
        g.drawLine(200,30,380,230);  
        int x,y;  
        for(x=20; x<=380; x++) {  
            y=(int)(-Math.pow(x-200,2)/100)+230;  
            g.fillOval(x,y,2,2);  
        }  
    }  
    public static void main(String[] args) {  
        Parabola app = new Parabola();  
        app.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);  
    }  
}
