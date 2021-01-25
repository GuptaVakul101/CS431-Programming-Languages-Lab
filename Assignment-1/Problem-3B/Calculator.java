package problem3b;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import javax.swing.JFrame;
import java.awt.Color;

// the main calculator class containing all 3 interfaces and background tasks
public class Calculator extends JFrame implements KeyListener {
    // background task for iterating over the functions
    FunctionBackgroundTask functionBackgroundTask;
    // background task for iterating over the digits
    NumberBackgroundTask numberBackgroundTask;
    // interface for digits [0-9]
    NumberInterface numberInterface;
    // interface for operators (+,-,*,/,CLEAR and EVALUATE)
    FunctionInterface functionInterface;
    // interface for displaying expression and result
    DisplayInterface displayInterface;

    // initialising the variables and building the user interface
    public Calculator(){
        super("Calculator 3B");
        buildUserInterface();
        functionBackgroundTask = new FunctionBackgroundTask(this);
        numberBackgroundTask = new NumberBackgroundTask(this);
    }

    // fucntion for setting parameters such as location, visibility and focus
    private void setDisplayParams(){
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setLocationRelativeTo(null);
        this.setResizable(false);
        this.setVisible(true);
        addKeyListener(this);
        this.setFocusable(true);
        this.setFocusTraversalKeysEnabled(false);
    }

    // function for making the GUI of the calculator
    private void buildUserInterface(){
        this.setSize(Constants.WIDTH, Constants.HEIGHT);
        this.getContentPane().setBackground(Color.LIGHT_GRAY);
        this.getContentPane().setLayout(null);

        displayInterface = new DisplayInterface();
        this.add(displayInterface.display);

        numberInterface = new NumberInterface();
        this.add(numberInterface.digitPanel);

        functionInterface = new FunctionInterface();
        this.add(functionInterface.functionPanel);

        // set parameters such as location, visibility and focus
        setDisplayParams();
    }

    // execute the two background tasks
    void startExecution(){
        numberBackgroundTask.execute();
        functionBackgroundTask.execute();
    }

    // key press events definition
    public void keyPressed(KeyEvent e){
        // take function as input by using space
        if(e.getKeyCode() == KeyEvent.VK_SPACE){
            switch(functionBackgroundTask.id){
                case 0:
                    // appends * operator
                    displayInterface.addCharacter('*');
                    break;
                case 1:
                    // appends / operator
                    displayInterface.addCharacter('/');
                    break;
                case 2:
                    // appends + operator
                    displayInterface.addCharacter('+');
                    break;
                case 3:
                    // appends - operator
                    displayInterface.addCharacter('-');
                    break;
                case 4:
                    // clear the expression interface
                    displayInterface.clearText();
                    break;
                case 5:
                    // evaluates the expression
                    displayInterface.evaluateExpression();
                    break;
            }
        }
        // take digit as input by using enter
        else if(e.getKeyCode() == KeyEvent.VK_ENTER){
            char c = (char)(numberBackgroundTask.id + '0');
            displayInterface.addCharacter(c);
        }
        this.repaint();
    }

    public void keyReleased(KeyEvent e){

    }

    public void keyTyped(KeyEvent e){

    }

    // main function
    public static void main(String[] args){
        Calculator calculator = new Calculator();
        calculator.startExecution();
    }
}
