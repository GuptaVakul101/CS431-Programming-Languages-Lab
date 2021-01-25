package problem2;

import java.io.*;
import java.util.*;
import java.util.concurrent.locks.ReentrantLock;

// the main class which implements the entire distributed evaluation system
class DistributedSystem
{
    // for storing the change of marks as input
    private ArrayList<ArrayList<String>> inputBuffer;
    // reference to the class for generating the output files
    private GenerateOutputFiles generateOutputFiles;

    // A map for storing record whose key is roll number (unique)
    //Roll no. -> [name, email, marks, last_updated_by]
    public Map<String, ArrayList<String>> record;
    // a reentrantLock for every roll number
    private Map<String, ReentrantLock> locks;

    // For reading input
    private final static Scanner scanner = new Scanner(System.in);

    // initialises the variables inside the constructor
    public DistributedSystem()
    {
        inputBuffer = new ArrayList<>();
        record = new HashMap<>();
        locks = new HashMap<>();
        generateOutputFiles = new GenerateOutputFiles(this);
    }

    // updates the corresponding marks (It checks if the marks are already updated by CC, then it reports that marks can't be
    // further updated by TA1 or TA2)
    private boolean updateRecordUtility(ArrayList<String> arrayList, int marksChange, String updater)
    {
        // edge case when roll number not present in the student input database
        if(arrayList == null)
        {
            System.out.println("Data for this roll doesn't exist");
            return false ;
        }

        // TA1,TA2 can't update marks once CC has updated it
        String lastUpdater = arrayList.get(3) ;
        if(lastUpdater.equals("CC") && !updater.equals("CC"))
        {
            System.out.println(updater + " trying to update marks of a student which has been modified by CC.");
            return false ;
        }

        // changes the marks and the previous updater
        int prevMarks = Integer.parseInt(arrayList.get(2)) ;
        prevMarks += marksChange ;
        arrayList.set(2, Integer.toString(prevMarks)) ;
        arrayList.set(3, updater) ;

        return true ;
    }

    // update the record on demand
    public void updateRecord(String rollNumber, int marksChange, String updater) throws Exception
    {
        // checks if the roll number has a lock associated with it
        if(!locks.containsKey(rollNumber))
            throw new Exception("This Roll Number doesn't have a lock associated with it.") ;

        // get the reentrantLock for that particular roll number
        ReentrantLock reentrantLock = locks.get(rollNumber) ;
        reentrantLock.lock() ;
        // try to update the marks
        try
        {
            if(updateRecordUtility(record.get(rollNumber), marksChange, updater))
            {
                System.out.println(updater + " updated the marks of " + rollNumber + " to " + record.get(rollNumber).get(2));
            }
        }
        // release the lock after marks have been updated successfully
        finally
        {
            reentrantLock.unlock() ;
        }
    }

    // read the input student database from file
    public void readDataFromFile() throws IOException
    {
        BufferedReader buffRead = new BufferedReader(new FileReader(Constants.INPUT_FILE_PATH));
        String line;
        while ((line = buffRead.readLine()) != null)
        {
            // use comma as separator
            String[] data = line.split(",");
            ArrayList<String> temp = new ArrayList<>();
            temp.add(data[1]);
            temp.add(data[2]);
            temp.add(data[3]);
            temp.add(data[4]);
            this.record.put(data[0], temp);
            // put a lock for each record (roll number)
            this.locks.put(data[0], new ReentrantLock()) ;
        }
        buffRead.close();
    }

    // take input from command line for increment or decrement of marks
    private String takeInputMarksChange()
    {
        System.out.println("How many marks do you want to increase/decrease (Input -ve if you want to decrease)?");
        String s = Integer.toString(scanner.nextInt()) ;
        return s ;
    }

    // take input from command line for roll number
    private String takeInputRollNumber()
    {
        System.out.println("Enter Roll Number :- ") ;
        String s = scanner.next() ;

        if(record.containsKey(s))
            return s ;

        System.out.println("Invalid Roll Number, Not in the input database, Please try again");
        return takeInputRollNumber() ;
    }

    // take input from command line for instructor designation
    private String takeInputTeacher()
    {
        System.out.println("Enter Instructor's Designation (TA1, TA2 or CC) :- ");
        String s = scanner.next() ;

        if(s.equals("CC") || s.equals("TA1") || s.equals("TA2"))
            return s ;

        System.out.println("Invalid Instructor's name, Please try again");
        return takeInputTeacher() ;
    }

    // take input in case of request for updation of marks
    private void takeInput()
    {
        String teacher = takeInputTeacher() ;
        String rollNum = takeInputRollNumber() ;
        String updateMarks = takeInputMarksChange() ;
        ArrayList<String> input = new ArrayList<>() ;
        input.add(teacher) ;
        input.add(rollNum) ;
        input.add(updateMarks) ;
        inputBuffer.add(input) ;
    }

    // run the background threads for TA1,TA2 and CC for updating the marks
    private void StartExecution()
    {
        // giving the instructor thread the highest priority
        Instructor instructor = new Instructor("CC", this, Thread.MAX_PRIORITY);
        // giving the TA threads low priority
        Instructor ta1 = new Instructor("TA1", this, Thread.MIN_PRIORITY);
        Instructor ta2 = new Instructor("TA2", this, Thread.MIN_PRIORITY);

        // assign requests corresponding to instructors designation
        for(ArrayList<String> entry: inputBuffer)
        {
            String teacher = entry.get(0) ;
            String rollNumber = entry.get(1) ;
            String marksChange = entry.get(2) ;
            switch(teacher)
            {
                case Constants.CC:
                    instructor.addInput(rollNumber, marksChange) ;
                    break ;
                case Constants.TA1:
                    ta1.addInput(rollNumber, marksChange);
                    break ;
                case Constants.TA2:
                    ta2.addInput(rollNumber, marksChange);
                    break ;
                default:
                    break ;
            }
        }
        // clear the input buffer
        inputBuffer.clear() ;

        // start all the threads simultaneously in background
        ta1.start();
        ta2.start() ;
        instructor.start() ;
        try
        {
            instructor.join();
            ta1.join() ;
            ta2.join() ;
        }
        catch(Exception e)
        {
            e.printStackTrace() ;
        }

        // generate the output files after completion of evaluation
        generateOutputFiles.generate() ;
    }

    // main function
    public static void main(String[] args) throws IOException
    {
        DistributedSystem disSystem = new DistributedSystem();
        // read the input student database
        disSystem.readDataFromFile();
        while(true)
        {
            int select;
            // gives 3 options, take the input request for updation of marks, evaluate all the requests or exit
            System.out.println("Choose Option: \n" + "1. Update Marks \n" + "2. Start Execution \n" + "3. Exit");
            select = scanner.nextInt();
            switch (select)
            {
                // take input request for updation of marks
                case 1:
                    disSystem.takeInput();
                    break;
                // starts the evaluation of all the requests
                case 2:
                    disSystem.StartExecution();
                    break;
                // exit
                default:
                    return;
            }
        }
    }
}
