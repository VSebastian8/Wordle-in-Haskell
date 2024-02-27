{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Home where

import Import
-- import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
-- import Text.Julius (RawJS (..))

-- Define our data that will be used for creating the form.
data FileForm = FileForm
    { fileInfo :: FileInfo
    , fileDescription :: Text
    }

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes.yesodroutes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.

allTiles :: [[Text]]
allTiles = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], 
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["ENTER", "Z", "X", "C", "V", "B", "N", "M" ,"BACK"]]



-- displayedWords :: [[Char]]
-- displayedWords = guessedWords ++ [currentWord ++ (addSpaces $ length currentWord)] ++ (addWords $ length guessedWords)
--     where addSpaces :: Int -> [Char]
--           addSpaces len = map (\_ -> ' ') [1..(5-len)]
--           addWords :: Int -> [[Char]]
--           addWords len = map (\_ -> "     ") [1..(5-len)]
addSpaces :: Int -> [Char]
addSpaces len = map (\_ -> ' ') [1..(5-len)]
addWords :: Int -> [[Char]]
addWords len = map (\_ -> "     ") [1..(5-len)]

getHomeR :: Handler Html
getHomeR = do
    let guessedWords = ["FIRST", "SECON"] :: [[Char]]
    let currentWord = "TRY" :: [Char]
    let displayedWords = guessedWords ++ [currentWord ++ (addSpaces $ length currentWord)] ++ (addWords $ length guessedWords)
    current <- lookupSession "current"
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Wordle"
        $(widgetFile "homepage")
        $(widgetFile "tiles")
