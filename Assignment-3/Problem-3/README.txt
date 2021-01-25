INFORMATION -
    getOptimalDesign totalArea numberOfBedrooms numberOfHalls
    This prints dimensions of all components given area, number of bedrooms and number of halls.
    I have taken the entire search space. The code takes around 5-10 seconds in my computer to exexcute.
    Considered all possible dimensions (Not just a subset of dimensions). Removed redundant combinations wherever
    possible to reduce time complexity and increase speed. Rest count of each rooms are taken according to instructions.

STEPS TO RUN THE PROGRAM -
    ghci problem3.hs
    An interactive interface would open up

HOW TO EXECUTE -
    getOptimalDesign totalArea numberOfBedrooms numberOfHalls

SAMPLE EXAMPLE -
    *Main> getOptimalDesign 1000 3 2
    Bedroom: 3 (10,10)
    Hall: 2 (15,10)
    Kitchen: 1 (7,5)
    Bathroom: 4 (4,5)
    Garden: 1 (12,17)
    Balcony: 1 (9,9)
    Unused Space: 0
    *Main> getOptimalDesign 1000 5 2
    No design possible for the given constraints
    *Main> getOptimalDesign 100 3 2
    No design possible for the given constraints
    *Main> getOptimalDesign 4000 5 2
    Bedroom: 5 (15,15)
    Hall: 2 (20,15)
    Kitchen: 2 (15,13)
    Bathroom: 6 (8,9)
    Garden: 1 (20,20)
    Balcony: 1 (10,10)
    Unused Space: 953

INSTRUCTION FOR HASKELL -
    Press ':q' to quit from Haskell interface
