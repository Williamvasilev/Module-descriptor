{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import qualified Data.ByteString.Lazy as BL
import Data.Csv
import Data.Vector (toList)
import ModuleData
import ModuleValidation
import ValidatedModuleData 

-- Define FromNamedRecord instance for ModuleDescriptor
instance FromNamedRecord ModuleDescriptor where
    parseNamedRecord r = do
        code'              <- r .: "Code"
        fullTitle'         <- r .: "Full_Title"
        shortTitle'        <- r .: "Short_Title"
        credits'           <- r .: "Credits"
        level'             <- r .: "Level"
        aim'               <- r .: "Aim"
        department'        <- r .: "Department"
        indicativeContent' <- parseListStrings =<< r .: "Indicative_Content"
        learningOutcomes'  <- parseListStrings =<< r .: "Learning_Outcomes"
        assessmentCriteria'<- parseListStrings =<< r .: "Assessment_Criteria"
        return $ ModuleDescriptor code' fullTitle' shortTitle' credits' level' aim' department' indicativeContent' learningOutcomes' assessmentCriteria'

-- Takes a string and parses it into a list containing that string. 
--parseListStrings :: String -> Parser [String]
--parseListStrings = return . (:[])

-- Takes a string and parses it into a list of lines.
parseListStrings :: String -> Parser [String]
parseListStrings = return . lines

main :: IO ()
main = do
    -- Parse the CSV file
    csvData <- BL.readFile "data/Module_Descriptors.csv"
    case decodeByName csvData of
        Left err -> putStrLn $ "Error parsing CSV: " ++ err
        Right (_, v) -> do
            let allModules = toList v :: [ModuleDescriptor]
            
            -- Validate module descriptors
            let validatedModules = map validateModuleDescriptor allModules
            
            -- Separate valid and invalid modules
            let (validModules, invalidModules) = separateValidations validatedModules
            
            -- Generate reports
            writeFile "valid_modules.md" $ generateModuleMarkdown validModules
            writeFile "invalid_modules.md" $ generateModuleMarkdown invalidModules

generateModuleMarkdown :: [ValidatedModuleDescriptor] -> String
generateModuleMarkdown modules =
    let header = "## Module Report\n"
        moduleStrs = map formatModule modules
    in header ++ unlines moduleStrs

formatModule :: ValidatedModuleDescriptor -> String
formatModule moduleDesc = unlines
    [ "### Module Code: " ++ formatResult (validatedCode moduleDesc)
    , "**Full Title:** " ++ formatResult (validatedFullTitle moduleDesc)
    , "**Short Title:** " ++ formatResult (validatedShortTitle moduleDesc)
    , "**Credits:** " ++ formatCredits (validatedCredits moduleDesc)
    , "**Level:** " ++ formatResult (validatedLevel moduleDesc)
    , "**Aim:** " ++ formatResult (validatedAim moduleDesc)
    , "**Department:** " ++ formatResult (validatedDepartment moduleDesc)
    , "**Indicative Content:** " ++ formatList (validatedIndicativeContent moduleDesc)
    , "**Learning Outcomes:** " ++ formatList (validatedLearningOutcomes moduleDesc)
    , "**Assessment Criteria:** " ++ formatList (validatedAssessmentCriteria moduleDesc)
    , "---"
    ]
    where
        formatResult (Right value) = value
        formatResult (Left error) = "INVALID: " ++ error
        
        formatCredits (Right value) = show value
        formatCredits (Left error) = "INVALID: " ++ error
        
        formatList (Right list) = unlines list
        formatList (Left error) = "INVALID: " ++ error