# haskell-ipfs-api

haskell-ipfs-api uses the Servant library to create a type safe http api that can be exported to several different languages including javascript, ruby, elm, purescript, and possibly more.

### Example

See app/Main.hs
```
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

```

### Implementation Progress
hs-ipfs-api currently has few functions implemented. I will implement them as I need them for my project, but if one that you need is missing open an issue and I will try to implement the most popular ones first. Please contribute if you can!


