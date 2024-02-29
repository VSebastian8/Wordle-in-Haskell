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

-- Request data
data JsonGuess = JsonGuess 
    { guess :: Text }
-- Response data
data JsonPattern = JsonPattern
    { pattern :: [Text] }

-- We need the classes for converting between JSON and our Haskell types (Text and [Text])
instance FromJSON JsonGuess where
    parseJSON =  withObject "JsonGuess" $ \v -> 
        JsonGuess <$> v .: "guess"
instance ToJSON JsonPattern where 
    toJSON (JsonPattern pat) = object ["pattern" .= pat]

postWordR :: Handler Value
postWordR = do
    guessRequestBody <- requireCheckJsonBody :: Handler JsonGuess
    let userGuess = guess guessRequestBody
    
    -- Perform server side validations
    if (length userGuess) /= 5
        then sendResponseStatus status400 (object ["message" .= ("Not 5 letters" :: String)])
        else do
            -- Save guess in the current guesses from session
            current <- lookupSession "game"
            case current of 
                Just guesses -> setSession "game" (guesses ++ userGuess)
                Nothing -> setSession "game" userGuess
            returnJson $ JsonPattern ["Gray", "Yellow", "Green", "Gray", "Gray"] 