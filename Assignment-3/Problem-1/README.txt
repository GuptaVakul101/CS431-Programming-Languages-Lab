INFORMATION -
    isSetEmpty - Checks whether a set is empty
    findUnionSet - Returns union of two sets
    findIntersectionSet - Returns intersection of two sets
    findSubtractionSet - Returns differencce of two sets, i.e. A-B
    findAdditionSet - Returns addition of two sets
    Note -> All inputs are given as lists.

STEPS TO RUN THE PROGRAM -
    ghci problem1.hs
    An interactive interface would open up

HOW TO EXECUTE -
    isSetEmpty list
    findUnionSet inputList1 inputList2
    findIntersectionSet inputList1 inputList2
    findSubtractionSet inputList1 inputList2
    findAdditionSet inputList1 inputList2

SAMPLE EXAMPLE -
    *Main> isSetEmpty [1,2]
    False
    *Main> isSetEmpty []
    True
    *Main>
    *Main> findUnionSet [1,2,3] [3,4,5]
    [1,2,3,4,5]
    *Main> findIntersectionSet [1,2,3] [3,4,5]
    [3]
    *Main> findSubtractionSet [1,2,3] [3,4,5]
    [1,2]
    *Main> findAdditionSet [1,2,3] [3,4,5]
    [4,5,6,7,8]
    *Main> 


INSTRUCTION FOR HASKELL -
    Press ':q' to quit from Haskell interface
