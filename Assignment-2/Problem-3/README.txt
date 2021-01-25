STEPS TO RUN THE PROGRAM
    swipl -l problem3.pl
An interactive terminal interface would open up

HOW TO EXECUTE ->
    findAllPaths(). # Prints all the valid paths for a prisoner to escape
    findOptimalPaths()(). # Prints all the optimal paths with minimum distance
    isPathValid(Path). # Checks whether the Path is a valid path for a prisoner to escape or not

QUESTION 1 -> ALL PATHS
    Sample Example ->
        NOTE -> the output is large, so showing only last 4 lines
        ?- findAllPaths().
        G4 -> G6 -> G5 -> G8 -> G7 -> G12 -> G11 -> G13 -> G14 -> G17
    G4 -> G6 -> G5 -> G8 -> G7 -> G12 -> G11 -> G13 -> G14 -> G18 -> G17
    G4 -> G6 -> G5 -> G8 -> G7 -> G12 -> G11 -> G10 -> G15 -> G13 -> G14 -> G17
    G4 -> G6 -> G5 -> G8 -> G7 -> G12 -> G11 -> G10 -> G15 -> G13 -> G14 -> G18 -> G17
        false.

QUESTION 2 -> OPTIMAL PATHS
    Sample Example ->
        ?- findOptimalPaths().
        The following paths are optimal (shortest) :-
        Path: G3 -> G6 -> G12 -> G14 -> G17
        Minimum Distance: 19
        true.

QUESTION 3 -> IS PATH VALID
    Sample Example ->
        ?- isPathValid(['G4', 'G6', 'G5', 'G8', 'G7', 'G12', 'G11', 'G13', 'G14', 'G17']).
        true.

        ?- isPathValid(['G4', 'G7', 'G12', 'G11', 'G16', 'G14', 'G17']).
        No such path exists!
        false.

GENERAL INSTRUCTIONS FOR PROLOG ->
    Press '.' to stop execution of current command
    Press ';' to find another possible solution to current command
    Type halt. to exit the interface