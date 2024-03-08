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
    { guess :: Text }
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
        JsonGuess <$> v .: "guess"
instance ToJSON Pattern where 
    toJSON (Pattern colors) = object ["pattern" .= map show colors]


postWordR :: Handler Value
postWordR = do
    guessRequestBody <- requireCheckJsonBody :: Handler JsonGuess
    let userGuess = guess guessRequestBody
    
    -- Perform server side validations
    if (length userGuess) /= 5
        then sendResponseStatus status400 (object ["message" .= ("Not 5 letters" :: String)])
        else do
            -- Save guess in the current game guesses from session
            currentGuesses <- lookupSession "gameGuesses"
            case currentGuesses of 
                Just guesses -> setSession "gameGuesses" (guesses ++ userGuess)
                Nothing -> setSession "gameGuesses" userGuess

            --Calculate pattern
            let guessPattern = Pattern [Gray, Yellow, Green, Gray, Gray]
            
            -- Save pattern in the current game pattern from session
            currentPattern <- lookupSession "gamePattern"
            case currentPattern of
                Just colors -> setSession "gamePattern" (colors ++ (stringifyPattern guessPattern))
                Nothing -> setSession "gamePattern" (stringifyPattern guessPattern)

            returnJson $ guessPattern