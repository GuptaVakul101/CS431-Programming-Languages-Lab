STEPS TO RUN THE PROGRAM
    swipl -l problem1.pl
An interactive terminal interface would open up

HOW TO EXECUTE ->
    checkUncle(A,B).
    checkHalfSister(A,B).

QUESTION 1 -> UNCLE
    LOGIC -> A is uncle of B if parent of A and grandparent of B is common, and also A is not parent of B and A is a male
    Sample Example for Uncle ->
        ?- checkUncle(A,B).
        A = kattappa,
        B = avantika ;
        false.

        ?- checkUncle(jatin, avantika).
        false.

        ?- checkUncle(A, avantika).
        A = kattappa ;
        false.

QUESTION 2 -> HALF-SISTER
    LOGIC -> A is half-sister of B if both have exactly one parent common(and other is not common) and A is a female
    Sample Example for Half-sister ->
        ?- checkHalfSister(A,B).
        A = avantika,
        B = shivkami ;
        A = shivkami,
        B = avantika ;
        false.

        ?- checkHalfSister(avantika, A).
        A = shivkami ;
        false.

GENERAL INSTRUCTIONS FOR PROLOG ->
    Press '.' to stop execution of current command
    Press ';' to find another possible solution to current command
    Type halt. to exit the interface