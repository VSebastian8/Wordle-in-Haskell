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

data JsonGuess = JsonGuess 
    { guess :: Text }
data JsonPattern = JsonPattern
    { pattern :: [Text] }

instance FromJSON JsonGuess where
    parseJSON =  withObject "JsonGuess" $ \v -> 
        JsonGuess <$> v .: "guess"
instance ToJSON JsonPattern where 
    toJSON (JsonPattern pat) = object ["pattern" .= pat]

postWordR :: Handler Value
postWordR = do
    guessRequestBody <- requireCheckJsonBody :: Handler JsonGuess
    let userGuess = guess guessRequestBody
    setSession "current" userGuess
    if (length userGuess) /= 5
        then sendResponseStatus status400 (object ["message" .= ("Not 5 letters" :: String)])
        else returnJson $ JsonPattern ["Gray", "Yellow", "Green", "Gray", "Gray"] 