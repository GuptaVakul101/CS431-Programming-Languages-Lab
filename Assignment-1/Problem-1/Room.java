package problem1;

import java.util.Scanner;
import java.util.Random;
import java.util.ArrayList;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.concurrent.Semaphore;

// The main room class where all the sock pickup and matching would occur
public class Room{
    // list of robotic arms (threads)
    private ArrayList<RoboArm> roboticArms;
    // match Making machine
    private MatchMakingMachine matchingMachine;
    // shelf manager robot
    private ShelfRobot shelfRobot;
    // number of robo arms
    private int numberOfRobots;
    // list of input socks
    private ArrayList<Integer> socks;
    private Random rand = new Random();
    // list of semaphores for synchronisation
    public ArrayList<Semaphore> semaphores;

    // initialising the variables inside the constructor
    private Room(int numberOfRobots, ArrayList<Integer> socks){
        this.socks = socks;
        this.numberOfRobots = numberOfRobots;
        shelfRobot = new ShelfRobot();
        matchingMachine = new MatchMakingMachine(shelfRobot);
        roboticArms = new ArrayList<>();
        for(int i = 0; i < this.numberOfRobots; i++){
            RoboArm roboticArm = new RoboArm(this, matchingMachine, i);
            roboticArms.add(roboticArm);
        }
        semaphores = new ArrayList<>();
        for(int i = 0; i < socks.size(); i++){
            semaphores.add(new Semaphore(1));
        }
    }

    // start all the robo arm (threds)
    void startExecution() throws InterruptedException {
        for(RoboArm roboticArm : roboticArms){
            roboticArm.start();
        }
        for(RoboArm roboticArm : roboticArms){
            roboticArm.join();
        }
        shelfRobot.printResult();
    }

    // pick up the sock (Be careful that a sock can be picked up by a single robotic arm(thread))
    int sockPickUp() throws InterruptedException {
        int id = -1;
        int sockID = Constants.NULL_SOCK_CODE;
        synchronized(socks){
            // is sock ID is NULL (means no sock)
            if(!socks.isEmpty()){
                id = rand.nextInt(socks.size());
            }
            // else for picking up a sock
            if(id != -1){
                // acquire the semaphore lock
                semaphores.get(id).acquire();

                // remove the sockID after it has been picked up
                sockID = socks.get(id);
                socks.remove(id);

                // release the semaphore lock
                semaphores.get(id).release();
            }
        }
        return sockID;
    }

    // take the input which contains the number of robo arms and the list of socks
    private static void takeInput(String filePath) throws FileNotFoundException, InterruptedException {
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);
        int numberOfRobots = scanner.nextInt();
        ArrayList<Integer> socks = new ArrayList<>();
        while(scanner.hasNextInt()){
            socks.add(scanner.nextInt());
        }
        Room room = new Room(numberOfRobots, socks);
        room.startExecution();
    }

    // main function
    public static void main(String []args) throws FileNotFoundException, InterruptedException {
        // input file path must be specified
        if(args.length < 1){
            System.out.println("Please provide the path of input file");
            return;
        }
        takeInput(args[0]);
    }
}
