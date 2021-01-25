package problem3b;

import java.awt.Color;
import java.awt.GridLayout;
import javax.swing.JPanel;
import javax.swing.JButton;

// class for the function interface (+,-,*,/,CLEAR,EVALUATE)
public class FunctionInterface {
    // different function buttons
    public JButton btnMultiply;
    public JButton btnDivide;
    public JButton btnAdd;
    public JButton btnSubtract;
    public JButton btnClear;
    public JButton btnEval;
    // the function panel for GUI
    public JPanel functionPanel;

    FunctionInterface(){
        buildUserInterface();
    }

    // function for setting button paramters
    void setButtonParams(JButton button){
        button.setBackground(Color.RED);
        button.setOpaque(false);
        functionPanel.add(button);
    }

    // function for setting panel layout paramters
    void setLayout(){
        GridLayout layout = new GridLayout(2, 3);
        layout.setVgap(Constants.PADDING);
        layout.setHgap(Constants.PADDING);

        functionPanel = new JPanel(layout);
        functionPanel.setLocation(Constants.PADDING, Constants.HEIGHT_OF_DISPLAY_FIELD+6*Constants.PADDING+4*Constants.HEIGHT_OF_FIELD);
        functionPanel.setSize(Constants.WIDTH-2*Constants.PADDING, 2*Constants.HEIGHT_OF_FIELD+Constants.PADDING);
        functionPanel.setBackground(Color.LIGHT_GRAY);
    }

    // builds the GUI
    void buildUserInterface(){
        // set layout paramaters
        setLayout();

        // set paramters for all the buttons
        btnMultiply = new JButton("*");
        setButtonParams(btnMultiply);

        btnDivide = new JButton("/");
        setButtonParams(btnDivide);

        btnAdd = new JButton("+");
        setButtonParams(btnAdd);

        btnSubtract = new JButton("-");
        setButtonParams(btnSubtract);

        btnClear = new JButton("CLEAR");
        setButtonParams(btnClear);

        btnEval = new JButton("EVALUATE");
        setButtonParams(btnEval);
    }
}
