package problem1;

// class for robotic arm (thread) used for pciking up a sock
public class RoboArm extends Thread {
    // it has an ID and refernce to room and match making machine
    private int id;
    private Room room;
    private MatchMakingMachine matchingMachine;

    // initialising variables inside the constructor
    RoboArm(Room room, MatchMakingMachine matchingMachine, int id){
        this.room = room;
        this.matchingMachine = matchingMachine;
        this.id = id;
    }

    // Here it would run asynchronously in the background
    public void run(){
        while(true){
            // tries to pick up a sock
            int sockID = Constants.NULL_SOCK_CODE;
            try{
                sockID = room.sockPickUp();
            }
            catch(InterruptedException e){
                System.out.println(e);
            }

            // is no sock is left, the thread stops
            if(sockID == Constants.NULL_SOCK_CODE){
                System.out.println("Robotic Arm (Thread) " + this.id + " stopped.");
                break;
            }

            // otherwise a particular sock is picked up by this thread
            System.out.println("Color " + sockID + " sock picked by robotic arm (thread) " + this.id);
            // call the pairSocks function to increment the pair count
            matchingMachine.pairSocks(sockID);
        }
    }
}
