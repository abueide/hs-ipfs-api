module Main where
import IPFS
import IPFS.Pubsub
import Servant.API


main :: IO ()
main = do
-- QueryParams takes in a List of Strings to append multiple of the same parameter. Example: ["chat", "test"]
-- would append ?arg=chat?arg=test". See the arguments section at https://ipfs.io/docs/api/ for more info.
      pubtest <- runQuery (pub ["chat", pubformat "this is a test"])
      case pubtest of
        Left err -> putStrLn $ show err
        Right _ -> putStrLn "pubtest completed successfully"
      subtest <- runQuery (sub ["chat"])
      -- Infinite loop that displays new messages when it recieves them
      case subtest of
        Left err -> putStrLn $ show err
        Right stream -> do
          putStrLn "subtest connected successfully"
          printResultStream stream

printResultStream :: Show a => ResultStream a -> IO ()
printResultStream (ResultStream k) = k $ \getResult ->
       let loop = do
            r <- getResult
            case r of
                Nothing -> return ()
                Just x -> print x >> loop
       in loop
