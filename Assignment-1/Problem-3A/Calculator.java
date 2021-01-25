package problem3a;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import javax.swing.JFrame;
import java.awt.Color;

// the main calculator class containing all 3 interfaces and background tasks
public class Calculator extends JFrame implements KeyListener {
    // background task for iterating over both functions and digits (Single thread)
    BackgroundTask backgroundTask;
    // interface for digits [0-9]
    NumberInterface numberInterface;
    // interface for operators (+,-,*,/,CLEAR and EVALUATE)
    FunctionInterface functionInterface;
    // interface for displaying expression and result
    DisplayInterface displayInterface;

    // initialising the variables and building the user interface
    public Calculator(){
        super("Calculator 3A");
        buildUserInterface();
        backgroundTask = new BackgroundTask(this);
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

    // execute the single background tasks
    void startExecution(){
        backgroundTask.execute();
    }

    // key press events definition
    // there are 2 turns (The first enter takes the digit and the second enter takes the function as input and so on)
    public void keyPressed(KeyEvent e){
        // take input by using enter key always
        if(e.getKeyCode() == KeyEvent.VK_ENTER){
            switch(backgroundTask.turn){
                // if turn is 0 then take digit as input
                case 0:
                    char c = (char)(backgroundTask.digitID + '0');
                    displayInterface.addCharacter(c);
                    backgroundTask.turn = 1;
                    break;
                // if turn is 1 then take function as input
                case 1:
                    switch(backgroundTask.functionID){
                        case 0:
                            // appends * operator
                            displayInterface.addCharacter('*');
                            backgroundTask.turn = 0;
                            break;
                        case 1:
                            // appends / operator
                            displayInterface.addCharacter('/');
                            backgroundTask.turn = 0;
                            break;
                        case 2:
                            // appends + operator
                            displayInterface.addCharacter('+');
                            backgroundTask.turn = 0;
                            break;
                        case 3:
                            // appends - operator
                            displayInterface.addCharacter('-');
                            backgroundTask.turn = 0;
                            break;
                        case 4:
                            // clear the expression interface
                            displayInterface.clearText();
                            backgroundTask.turn = 0;
                            break;
                        case 5:
                            // evaluates the expression
                            displayInterface.evaluateExpression();
                            backgroundTask.turn = 1;
                            break;
                    }
                    break;
            }
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
