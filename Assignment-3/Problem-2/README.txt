INFORMATION -
    We are creating fixtures for first three days only i.e 1st Dec to 3rd Dec only.
    There are total of 12 fixed teams.
    A random fixture would be created each time fixture "all" is called.
    If before fixture "all", nextMatch or fixture "teamName" is called, then the program is able to report an error.
    Corner cases for invalid day, time are handled.

IMPORTANT -> Use this command:
    cabal install random --lib
    so that System.Random library is able to work.

STEPS TO RUN THE PROGRAM -
    ghci problem2.hs
    An interactive interface would open up

HOW TO EXECUTE -
    fixture "all"
    fixture "teamName"
    nextMatch day time

SAMPLE EXAMPLE -
    *Main> fixture "all"
    CH vs BS     1-12-2020     9:30AM
    CS vs HU     1-12-2020     7:30PM
    CM vs MA     2-12-2020     9:30AM
    CV vs ME     2-12-2020     7:30PM
    EE vs PH     3-12-2020     9:30AM
    DS vs ST     3-12-2020     7:30PM

    *Main> fixture "ST"
    DS vs ST     3-12-2020     7:30PM

    *Main> fixture "AB"
    Team does not exist!

    *Main> nextMatch 1 6.50
    CH vs BS     1-12-2020     9:30AM

    *Main> nextMatch 2 16.50
    CV vs ME     2-12-2020     7:30PM

    *Main> nextMatch 6 16.50
    No match ahead!

    *Main> nextMatch 34 16.50
    Invalid day!

    *Main> nextMatch 2 26.50
    Invalid time!

INSTRUCTION FOR HASKELL -
    Press ':q' to quit from Haskell interface
