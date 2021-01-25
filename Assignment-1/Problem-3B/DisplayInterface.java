package problem3b;

import java.awt.Font;
import java.awt.Color;
import java.util.Stack;
import javax.swing.JTextField;

// class for the display interface (expression and result)
public class DisplayInterface {
    public JTextField display;

    // build the user interface for that
    DisplayInterface(){
        buildUserInterface();
    }

    // function for setting paramters like size, font and background color
    private void setDisplayParams(){
        Font font = new Font("monospaced", Font.BOLD, 20);
        display.setFont(font);
        display.setBackground(Color.WHITE);
        display.setEditable(false);
        display.setSize(Constants.WIDTH-2*Constants.PADDING, Constants.HEIGHT_OF_DISPLAY_FIELD);
    }

    // building the user interface
    private void buildUserInterface(){
        display = new JTextField("");
        display.setLocation(Constants.PADDING, Constants.PADDING);
        // set paramters like size, font and background color
        setDisplayParams();
    }

    // empties the text field (CLEAR)
    public void clearText(){
        display.setText("");
    }

    // checks if a expression is mathematically valid or not
    private boolean isExpressionValid(){
        String temp = display.getText();
        Boolean isValid=true;
        if(temp.length() == 0){
            isValid=false;
        }
        if(isValid==false){
            return isValid;
        }
        char end = temp.charAt(temp.length()-1);
        if(!(end >= '0' && end <= '9')){
            isValid=false;
        }
        return isValid;
    }

    // add character to the expressions so that display can be updated
    public void addCharacter(char c){
        if(!(c >= '0' && c <= '9')){
            if(!isExpressionValid()){
                System.out.println("OPERATION NOT ALLOWED!");
                return;
            }
        }
        String temp = display.getText();
        if(c >= '0' && c <= '9'){
            temp += c;
        }
        else{
            temp += " "+c+" ";
        }
        display.setText(temp);
    }

    // It applies the corresponding operator and gives the desired result
    private static int useOperator(char operator, int b, int a)
    {
        switch (operator){
        case '*':
            return a * b;
        case '/':
            if (b == 0){
                // edge case when trying to divide by zero
                System.out.println("CANNOT DIVIDE BY ZERO!. Returning 0 for the operation...");
                return 0;
            }
            return a / b;
        case '+':
            return a + b;
        case '-':
            return a - b;
        }
        return 0;
    }

    // check for operator precedence as required in the expression evaluation algorithm
    private static boolean hasPrecedence(char op1, char op2){
        if ((op2 == '+' || op2 == '-') && (op1 == '*' || op1 == '/')){
            return false;
        }
        if (op2 == '(' || op2 == ')'){
            return false;
        }
        return true;
    }

    // evaluate the expression using stacks
    public void evaluateExpression(){
        String expression = display.getText();
        if(expression.length() == 0){
            return;
        }

        char[] tokens = expression.toCharArray();
        char c = tokens[tokens.length-1];
        if(!(c >= '0' && c <= '9')){
            System.out.println("OPERATION NOT ALLOWED!");
            return;
        }

        Stack<Character> bufferOperator = new Stack<Character>();
        Stack<Integer> bufferValues = new Stack<Integer>();

        boolean isNegative = false;
        for(int i = 0; i < tokens.length; i++){
            if(tokens[i] == ' '){
                isNegative = false;
                continue;
            }

            if(tokens[i] == '-' && i+1 < tokens.length && (tokens[i+1] >= '0' && tokens[i+1] <= '9')){
                isNegative = true;
            }
            else if (tokens[i] == '*' || tokens[i] == '/' || tokens[i] == '+' || tokens[i] == '-') {
                while (!bufferOperator.empty() && hasPrecedence(tokens[i], bufferOperator.peek())){
                    bufferValues.push(useOperator(bufferOperator.pop(), bufferValues.pop(), bufferValues.pop()));
                }

                bufferOperator.push(tokens[i]);
                isNegative = false;
            }
            else if (tokens[i] >= '0' && tokens[i] <= '9'){
                StringBuffer sbuf = new StringBuffer();
                while (i < tokens.length && tokens[i] >= '0' && tokens[i] <= '9'){
                    sbuf.append(tokens[i++]);
                }
                if(isNegative){
                    bufferValues.push(-Integer.parseInt(sbuf.toString()));
                }
                else{
                    bufferValues.push(Integer.parseInt(sbuf.toString()));
                }
                isNegative = false;
            }
        }
        while (!bufferOperator.empty()){
            bufferValues.push(useOperator(bufferOperator.pop(), bufferValues.pop(), bufferValues.pop()));
        }
        display.setText(Integer.toString(bufferValues.pop()));
    }
}
