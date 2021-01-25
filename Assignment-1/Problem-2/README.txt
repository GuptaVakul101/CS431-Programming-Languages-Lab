FOR COMPILATION -
    USING MAKE COMMAND -
    Just type 'make' and all the source files would get compiled

    OR DIRECTLY USING THE COMMAND -
    'javac -d . *.java'

A package named 'problem2' would be created

FOR EXECUTION -
    USE THE COMMAND -
        'java problem2.DistribitedSystem < input.txt' (If you want to take the input from file)

        OR

        'java problem2.DistribitedSystem' (For manually giving the input)

        Here again you can change the input file for checking different test cases.
        For manually giving input, interactive questions would be asked.

        HOW TO MANUALLY GIVE INPUT -

        Type 1 to update marks -
            Here first give the instructors designation - Type 'CC', 'TA1' or 'TA2'
            Then give the roll number (like 174101055)
            Then give the marks you want to increase or decrease (like 3 or -7)
        Type 2 to start the exceution -
            All the change of marks given so far would get evaluated
        Type 3 to exit

Note -
The changes would be reflected in the General_Output.txt file and not the Stud_Info.txt file
All the records are taken from input file 'Stud_Info.txt'
Outputs are generated in the Output folder. Three files would be created inside the Output folder-
    1. General_Output.txt - It contains all the updated records of students after execution in arbitrary order
    2. Sorted_Name.txt - It contains all the updated records of students after execution sorted by Name
    3. Sorted_Roll.txt - It contains all the updated records of students after execution sorted by Roll Number
