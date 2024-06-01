{-# LANGUAGE DeriveGeneric #-}

module ModuleData where

import GHC.Generics (Generic)

data ModuleDescriptor = ModuleDescriptor
    { code :: String
    , fullTitle :: String
    , shortTitle :: String
    , credits :: Int
    , level :: String
    , aim :: String
    , department :: String
    , indicativeContent :: [String]
    , learningOutcomes :: [String]
    , assessmentCriteria :: [String]
    } deriving (Show, Generic)