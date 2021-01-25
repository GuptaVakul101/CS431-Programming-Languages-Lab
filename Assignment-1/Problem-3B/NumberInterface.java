package problem3b;

import java.util.ArrayList;
import java.awt.GridLayout;
import java.awt.Color;
import javax.swing.JButton;
import javax.swing.JPanel;

// class for the number interface (digits [0-9])
public class NumberInterface {
    // array of digit key buttons
    public ArrayList<JButton> digitKeys;
    // number panel for the GUI
    public JPanel digitPanel;

    NumberInterface(){
        digitKeys = new ArrayList<>();
        buildUserInterface();
    }

    // add all the digit key buttons
    void addDigitKeys(){
        for(int i = 0; i < 10; i++){
            JButton digitKey = new JButton(Integer.toString(i));
            digitKey.setBackground(Color.GREEN);
            digitKey.setOpaque(false);
            digitKeys.add(digitKey);
        }
        for(int i = 7; i > 0; i -= 3){
            for(int j = i; j < i+3; j++){
                digitPanel.add(digitKeys.get(j));
            }
        }
        digitPanel.add(digitKeys.get(0));
    }

    // function for setting the layout paramters
    void setLayout(){
        GridLayout layout = new GridLayout(4, 3);
        layout.setHgap(Constants.PADDING);
        layout.setVgap(Constants.PADDING);
        digitPanel = new JPanel(layout);
        digitPanel.setLocation(Constants.PADDING, Constants.HEIGHT_OF_DISPLAY_FIELD+2*Constants.PADDING);
        digitPanel.setSize(Constants.WIDTH-2*Constants.PADDING, 4*Constants.HEIGHT_OF_FIELD + 3*Constants.PADDING);
        digitPanel.setBackground(Color.LIGHT_GRAY);
    }

    // build the GUI
    private void buildUserInterface(){
        setLayout();
        addDigitKeys();
    }
}
