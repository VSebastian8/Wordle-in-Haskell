{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Description where

import Import
-- import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
-- import Text.Julius (RawJS (..))

-- Define our data that will be used for creating the form.

getDescriptionR :: Handler Html
getDescriptionR = do
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Project Description"
        $(widgetFile "homepage")
