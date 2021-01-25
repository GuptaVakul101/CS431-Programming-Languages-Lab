package problem3b;

import javax.swing.JButton;
import javax.swing.SwingWorker;

// class for backround task for iterating over functions
public class FunctionBackgroundTask extends SwingWorker {
    // an ID to get the corresponding button
    public int id;
    private Calculator calculator;

    FunctionBackgroundTask(Calculator calculator){
        this.calculator = calculator;
        id = 0;
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
        // highlights the IDs one by one in an iterative fashion
        while(true){
            try{
                switch(id){
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
                id = (id+1)%6;
            }
            catch(Exception e){
                e.printStackTrace();
                break;
            }
        }
        return null;
    }
}
