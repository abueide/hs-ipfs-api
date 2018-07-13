module IPFS where


import Servant.Client
import Network.HTTP.Client (newManager, defaultManagerSettings)


ipfsUrl :: BaseUrl
ipfsUrl = BaseUrl Http "localhost" 5001 "/api/v0"

runQuery :: ClientM a -> IO(Either ServantError a)
runQuery clientm = do
    manager' <- newManager defaultManagerSettings
    res <- runClientM clientm (mkClientEnv manager' ipfsUrl)
    return res


