{-# LANGUAGE DeriveGeneric #-}

module ValidatedModuleData where

import GHC.Generics (Generic)

data ValidatedModuleDescriptor = ValidatedModuleDescriptor
    { validatedCode :: Either String String
    , validatedFullTitle :: Either String String
    , validatedShortTitle :: Either String String
    , validatedCredits :: Either String Int
    , validatedLevel :: Either String String
    , validatedAim :: Either String String
    , validatedDepartment :: Either String String
    , validatedIndicativeContent :: Either String [String]
    , validatedLearningOutcomes :: Either String [String]
    , validatedAssessmentCriteria :: Either String [String]
    } deriving (Show, Generic)

-- Get validation results for each field
validatedFields :: ValidatedModuleDescriptor -> [Either String String]
validatedFields validatedModule =
    [ validatedCode validatedModule
    , validatedFullTitle validatedModule
    , validatedShortTitle validatedModule
    , either (Left . show) (const (Right "Valid")) (validatedCredits validatedModule) -- converts error message to string using show if its invalid and if its valid it returns the value
    , validatedLevel validatedModule
    , validatedAim validatedModule
    , validatedDepartment validatedModule
    , either (Left . show) (const (Right "Valid")) (validatedIndicativeContent validatedModule) 
    , either (Left . show) (const (Right "Valid")) (validatedLearningOutcomes validatedModule)
    , either (Left . show) (const (Right "Valid")) (validatedAssessmentCriteria validatedModule)
    ]