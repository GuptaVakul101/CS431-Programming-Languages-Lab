NOTE -> Djikstra Algorithm is used to find shortest path (for all the three types of weight) between specified nodes.
        Also, I have considered waiting time at bus stops while calulating shortest Time paths between nodes

STEPS TO RUN THE PROGRAM
    swipl -l problem2.pl
An interactive terminal interface would open up

# Computes the optimal path between A and B based on different optimization parameters (distance, cost and time)
HOW TO EXECUTE ->
    findOptimalTravelRoute('A', 'B').

SAMPLE INPUT ->
    bus(121, 'Chandigarh', 'Jaipur', 14.5, 15, 120, 10).
    bus(416, 'Chandigarh', 'Delhi', 16, 16.5, 80, 800).
    bus(375, 'Jaipur', 'Agra', 16, 16.5, 200, 12).
    bus(498, 'Agra', 'Delhi', 16, 16.5, 60, 9).
    bus(547, 'Agra', 'Lucknow', 16, 16.5, 30, 8).
    bus(748, 'Delhi', 'Panchkula', 16, 16.5, 90, 5).
    bus(985, 'Panchkula', 'Mohali', 16, 16.5, 30, 13).
SAMPLE EXAMPLE ->
    ?- findOptimalTravelRoute('Chandigarh', 'Delhi').
    Optimum Distance:
        PATH: [Chandigarh,416] -> [Delhi]
        Distance = 80, Time = 0.5, Cost = 800

    Optimum Time:
            PATH: [Chandigarh,416] -> [Delhi]
            Distance = 80, Time = 0.5, Cost = 800

    Optimum Cost:
            PATH: [Chandigarh,121] -> [Jaipur,375] -> [Agra,498] -> [Delhi]
            Distance = 380, Time = 26.0, Cost = 31

    true.
        
    ?- findOptimalTravelRoute('Agra', 'Chandigarh').
    No such path exists from source to destination!
    false.

GENERAL INSTRUCTIONS FOR PROLOG ->
    Press '.' to stop execution of current command
    Press ';' to find another possible solution to current command
    Type halt. to exit the interface
