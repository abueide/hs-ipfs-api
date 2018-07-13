module Main where
import IPFS
import IPFS.Pubsub
import Servant.API
import Servant.Client
import Network.HTTP.Client (newManager, defaultManagerSettings)

printResultStream :: Show a => ResultStream a -> IO ()
printResultStream (ResultStream k) = k $ \getResult ->
       let loop = do
            r <- getResult
            case r of
                Nothing -> return ()
                Just x -> print x >> loop
       in loop

main :: IO ()
main = do
      pubtest <- runQuery (pub ["chat", pubformat "this is a test"])
      case pubtest of
        Left err -> putStrLn $ show err
        Right _ -> putStrLn "pubtest completed successfully"
      subtest <- runQuery (sub ["chat"])
      case subtest of
        Left err -> putStrLn $ show err
        Right stream -> do
          putStrLn "subtest connected successfully"
          printResultStream stream
