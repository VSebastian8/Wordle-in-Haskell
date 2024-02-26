{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveAnyClass #-}

module Handler.Word where

import Import
import Data.Aeson (FromJSON, ToJSON, withObject)

data JsonRequest = JsonRequest 
    { guess :: Text }
data JsonResponse = JsonResponse
    { message :: Text
    , number :: Int
    }

instance FromJSON JsonRequest where
    parseJSON =  withObject "JsonRequest" $ \v -> 
        JsonRequest <$> v .: "guess"
instance ToJSON JsonResponse where 
    toJSON (JsonResponse m n) = object ["message" .= m, "number" .= n]

postWordR :: Handler Value
postWordR = do
    requestBody <- requireJsonBody :: Handler JsonRequest
    let userGuess = guess requestBody
    returnJson $ JsonResponse ("Hello, " ++ userGuess) 42