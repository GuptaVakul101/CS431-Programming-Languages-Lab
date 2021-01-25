-- Import libraries
import System.IO.Unsafe
import Data.IORef
import System.Random
import Data.List
import Data.Maybe
import System.Directory

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Gets the fixtures from the given list of permutedTeams
getFixtures permutedTeams = 
    -- Create fixtures by combining first half of teams and second half of teams
    zip firstHalfTeams secondHalfTeams
    where 
        -- First half of permuted list
        firstHalfTeams = take maximumNumberOfMatches permutedTeams
        -- Second half of permuted list
        secondHalfTeams = drop maximumNumberOfMatches permutedTeams

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Prints next match details given date and time
-- ALso if the fixtures have not been initialized, print "Fixtures not initialzed" 
-- If the date or time is invalid, print that warning also
-- Also if there is no match ahead, print "No Match ahead"
nextMatch day time = do
    permutedTeams <- readg
    let currentFixtures = getFixtures permutedTeams
    -- Invalid day
    if null permutedTeams then
        putStrLn "Fixtures not initalized"
    else if day < 1 || day > 31 then
        putStrLn "Invalid day!"
    -- Invalid time
    else if time < 0 || time > 23.99 then
        putStrLn "Invalid time!"
    -- Print details of next match depending on day and time
    else
        case day of
            1 -> if time <= 9.5 then printFixtureInfo 0 currentFixtures else if time <= 19.5 then printFixtureInfo 1 currentFixtures else printFixtureInfo 2 currentFixtures
            2 -> if time <= 9.5 then printFixtureInfo 2 currentFixtures else if time <= 19.5 then printFixtureInfo 3 currentFixtures else printFixtureInfo 4 currentFixtures
            3 -> if time <= 9.5 then printFixtureInfo 4 currentFixtures else if time <= 19.5 then printFixtureInfo 5 currentFixtures else putStrLn("No match ahead!")
            -- All matches are finished
            otherwise -> putStrLn("No match ahead!")

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Calls printFixtureInfo for each match i in range [0,5] recursively
-- If i equal to maximumNumberOfMatches, return
-- Else call printAllFixturesUtility recursively for i+1
printAllFixturesUtility i fixtures = if i == maximumNumberOfMatches then return() else do
    printFixtureInfo i fixtures
    printAllFixturesUtility (i+1) fixtures


-- Prints fixture details
-- Base case for fixture: When argument is "all", print all fixtures details
fixture "all" = do
    g <- newStdGen
    let temp = randomR (1, 100000) g
    let newSeed = fst(temp)
    let permutedTeams = (permutations listOfTeams)!!newSeed
    let fixtures = getFixtures permutedTeams
    writeg permutedTeams
    printAllFixturesUtility 0 fixtures

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Prints fixture details of specified team
fixture team = do
    permutedTeams <- readg
    let currentFixtures = getFixtures permutedTeams
    if null permutedTeams then
        putStrLn "Fixtures not initalized"
    else
        -- If team exists, then write fixture details of that team
        -- Else print error 
        case elemIndex team permutedTeams of
            Just id -> if id < maximumNumberOfMatches then printFixtureInfo id currentFixtures else printFixtureInfo (id-maximumNumberOfMatches) currentFixtures
            Nothing -> putStrLn "Team does not exist!"

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- List of teams participating
listOfTeams = ["BS", "CM", "CH", "CV", "CS", "DS", "EE", "HU", "MA", "ME", "PH", "ST"]
-- Match time information
dateTimeInfo = [("1-12-2020","9:30AM"),("1-12-2020","7:30PM"),("2-12-2020","9:30AM"),("2-12-2020","7:30PM"),("3-12-2020","9:30AM"),("3-12-2020","7:30PM")]

-- Number of matches
maximumNumberOfMatches = length dateTimeInfo

-- Prints match information in format: Team1 vs Team2     Date     Time
printFixtureInfo n fixtures = putStrLn ((fst(fixtures!!n))++" vs "++(snd(fixtures!!n))++"     "++(fst (dateTimeInfo!!n))++"     "++(snd(dateTimeInfo!!n)))

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- System random requirements
listg :: IORef [[Char]]
listg = unsafePerformIO (newIORef [])

readg :: IO [[Char]]
readg = readIORef listg

writeg :: [[Char]] -> IO ()
writeg value = writeIORef listg value

-----------------------------------------------------------------------------------------------------------------------------------------------------------