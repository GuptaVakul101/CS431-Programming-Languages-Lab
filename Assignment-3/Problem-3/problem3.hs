-- Utility function for obtaining the maximum area than can be covered from a list of all room dimensions  
-- BASE CASE (Returns 0 on an empty list)
getMaximumArea [] _ _ _ _ _ _= 0
-- RECURSIVE FUNCTION (calculates the current area covered and call recursively on the remaining list)
getMaximumArea ((a,b,c,d,e,f):xs) p q r s t u = maximum [((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)+(fst(f)*snd(f)*u)):: Integer, getMaximumArea(xs) p q r s t u]

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- function for obtaining the optimal design (MAIN FUNCTION)
-- takes 3 arguments -> total area, number of bedrooms and number of halls
getOptimalDesign totalArea numberOfBedrooms numberOfHalls = do
    -- find all possible dimensions possible recursively for bedroom
    let allBedroomDim = findAllPossibleDimensions (10,10) (15,15)
    -- find all possible dimensions possible recursively for hall
    let allHallDim = findAllPossibleDimensions (15,10) (20,15)
    -- find all possible dimensions possible recursively for kitchen
    let allKitchenDim = findAllPossibleDimensions (7,5) (15,13)
    -- find all possible dimensions possible recursively for bathroom
    let allBathroomDim = findAllPossibleDimensions (4,5) (8,9)
    -- find all possible dimensions possible recursively for garden
    let allGardenDim = findAllPossibleDimensions (10,10) (20,20)
    -- find all possible dimensions possible recursively for balcony
    let allBalconyDim = findAllPossibleDimensions (5,5) (10,10)

    -- number of kitchen = ceil(number of bedrooms/3)
    let numberOfKitchens = ceiling(fromIntegral numberOfBedrooms/3) :: Integer
    -- defining count of other type of rooms
    let numberOfBathrooms = numberOfBedrooms + 1
    let numberOfGardens = 1
    let numberOfBalconies = 1

    -- all (bedroom, hall) combinations with sum of their areas <= total area
    let uniqueTwoTupleComb = filter (\(a,b) -> ((fst(a)*snd(a)*numberOfBedrooms) + (fst(b)*snd(b))*numberOfHalls) <= totalArea) (twoTupleCombination allBedroomDim allHallDim) 
    
    -- all (bedroom, hall, kitchen) combinations satisfying the following constraints
    -- 1. sum of their areas <= total area
    -- 2. length of kitchen must be less than or equal to length of both bedroom and hall
    -- 3. breadth of kitchen must be less than or equal to breadth of both bedroom and hall
    let uniqueThreeTupleComb =  filter (\(a,b,c) -> (((fst(a)*snd(a)*numberOfBedrooms) + (fst(b)*snd(b)*numberOfHalls) + (fst(c)*snd(c)*numberOfKitchens)) <= totalArea) 
                                && (fst(c) <= fst(a) && fst(c) <= fst(b)     
                                && snd(c) <= snd(a) && snd(c) <= snd(b)))
                                (threeTupleCombination uniqueTwoTupleComb allKitchenDim)
                                   
    -- all (bedroom, hall, kitchen, bathroom) unique combinations satisfying the following constraints
    -- 1. sum of their areas <= total area
    -- 2. length of bathroom must be less than or equal to length of kitchen
    -- 3. breadth of bathroom must be less than or equal to breadth of kitchen
    let uniqueFourTupleComb = filterUniqueCombFour (filter (\(a,b,c,d) -> (((fst(a)*snd(a)*numberOfBedrooms) + (fst(b)*snd(b)*numberOfHalls) + (fst(c)*snd(c)*numberOfKitchens) + (fst(d)*snd(d)*numberOfBathrooms)) <= totalArea)
                                && (fst(d) <= fst(c) && snd(d) <= snd(c)))
                                (fourTupleCombination uniqueThreeTupleComb allBathroomDim))
                                numberOfBedrooms numberOfHalls numberOfKitchens numberOfBathrooms

    -- all (bedroom, hall, kitchen, bathroom, garden) unique combinations satisfying the following constraints
    -- 1. sum of their areas <= total area
    let uniqueFiveTupleComb = filterUniqueCombFive (filter (\(a,b,c,d,e) -> (((fst(a)*snd(a)*numberOfBedrooms) + (fst(b)*snd(b)*numberOfHalls) + (fst(c)*snd(c)*numberOfKitchens) + (fst(d)*snd(d)*numberOfBathrooms) + (fst(e)*snd(e)*numberOfGardens)) <= totalArea))  
                                (fiveTupleCombination uniqueFourTupleComb allGardenDim))
                                numberOfBedrooms numberOfHalls numberOfKitchens numberOfBathrooms numberOfGardens

    -- all (bedroom, hall, kitchen, bathroom, garden, balcony) unique combinations satisfying the following constraints
    -- 1. sum of their areas <= total area
    let uniqueSixTupleComb = filterUniqueCombSix (filter (\(a,b,c,d,e,f) -> (((fst(a)*snd(a)*numberOfBedrooms) + (fst(b)*snd(b)*numberOfHalls) + (fst(c)*snd(c)*numberOfKitchens) + (fst(d)*snd(d)*numberOfBathrooms) + (fst(e)*snd(e)*numberOfGardens) + (fst(f)*snd(f)*numberOfBalconies)) <= totalArea))  
                                (sixTupleCombination uniqueFiveTupleComb allBalconyDim)) numberOfBedrooms numberOfHalls numberOfKitchens numberOfBathrooms numberOfGardens numberOfBalconies   -- remove duplicate areas
    

    -- calculate maximum area than can be possible
    let maximumArea = getMaximumArea uniqueSixTupleComb numberOfBedrooms numberOfHalls numberOfKitchens numberOfBathrooms numberOfGardens numberOfBalconies
    -- get the optimal dimensions corresponding to the maximum area
    let optimalDimensions = filter (\(a,b,c,d,e,f) -> ((fst(a)*snd(a)*numberOfBedrooms) + (fst(b)*snd(b)*numberOfHalls) + (fst(c)*snd(c)*numberOfKitchens) + (fst(d)*snd(d)*numberOfBathrooms) + (fst(e)*snd(e)*numberOfGardens) + (fst(f)*snd(f)*numberOfBalconies) == maximumArea)) uniqueSixTupleComb

    -- print optimal dimensions and count of all rooms
    if (length optimalDimensions == 0)
    then putStrLn $ "No design possible for the given constraints"
    else do 
        let (a,b,c,d,e,f) = optimalDimensions !! 0
        putStrLn $ "Bedroom: " ++ show (numberOfBedrooms) ++ " " ++ show a
        putStrLn $ "Hall: " ++ show (numberOfHalls) ++ " " ++ show b
        putStrLn $ "Kitchen: " ++ show (numberOfKitchens) ++ " " ++ show c
        putStrLn $ "Bathroom: " ++ show (numberOfBathrooms) ++ " " ++ show d
        putStrLn $ "Garden: " ++ show (numberOfGardens) ++ " " ++ show e
        putStrLn $ "Balcony: " ++ show (numberOfBalconies) ++ " " ++ show f
        putStrLn $ "Unused Space: " ++ show (totalArea-maximumArea)

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNCTIONS FOR FINDING ALL POSSIBLE DIMENSIONS (THE ENTIRE SEARCH SPACE)
-- utility function for finding all possible dimensions ranging from lower tuple to higher tuple
findAllPossibleDimensionsUtility lowerTupleDim higherTupleDim = 
 if (snd lowerTupleDim == snd higherTupleDim)
  then [lowerTupleDim] -- BASE CASE (return the only tuple)
   else lowerTupleDim:findAllPossibleDimensionsUtility lowerTupleNewDim higherTupleDim
    where lowerTupleNewDim = (fst lowerTupleDim, snd lowerTupleDim + 1) -- increase the snd by 1 and call recursively
    
-- find all possible dimensions ranging from lower tuple to higher tuple 
findAllPossibleDimensions lowerTupleDim higherTupleDim = 
 if (fst lowerTupleDim == fst higherTupleDim) 
  then findAllPossibleDimensionsUtility lowerTupleDim higherTupleDim -- call the helper function if fst's are same
   else findAllPossibleDimensionsUtility lowerTupleDim higherTupleDim ++ findAllPossibleDimensions lowerTupleNewDim higherTupleDim
    where lowerTupleNewDim = (fst lowerTupleDim + 1, snd lowerTupleDim) --else increment the fst by 1 and call recussively

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- FINDING CARTESIAN PRODUCTS
-- cartesian product of (bedroom, hall) [Two Tuple]
twoTupleCombination currComb newTuple = [(x,y) | x <- currComb, y <- newTuple]
-- cartesian product of (bedroom, hall, kitchen) [Three Tuple]
threeTupleCombination currComb newTuple = [(a, b, y) | (a,b) <- currComb, y <- newTuple]
-- cartesian product of (bedroom, hall, kitchen, bathroom) [Four Tuple]
fourTupleCombination currComb newTuple = [(a, b, c, y) | (a,b,c) <- currComb, y <- newTuple]
-- cartesian product of (bedroom, hall, kitchen, bathroom, garden) [Five Tuple]
fiveTupleCombination currComb newTuple = [(a, b, c, d, y) | (a,b,c,d) <- currComb, y <- newTuple]
-- cartesian product of (bedroom, hall, kitchen, bathroom, garden, balcony) [Six Tuple]
sixTupleCombination currComb newTuple = [(a, b, c, d, e, y) | (a,b,c,d,e) <- currComb, y <- newTuple]

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNCTIONS FOR REMOVING REDUNDANT COMBINATIONS
-- remove duplicate area dimensions from the list of 4-tuples
filterUniqueCombFour list p q r s = filterUniqueCombFourUtility list [] p q r s
-- BASE CASE
filterUniqueCombFourUtility [] _ _ _ _ _= []
-- RECURSIVE FUNCTION
filterUniqueCombFourUtility ((a,b,c,d):xs) list2 p q r s
    | (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s))  `elem` list2) = filterUniqueCombFourUtility xs list2 p q r s
    | otherwise = (a,b,c,d) : filterUniqueCombFourUtility xs (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)):list2) p q r s

-- remove duplicate area dimensions from the list of 5-tuples
filterUniqueCombFive list p q r s t = filterUniqueCombFiveUtility list [] p q r s t
-- BASE CASE
filterUniqueCombFiveUtility [] _ _ _ _ _ _= []
-- RECURSIVE FUNCTION
filterUniqueCombFiveUtility ((a,b,c,d,e):xs) list2 p q r s t
    | (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t))  `elem` list2) = filterUniqueCombFiveUtility xs list2 p q r s t
    | otherwise = (a,b,c,d,e) : filterUniqueCombFiveUtility xs (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)):list2) p q r s t
    
-- remove duplicate area dimensions from the list of 6-tuples
filterUniqueCombSix list p q r s t u = filterUniqueCombSixUtility list [] p q r s t u
-- BASE CASE
filterUniqueCombSixUtility [] _ _ _ _ _ _ _= []
-- RECURSIVE FUNCTION
filterUniqueCombSixUtility ((a,b,c,d,e,f):xs) list2 p q r s t u
    | (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)+(fst(f)*snd(f)*u))  `elem` list2) = filterUniqueCombSixUtility xs list2 p q r s t u
    | otherwise = (a,b,c,d,e,f) : filterUniqueCombSixUtility xs (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)+(fst(f)*snd(f)*u)):list2) p q r s t u

-----------------------------------------------------------------------------------------------------------------------------------------------------------