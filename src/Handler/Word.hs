{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveAnyClass #-}

module Handler.Word where

import Import
import Data.Aeson (withObject)

data Color = Gray | Yellow | Green 
    deriving Show

data Pattern = Pattern [Color]

-- Request data
data JsonGuess = JsonGuess 
    { word :: Text }
-- Response data

stringifyPattern :: Pattern -> Text
stringifyPattern (Pattern colors) = stringifyColors colors

stringifyColors :: [Color] -> Text
stringifyColors [] = ""
stringifyColors (color:rest) = case color of
    Gray -> "g" ++ stringifyColors rest 
    Yellow -> "y" ++ stringifyColors rest
    Green -> "v" ++ stringifyColors rest

-- We need the classes for converting between JSON and our Haskell types (Text and [Text])
instance FromJSON JsonGuess where
    parseJSON =  withObject "JsonGuess" $ \v -> 
        JsonGuess <$> v .: "word"
instance ToJSON Pattern where 
    toJSON (Pattern colors) = object ["pattern" .= map show colors]

-- Logic for game pattern matching

-- When calculating the green letters, we also replace them in the guess/answer 
-- so that we don't consider them when calculating the yellow letters
matchPattern :: String -> String -> Pattern
matchPattern answer guess =
    let (greenList, (restAnswer, restGuess)) = foldr(\(a, b) (list, (ans, gus)) ->
            if a == b 
                then (Green:list, ('*':ans, '-':gus)) 
                else (Gray:list, (a:ans, b:gus))) ([], ([], [])) (zip answer guess)
        (yellowList, _) = foldr(\letter (list, ans) -> 
            if elem letter ans 
                then (Yellow:list, consume ans letter) 
                else (Gray:list, ans)) ([], restAnswer) restGuess
    in Pattern $ combine greenList yellowList

-- Replaces the yellow letter in the answer 
-- so that two letters in the userGuess won't match with the same letter
consume :: String -> Char -> String
consume "" _ = ""
consume (s:rest) letter 
    |s == letter = '*':rest
    |otherwise = s:(consume rest letter) 

-- Used for combining the greenLetters and yellowLetters calculated above
combine :: [Color] -> [Color] -> [Color]
combine (c1:rest1) (c2:rest2) = (resolve c1 c2):(combine rest1 rest2)
    where resolve :: Color -> Color -> Color
          resolve Green _ = Green
          resolve _ Green = Green
          resolve Yellow Yellow = Yellow
          resolve Yellow Gray = Yellow
          resolve Gray Yellow = Yellow
          resolve Gray Gray = Gray
combine _ _ = []

postWordR :: Handler Value
postWordR = do
    guessRequestBody <- requireCheckJsonBody :: Handler JsonGuess
    let userGuess = word guessRequestBody
    
    -- Perform server side validations
    if (length userGuess) /= 5
        then sendResponseStatus status400 (object ["message" .= ("Not 5 letters" :: String)])
        else do 
            currentAnswer <- lookupSession "gameAnswer"
            case currentAnswer of
                Nothing -> sendResponseStatus status400 (object ["message" .= ("No answer selected" :: String)])
                Just gameAnswer -> do

                    -- Save guess in the current game guesses from session
                    currentGuesses <- lookupSession "gameGuesses"
                    case currentGuesses of 
                        Just guesses -> setSession "gameGuesses" (guesses ++ userGuess)
                        Nothing -> setSession "gameGuesses" userGuess        

                    --Calculate pattern
                    let guessPattern = matchPattern (unpack gameAnswer) (unpack userGuess)

                    -- Save pattern in the current game pattern from session
                    currentPattern <- lookupSession "gamePattern"
                    case currentPattern of
                        Just colors -> setSession "gamePattern" (colors ++ (stringifyPattern guessPattern))
                        Nothing -> setSession "gamePattern" (stringifyPattern guessPattern)

                    returnJson $ guessPattern