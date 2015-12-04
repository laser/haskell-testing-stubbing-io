module Hello (app, TheOutsideWorld(..)) where

import           Prelude            hiding (readFile)
import           System.Environment hiding (getArgs)
import           System.IO          hiding (putStrLn, readFile)

import qualified Prelude
import qualified System.Environment
import qualified System.IO
import qualified System.TimeIt

class Monad m => TheOutsideWorld m where
  time :: m a -> m (Double, a)
  readFile :: FilePath -> m String
  getArgs :: m [String]
  emit :: String -> m ()

instance TheOutsideWorld IO where
  time = System.TimeIt.timeItT
  readFile = Prelude.readFile
  getArgs = System.Environment.getArgs
  emit = System.IO.putStrLn

makeGreeting :: String -> String
makeGreeting = (++) "hello, "

getTarget :: TheOutsideWorld m => FilePath -> m String
getTarget = readFile

app :: TheOutsideWorld m => m ()
app = do
  (duration, _) <- time $ do
    (path:_) <- getArgs
    target <- getTarget path
    emit (makeGreeting target)
  emit ("It took: " ++ show duration)
