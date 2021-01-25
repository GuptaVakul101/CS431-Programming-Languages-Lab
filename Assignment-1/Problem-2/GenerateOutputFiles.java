package problem2;

import java.io.*;
import java.util.*;

// class for generating the output files inside the output folder
class GenerateOutputFiles{
    DistributedSystem distributedSystem;

    GenerateOutputFiles(DistributedSystem distributedSystem){
        this.distributedSystem = distributedSystem;
    }

    public void generate(){
        // generate general output (as soon as a particular record is evaluates, it gets written into the output file)
        generateGeneralOutput(); // NO SORTING
        // output sorted on the basis of Roll Number
        generateSortedRollOutput();
        // output sorted on the basis of Name
        generateSortedNameOutput();
    }

    // function for generating general output
    public void generateGeneralOutput(){
        BufferedWriter result = null ;
        try{
            result = new BufferedWriter(new FileWriter(Constants.RESULT_FILE_GENERAL)) ;
        }
        catch (Exception e){
            e.printStackTrace() ;
        }
        assert(result != null) ;
        for (Map.Entry<String, ArrayList<String>> entry : distributedSystem.record.entrySet()){
            try{
                result.append(entry.getKey());
                for (String value : entry.getValue()){
                    result.append(',');
                    result.append(value);
                }
                result.append('\n');
            } catch (IOException e){
                e.printStackTrace();
            }
        }
        try{
            result.flush() ;
            result.close() ;
        }
        catch (IOException e){
            e.printStackTrace() ;
        }
    }

    // function for generating output sorted on Roll Number
    public void generateSortedRollOutput(){
        BufferedWriter result = null ;
        try{
            result = new BufferedWriter(new FileWriter(Constants.RESULT_FILE_SORTED_ROLL)) ;
        }
        catch (IOException e){
            e.printStackTrace() ;
        }
        assert(result != null);
        ArrayList<String> sortedRoll = new ArrayList<>(distributedSystem.record.keySet()) ;
        Collections.sort(sortedRoll) ;
        try{
            for(String roll: sortedRoll){
                result.append(roll) ;
                for (String value : distributedSystem.record.get(roll)){
                    result.append(',');
                    result.append(value);
                }
                result.append('\n');
            }
            // write sorted files now
            result.flush();
            result.close();
        }
        catch (Exception e){
            e.printStackTrace() ;
        }
    }

    // function for generating output sorted on Name
    public void generateSortedNameOutput(){
        BufferedWriter result = null ;
        try{
            result = new BufferedWriter(new FileWriter(Constants.RESULT_FILE_SORTED_NAME)) ;
        }
        catch (IOException e){
            e.printStackTrace() ;
        }
        assert(result != null);
        final Comparator<ArrayList<String>> comparatorName = new Comparator<ArrayList<String>>(){
            public int compare(ArrayList<String> a1, ArrayList<String> a2){
                String name1 = a1.get(1);
                String name2 = a2.get(1);
                return name1.compareTo(name2);
            }
        };

        ArrayList<ArrayList<String>> sortedName = new ArrayList<>() ;
        for(Map.Entry<String, ArrayList<String>> entry : distributedSystem.record.entrySet()){
            ArrayList<String> newEntry = new ArrayList<>();
            newEntry.add(entry.getKey());
            for(String value : entry.getValue()){
                newEntry.add(value);
            }

            sortedName.add(newEntry);
        }
        Collections.sort(sortedName, comparatorName);
        try{
            for(ArrayList<String> entry: sortedName){
                result.append(entry.get(0)) ;
                for(int i = 1; i < 5; i++){
                    result.append(',') ;
                    result.append(entry.get(i)) ;
                }
                result.append('\n');
            }
            // write sorted files now
            result.flush() ;
            result.close() ;
        }
        catch (Exception e){
            e.printStackTrace() ;
        }
    }
}
