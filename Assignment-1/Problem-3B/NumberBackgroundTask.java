package problem3b;

import javax.swing.SwingWorker;
import javax.swing.JButton;

// class for backround task for iterating over digits
public class NumberBackgroundTask extends SwingWorker {
    // an ID to get the corresponding button
    public int id;
    private Calculator calculator;

    NumberBackgroundTask(Calculator calculator){
        id = 0;
        this.calculator = calculator;
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
                performInBackgroundUtility(calculator.numberInterface.digitKeys.get(id));
                id = (id+1)%10;
            }
            catch(Exception e){
                e.printStackTrace();
                break;
            }
        }
        return null;
    }
}
