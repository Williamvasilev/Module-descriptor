[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/SnbCAMAv)
# This readme should include 

1. Student Name

William Vasilev (20093711)

2. Main learnings of project;

The main points i have learned during this assignment are:

- How to parse a csv file in haskell and make validation checks for the data.

- How different types are handled differently when validating. ex. string datatypes were much easier to work with than list of strings [string].

- How you parse a list is important because the first time i made a function to parse a list it would only work for indicative content and not for learning outcome or assessment criteria. This was because i was turning a string into a list with that string instead of having multiple string in a list.

- How to check if a module was fully validated and how to separate invalid and valid modules.

- How to generate md files for invalid and valid modules.

3. Main difficulties that you came across;

- When i tried to check for unique module code, fulltitle, and short title i tried using the nub function i found on stack overflow (https://stackoverflow.com/questions/3098391/unique-elements-in-a-haskell-list) the nub function removes duplicate elements from a list and i tried using this to create a new list and check all modules against this list to check for any duplicates, and if there wasnt any duplicates it would mean all values are unique. but this did not work and i realised this was causing a bigger issue that didn't make my validatemoduledescriptor function work so i removed the nub function completely.

- Originally i made all my validation checks to check for all modules instead of just one module, when i was creating .md files for invalid and valid modules it made all the modules invalid and showed all the modules in both files this was because of the function that checked for all modules instead of just 1, so i had to refactor my code so i'd have a function to check for 1 module and i mapped that function across all modules.

4. Any extra functionalities not mentioned in the spec that you implemented;

- I added some extra validation to full title to allow some exceptions. I did this because most of my invalid modules had all fields valid but full title just had a conjunction word and some conjunction words are allowed to be lower case in a title.

5. Reference to any material outside of notes used.

- nub function - (https://stackoverflow.com/questions/3098391/unique-elements-in-a-haskell-list) - no longer used but i used it in a previous version.

- const - (https://stackoverflow.com/questions/7402528/whats-the-point-of-const-in-the-haskell-prelude) - I used const to make int and list datatype fields valid if its right. I did this for my isFullyValid function which checks if a module is fully validated by using isRight. 

- isUpper, isLower, isDigit - (https://www.haskell.org/onlinereport/haskell2010/haskellch16.html) - used these functions to check if a character is uppercare, lowercase or if its a digit.

- isRight, isLeft - (https://hackage.haskell.org/package/base-4.19.1.0/docs/Data-Either.html) - I used isRight to check if a module is valid it puts them on the right, and for isleft i tried using it to put invalid on the left in my separateValidation function but i couldn't get this to work so i used foldr instead.

- lines - (https://zvon.org/other/haskell/Outputprelude/lines_f.html) - I used lines to parse list of strings by new line separators.
