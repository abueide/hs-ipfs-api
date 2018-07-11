{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
module Main where

import Data.String.Utils (replace)
import Data.Proxy
import Data.Text
import Data.Time (UTCTime)
import GHC.Generics
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Servant.API
import Servant.Client



-- endpoint = "http://localhost:5001/api/v0/"
type IPFS = "api" :> "v0" :> "pubsub" :> "pub" :> QueryParams "arg" String :>  Get '[PlainText] Text

pub :: String -> String -> ClientM Text
pub topic message = client (Proxy :: Proxy IPFS) [topic, (Data.String.Utils.replace " " "%20" message) ++ "%0A" ]

queries :: ClientM (Text)
queries = do
    response <- pub  "chat" "this is a test message"
    return (response)

main :: IO ()
main = do
  manager' <- newManager defaultManagerSettings
  res <- runClientM queries (mkClientEnv manager' (BaseUrl Http "localhost" 5001 ""))
  print $ Data.String.Utils.replace " " "%20" "this is a test message" ++ "%0A"
