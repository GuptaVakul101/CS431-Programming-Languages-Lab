-- import the list library
import Data.List

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- utility function for removing all the duplicates in a set
-- BASE CASE -> if set is empty, then return empty set
deleteDuplicateElements [] = []
-- RECURSIVE function
deleteDuplicateElements (currElement:remInputList) = if elem currElement remInputList then
        -- if the current element is present in the remaining list, then don't include the current element and call recursively
        deleteDuplicateElements remInputList
    else
        -- else include the current element and and call recursively
        currElement : deleteDuplicateElements remInputList

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- checks whether the set (list in this case) is empty or not
-- returns true if set is empty
isSetEmpty list = null list

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- finds union of two sets by first combining all the elements and then removing the duplicate ones
findUnionSet inputList1 inputList2 = deleteDuplicateElements (inputList1 ++ inputList2)

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- finds intersection of two sets
-- BASE CASE
findIntersectionSet [] _ = []
-- RECURSIVE function
findIntersectionSet (currElement:inputList1) inputList2 = if elem currElement inputList2 then
        -- if the current element is present in second list, then include the current element and call recursively
        findUnionSet [currElement] (findIntersectionSet inputList1 inputList2)
    else
        -- else don't include the current element and and call recursively
        findIntersectionSet inputList1 inputList2

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- finds subtraction of two sets
-- BASE CASE
findSubtractionSet [] _ = []
-- RECURSIVE function
findSubtractionSet (currElement:inputList1) inputList2 = if elem currElement inputList2 then
        -- if the current element is present in second list, then don't include the current element and call recursively
        findSubtractionSet inputList1 inputList2
    else
        -- else include the current element and and call recursively
        findUnionSet [currElement] (findSubtractionSet inputList1 inputList2)

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- finds addition of two sets
-- BASE CASE
findAdditionSet [] _ = []
findAdditionSet _ [] = []
-- RECURSIVE function
findAdditionSet (currElement1:inputList1) (currElement2:inputList2) = 
    -- union of sum of current elements and two recursive calls (since we are using union, hence no duplicate elements would be present)
    findUnionSet [currElement1+currElement2] (findUnionSet (findAdditionSet (currElement1:inputList1) inputList2) (findAdditionSet inputList1 (currElement2:inputList2))) 