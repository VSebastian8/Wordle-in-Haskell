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

addSpaces :: Int -> [Char]
addSpaces len = map (\_ -> ' ') [1..(5-len)]
addWords :: Int -> [String]
addWords len = map (\_ -> "     ") [1..(6-len)]

-- Session data gets saved as a text, we must convert it into the type we want
guessList :: Text -> [String]
guessList "" = []
guessList txt = splitString $ unpack txt

patternList :: String -> [String]
patternList "" = []
patternList str = splitString str

splitString :: String -> [String]
splitString (x1:x2:x3:x4:x5:x6) = [x1, x2, x3, x4, x5]:(splitString x6)
splitString _ = []

getHomeR :: Handler Html
getHomeR = do
    current <- lookupSession "game"
    -- Hamlet file displays this list on page load
    let guessedWords = case current of
            Just guesses -> guessList $ guesses
            Nothing -> [] :: [String]
    pat <- lookupSession "gamePattern"
    let colors = case pat of
            Just col -> guessList $ col 
            Nothing -> [] :: [String]
    let displayedWords = guessedWords ++ (addWords $ length guessedWords)
    let displayedColors = colors ++ (addWords $ length colors)
    defaultLayout $ do
        setTitle "Wordle Plus"
        $(widgetFile "tiles")
