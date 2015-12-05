module Hello (
  Configuration(..),
  TheOutsideWorld(..),
  app
  ) where

import           System.Environment hiding (getArgs)
import           System.IO          hiding (putStrLn)

import qualified System.Environment
import qualified System.IO
import qualified System.TimeIt

import           Configuration      (Configuration (..), getTarget)

class Monad m => TheOutsideWorld m where
  time :: m a -> m (Double, a)
  getArgs :: m [String]
  emit :: String -> m ()

instance TheOutsideWorld IO where
  time = System.TimeIt.timeItT
  getArgs = System.Environment.getArgs
  emit = System.IO.putStrLn

makeGreeting :: String -> String
makeGreeting = (++) "hello, "

app :: (TheOutsideWorld m, Configuration m) => m ()
app = do
  (duration, _) <- time $ do
    (path:_) <- getArgs
    target <- getTarget path
    emit (makeGreeting target)
  emit ("It took: " ++ show duration)
