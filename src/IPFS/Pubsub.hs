{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
module IPFS.Pubsub where
import IPFS
import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Data.Monoid
import Data.Proxy
import Data.Text (Text)
import GHC.Generics
import Servant.API
import Servant.Client
import Data.String.Utils (replace)
import Data.Word
import Data.Aeson (FromJSON, parseJSON, withObject, (.:))
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Data.ByteString.Base64 (decodeLenient)
import Data.ByteString.Char8 (pack, unpack)
import Data.ByteString (ByteString)



-- API Query Types
type PubSubAPI = "pubsub" :> "pub" :> QueryParams "arg" String :> Get '[JSON] NoContent
           :<|>  "pubsub" :> "sub" :> QueryParams "arg" String :> StreamGet NewlineFraming JSON (ResultStream PubSubMessage)

pubsubapi :: Proxy PubSubAPI
pubsubapi = Proxy

-- API Function Signatures
pub :: [String] -> ClientM (NoContent)
sub :: [String] -> ClientM(ResultStream PubSubMessage)

-- Bind the API Functions
pub :<|> sub = client pubsubapi


--------------------------PubSub Data Types--------------------------
-- Message sent over http from /v0/api/pubsub/sub
data PubSubMessage = PubSubMessage {
  from :: String,
  content :: String, -- Data field renamed due keyword collision
  seqno :: String,
  topicIDs :: [String]
} deriving (Eq, Ord, Generic, Show)
-- Custom defined FromJSON because we cannot use data as a type name
instance FromJSON PubSubMessage where
  parseJSON = withObject "Message" $ \o -> do
    from     <- o .: "from"
    content  <- o .: "data"
    seqno    <- o .: "seqno"
    topicIDs <- o .: "topicIDs"
    return (PubSubMessage (from) (decodeString content) (seqno) (topicIDs))

--------------------------Utility Functions--------------------------
--Decodes a base 64 string
decodeString :: String -> String
decodeString = unpack . decodeLenient . pack

--Format messages before they get sent via pubsub/pub
pubformat :: String -> String
pubformat s = s ++ "\r\n" -- Adds newline to end of message


