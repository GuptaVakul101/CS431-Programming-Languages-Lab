package problem1;

// match making machine class which combines pair of same color socks as soon as it gets them
public class MatchMakingMachine {
    // boolean variables for presence of socks of a particular color
    private Boolean isSockBlue;
    private Boolean isSockGrey;
    private Boolean isSockWhite;
    private Boolean isSockBlack;
    // a variable of shelf managing robot
    private ShelfRobot shelfRobot;

    // initialising inside the constructor
    MatchMakingMachine(ShelfRobot shelfRobot){
        this.isSockBlue = false;
        this.isSockGrey = false;
        this.isSockWhite = false;
        this.isSockBlack = false;
        this.shelfRobot = shelfRobot;
    }

    // pair sock based on whether it is already present or not
    void pairSocks(int sockID){
        switch(sockID) {
            case Constants.BLUE_SOCK_CODE:
                synchronized(isSockBlue){
                    // if not already present
                    if(isSockBlue==false){
                        isSockBlue = true;
                    }
                    else{
                        // if present, increment the pair count
                        shelfRobot.incrementSockPairCount(Constants.BLUE_SOCK_CODE);
                        isSockBlue = false;
                        System.out.println("A BLUE PAIR SOCK FORMED");
                    }
                }
                break;

            case Constants.GREY_SOCK_CODE:
                synchronized(isSockGrey){
                    // if not already present
                    if(isSockGrey==false){
                        isSockGrey = true;
                    }
                    else{
                        // if present, increment the pair count
                        shelfRobot.incrementSockPairCount(Constants.GREY_SOCK_CODE);
                        isSockGrey = false;
                        System.out.println("A GREY PAIR SOCK FORMED");
                    }
                }
                break;

            case Constants.WHITE_SOCK_CODE:
                synchronized(isSockWhite){
                    // if not already present
                    if(isSockWhite==false){
                        isSockWhite = true;
                    }
                    else{
                        // if present, increment the pair count
                        shelfRobot.incrementSockPairCount(Constants.WHITE_SOCK_CODE);
                        isSockWhite = false;
                        System.out.println("A WHITE PAIR SOCK FORMED");
                    }
                }
                break;

            case Constants.BLACK_SOCK_CODE:
                synchronized(isSockBlack){
                    // if not already present
                    if(isSockBlack==false){
                        isSockBlack = true;
                    }
                    else{
                        // if present, increment the pair count
                        shelfRobot.incrementSockPairCount(Constants.BLACK_SOCK_CODE);
                        isSockBlack = false;
                        System.out.println("A BLACK PAIR SOCK FORMED");
                    }
                }
                break;
        }
    }
}
