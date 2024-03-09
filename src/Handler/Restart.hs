{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveAnyClass #-}

module Handler.Restart where

import Import

getRestartR :: Handler ()
getRestartR = do
    deleteSession "gameGuesses"
    deleteSession "gamePattern"
    deleteSession "gameAnswer"
    redirect HomeR
