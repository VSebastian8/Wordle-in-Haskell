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

allTiles :: [[Text]]
allTiles = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], 
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["ENTER", "Z", "X", "C", "V", "B", "N", "M" ,"BACK"]]

addSpaces :: Int -> [Char]
addSpaces len = map (\_ -> ' ') [1..(5-len)]
addWords :: Int -> [String]
addWords len = map (\_ -> "     ") [1..(6-len)]

guessList :: Text -> [String]
guessList "" = []
guessList txt = splitString $ unpack txt

splitString :: String -> [String]
splitString (x1:x2:x3:x4:x5:x6) = [x1, x2, x3, x4, x5]:(splitString x6)
splitString _ = []

getHomeR :: Handler Html
getHomeR = do
    current <- lookupSession "game"
    let guessedWords = case current of
            Just guesses -> guessList $ guesses
            Nothing -> [] :: [String]
    let displayedWords = guessedWords ++ (addWords $ length guessedWords)
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Wordle Plus"
        $(widgetFile "tiles")
