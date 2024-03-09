{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Home where

import Import

-- Displayed Keyboard
allTiles :: [[Text]]
allTiles = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], 
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["ENTER", "Z", "X", "C", "V", "B", "N", "M" ,"BACK"]]

fillerSpaces :: Int -> [Char]
fillerSpaces len = map (\_ -> ' ') [1..(5-len)]
fillerWords :: Int -> [String]
fillerWords len = map (\_ -> "     ") [1..(6-len)]

-- Session data gets saved as a text so we must convert it into the type we want
formatList :: Text -> [String]
formatList "" = []
formatList txt = splitString $ unpack txt

splitString :: String -> [String]
splitString (x1:x2:x3:x4:x5:x6) = [x1, x2, x3, x4, x5]:(splitString x6)
splitString _ = []

getHomeR :: Handler Html
getHomeR = do
    -- Getting current game from session
    currentGuesses <- lookupSession "gameGuesses"
    let guessedWords = case currentGuesses of
            Just guesses -> formatList $ guesses
            Nothing -> [] :: [String]
   
    currentPattern <- lookupSession "gamePattern"
    let guessedColors = case currentPattern of
            Just colors -> formatList $ colors
            Nothing -> [] :: [String]
 
    currentAnswer <- lookupSession "gameAnswer"
    case currentAnswer of
        Just _ -> return()
        Nothing -> setSession "gameAnswer" "ALOHA"

    -- Hamlet file displays thess lists on page load
    let displayedWords = take 6 (guessedWords ++ (fillerWords $ length guessedWords))
    let displayedColors = take 6 (guessedColors ++ (fillerWords $ length guessedColors))

    defaultLayout $ do
        setTitle "Wordle Plus"
        $(widgetFile "tiles")
