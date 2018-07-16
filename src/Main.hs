{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Reflex.Do
import qualified Data.Text as T
import qualified Data.Map as Map
import Data.Monoid
import Control.Monad.Trans (liftIO)
import IPFS
import IPFS.Pubsub


main :: IO ()
main = do
 mainWidget bodyElement

bodyElement :: MonadWidget t m => m ()
bodyElement = do
  t1 <- textInput def
  b1 <- button "Send"
  test <- performEvent_ $ liftIO . runQuery $ pub "chat" <$> tag (current $ value t1) b1
  return ()

