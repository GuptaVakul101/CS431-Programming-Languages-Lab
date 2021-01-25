package problem1;

// shelf robot class for incrementing the sock pair count
public class ShelfRobot {
    // counts for storing matched pairs of each color
    private Integer BlueSockPairsCount;
    private Integer GreySockPairsCount;
    private Integer WhiteSockPairsCount;
    private Integer BlackSockPairsCount;

    // initialise inside the constructor
    ShelfRobot(){
        BlueSockPairsCount = 0;
        GreySockPairsCount = 0;
        WhiteSockPairsCount = 0;
        BlackSockPairsCount = 0;
    }

    // increment the count based on sockID
    void incrementSockPairCount(int sockID){
        switch(sockID) {
            // increment the blue count
            case Constants.BLUE_SOCK_CODE:
                synchronized(BlueSockPairsCount){
                    BlueSockPairsCount++;
                }
                break;

            // increment the grey count
            case Constants.GREY_SOCK_CODE:
                synchronized(GreySockPairsCount){
                    GreySockPairsCount++;
                }
                break;

            // increment the white count
            case Constants.WHITE_SOCK_CODE:
                synchronized(WhiteSockPairsCount){
                    WhiteSockPairsCount++;
                }
                break;

            // increment the black count
            case Constants.BLACK_SOCK_CODE:
                synchronized(BlackSockPairsCount){
                    BlackSockPairsCount++;
                }
                break;
        }
    }

    // print the final number of matched pair of socks of each color
    void printResult(){
        System.out.println("FINAL RESULT");
        System.out.println("Number of BLUE sock pairs: " + BlueSockPairsCount);
        System.out.println("Number of GREY sock pairs: " + GreySockPairsCount);
        System.out.println("Number of WHITE sock pairs: " + WhiteSockPairsCount);
        System.out.println("Number of BLACK sock pairs: " + BlackSockPairsCount);
    }
}
