module TheOutsideWorld (
  TheOutsideWorld(..),
) where

import           Prelude            hiding (readFile)

import qualified Prelude
import qualified System.Environment
import qualified System.IO
import qualified System.TimeIt

class Monad m => TheOutsideWorld m where
  measureTime :: m a -> m (Double, a)
  getArgs :: m [String]
  emit :: String -> m ()
  readFile :: FilePath -> m String

instance TheOutsideWorld IO where
  measureTime = System.TimeIt.timeItT
  getArgs = System.Environment.getArgs
  emit = System.IO.putStrLn
  readFile = Prelude.readFile
