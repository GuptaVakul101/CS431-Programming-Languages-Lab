package problem2;

import java.io.*;
import java.util.*;

// the Instructor class extends thread for evaluating according to its instructorDesignation
class Instructor extends Thread
{
    // input for its specific designation
    private ArrayList<ArrayList<String>> inputBuffer;
    // designation like TA1, TA2 and CC
    String instructorDesignation;
    DistributedSystem distributedSystem;

    // initialises the thread priority and data variables inside the constructor
    public Instructor(String designation, DistributedSystem es, int priority)
    {
        this.setName(designation);
        this.setPriority(priority);
        inputBuffer = new ArrayList<>();
        instructorDesignation = designation;
        distributedSystem = es;
    }

    // add new entry into the input buffer
    void addInput(String rollNumber, String updatedMarks)
    {
        ArrayList<String> input = new ArrayList<>() ;
        input.add(rollNumber) ;
        input.add(updatedMarks) ;
        inputBuffer.add(input) ;
    }

    // runs in the background
    @Override
    public void run()
    {
        // updates the record while the input buffer is not empty
        while(!inputBuffer.isEmpty())
        {
            ArrayList<String> input = inputBuffer.get(0) ;
            assert(input.size() == 2) ;
            try
            {
                distributedSystem.updateRecord(input.get(0), Integer.parseInt(input.get(1)), instructorDesignation);
                // remove the request from input after executing it
                inputBuffer.remove(0) ;
            }
            catch(Exception e)
            {
                e.printStackTrace() ;
            }
        }
    }
}
