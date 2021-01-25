package problem3a;

import javax.swing.SwingWorker;
import javax.swing.JButton;

// class for backround task for iterating over both digits and functions
public class BackgroundTask extends SwingWorker {
    private Calculator calculator;
    // requires a turn as it is a single thread so has to switch between digits and functions
    int turn;
    // for iterating over functions
    int functionID;
    // for iterating over digits
    int digitID;

    BackgroundTask(Calculator calculator){
        this.calculator = calculator;
        turn = 0;
        functionID = 0;
        digitID = 0;
    }

    // does this in background where it highlights a block for certain time and then move on to the next one
    void performInBackgroundUtility(JButton button) throws Exception {
        button.setOpaque(true);
        calculator.repaint();
        Thread.sleep(Constants.DURATION_SLEEP);
        button.setOpaque(false);
        calculator.repaint();
    }

    // it runs continuously in the background
    @Override
    protected String doInBackground() throws Exception {
        while(true){
            try{
                // if turn is 1, it highlights the IDs one by one in an iterative fashion for functions
                if(turn == 1){
                    switch(functionID){
                        case 0:
                            performInBackgroundUtility(calculator.functionInterface.btnMultiply);
                            break;
                        case 1:
                            performInBackgroundUtility(calculator.functionInterface.btnDivide);
                            break;
                        case 2:
                            performInBackgroundUtility(calculator.functionInterface.btnAdd);
                            break;
                        case 3:
                            performInBackgroundUtility(calculator.functionInterface.btnSubtract);
                            break;
                        case 4:
                            performInBackgroundUtility(calculator.functionInterface.btnClear);
                            break;
                        case 5:
                            performInBackgroundUtility(calculator.functionInterface.btnEval);
                            break;
                    }
                    functionID = (functionID+1)%6;
                }
                // if turn is 0, it highlights the IDs one by one in an iterative fashion for digits
                else if(turn == 0){
                    performInBackgroundUtility(calculator.numberInterface.digitKeys.get(digitID));
                    digitID = (digitID+1)%10;
                }
            }
            catch(Exception e){
                e.printStackTrace();
                break;
            }
        }
        return null;
    }
}
