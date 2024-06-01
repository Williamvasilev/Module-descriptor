module ModuleValidation where

import Data.Char (isLower, isUpper, isDigit)
import ModuleData
import ValidatedModuleData
import Data.Either (isRight, isLeft)

-- Function to validate a single module descriptor
validateModuleDescriptor :: ModuleDescriptor -> ValidatedModuleDescriptor
validateModuleDescriptor moduleDesc =
    ValidatedModuleDescriptor
        { validatedCode = if isCodeValid
                            then Right (code moduleDesc)
                            else Left "Invalid module code"
        , validatedFullTitle = if isTitleValid
                                 then Right (fullTitle moduleDesc)
                                 else Left "Full title is not in title case"
        , validatedShortTitle = if isShortTitleValid
                                then Right (shortTitle moduleDesc)
                                else Left "Short title is not valid"
        , validatedCredits = if isCreditsValid
                                then Right (credits moduleDesc)
                                else Left "Invalid credits"
        , validatedLevel = if isLevelValid
                             then Right (level moduleDesc)
                             else Left "Invalid level"
        , validatedAim = if isAimValid
                           then Right (aim moduleDesc)
                           else Left "Invalid aim"
        , validatedDepartment = if isDepartmentValid
                                  then Right (department moduleDesc)
                                  else Left "Invalid department"
        , validatedIndicativeContent = if isIndicativeContentValid
                                          then Right (indicativeContent moduleDesc)
                                          else Left "Invalid indicative content"
        , validatedLearningOutcomes = if isLearningOutcomesValid
                                          then Right (learningOutcomes moduleDesc)
                                          else Left "Invalid learning outcomes"
        , validatedAssessmentCriteria = if isAssessmentCriteriaValid
                                           then Right (assessmentCriteria moduleDesc)
                                           else Left "Invalid assessment criteria"
        }
    where
        isCodeValid = checkModuleCode (code moduleDesc)
        isTitleValid = checkTitleCase (fullTitle moduleDesc)
        isShortTitleValid = checkShortTitle (shortTitle moduleDesc) (fullTitle moduleDesc)
        isCreditsValid = checkCredits (credits moduleDesc)
        isLevelValid = checkLevel (level moduleDesc)
        isAimValid = checkAim (aim moduleDesc)
        isDepartmentValid = checkDepartment (department moduleDesc)
        isIndicativeContentValid = checkIndicativeContent (indicativeContent moduleDesc)
        isLearningOutcomesValid = checkLearningOutcomes (level moduleDesc) (learningOutcomes moduleDesc)
        isAssessmentCriteriaValid = checkAssessmentCriteria (assessmentCriteria moduleDesc)

-- Check if the module code has the first character uppercase, followed by digits and the length of the code must be between 6 and 9
checkModuleCode :: String -> Bool
checkModuleCode moduleCode =
    length moduleCode >= 6 &&
    length moduleCode <= 9 &&
    isUpper (head moduleCode) &&  -- Check if the first character is uppercase
    all isDigit (tail moduleCode)

-- Check if the full title is in title case with exceptions
checkTitleCase :: String -> Bool
checkTitleCase title = all isFirstLetterUppercase $ words title
    where isFirstLetterUppercase word
            | word `elem` exceptions = True
            | otherwise = case word of
                [] -> False
                (x:xs) -> isUpper x && all isLower xs
          exceptions = ["a", "an", "and", "as", "at", "but", "by", "for", "in", "nor", "of", "on", "or", "the"]

-- Check if the short title has max of 30 characters and = to fulltitle if fulltitle is <30 characters.
checkShortTitle :: String -> String -> Bool
checkShortTitle shortTitle fullTitle =
    let maxLength = 30
    in if length fullTitle <= maxLength
        then shortTitle == fullTitle
        else length shortTitle <= maxLength

-- Check if the credits is a positive integer, multiple of 5, max 30.
checkCredits :: Int -> Bool
checkCredits credits =
    credits > 0 &&             
    credits <= 30 &&           
    credits `mod` 5 == 0   

-- Check if the level is one of "Introductory, Intermediate, Advanced, and PostGraduate"
checkLevel :: String -> Bool
checkLevel level =
    level `elem` ["Introductory", "Intermediate", "Advanced", "Postgraduate"]

-- Check if the aim has between 500 to 2000 characters inclusive
checkAim :: String -> Bool
checkAim aim = length aim >= 500 && length aim <= 2000

-- Check if the department is one of one of Science, Computing and Mathematics, Engineering Technology
checkDepartment :: String -> Bool
checkDepartment department =
    department `elem` ["Science", "Computing and Mathematics", "Engineering Technology"]

-- Check if a sentence starts with a capital letter
startsWithCapital :: String -> Bool
startsWithCapital [] = False
startsWithCapital (x:_) = isUpper x

-- Check if the indicative content starts with a capital letter
checkIndicativeContent :: [String] -> Bool
checkIndicativeContent [] = True -- empty list is true
checkIndicativeContent (sentence:sentences) =
    startsWithCapital sentence && all (\s -> not (null s) && startsWithCapital s) sentences

-- Check if the number of learning outcomes meets requirements based on the module level
checkLearningOutcomes :: String -> [String] -> Bool
checkLearningOutcomes level outcomes
    | level `elem` ["Introductory", "Intermediate"] = length outcomes >= 5
    | level == "Advanced" = length outcomes >= 7
    | level == "Postgraduate" = length outcomes >= 8
    | otherwise = True -- If level is not specified, validation passes

-- Check if the assessment criteria should be at least 4 categories (lines) At least one occurrence of ‘%’ in each line.
checkAssessmentCriteria :: [String] -> Bool
checkAssessmentCriteria [] = True -- empty list is true
checkAssessmentCriteria (line:lines) =
    hasRequiredCategories && all hasPercentage lines
    where
        hasRequiredCategories = length (line:lines) >= 4
        hasPercentage str = '%' `elem` str

-- Separate valid and invalid modules
separateValidations :: [ValidatedModuleDescriptor] -> ([ValidatedModuleDescriptor], [ValidatedModuleDescriptor])
separateValidations = foldr classifyModules ([], []) -- foldr traverses the list of ValidatedModuleDescriptor
    where
        classifyModules moduleDesc (valid, invalid) =
            if isFullyValidated moduleDesc
                then (moduleDesc : valid, invalid)
                else (valid, moduleDesc : invalid)

-- Check if a module is fully validated
isFullyValidated :: ValidatedModuleDescriptor -> Bool
isFullyValidated validatedModule =
    all isRight $ validatedFields validatedModule