module Hello (
  app
) where

import           System.IO          hiding (putStrLn)

import           Configuration      (Configuration(..), getTarget)
import           TheOutsideWorld    (TheOutsideWorld(..))

makeGreeting :: String -> String
makeGreeting = (++) "hello, "

app :: (TheOutsideWorld m, Configuration m) => m ()
app = do
  (duration,_) <- time $ do
    (path:_) <- getArgs
    target <- getTarget path
    emit (makeGreeting target)
  emit ("It took: " ++ show duration)
