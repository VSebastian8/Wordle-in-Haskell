{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Description where

import Import

getDescriptionR :: Handler Html
getDescriptionR = do
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Project Description"
        $(widgetFile "homepage")
