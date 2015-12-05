module TheOutsideWorld (
  TheOutsideWorld(..),
) where

import           System.Environment hiding (getArgs)
import           System.IO          hiding (putStrLn)

import qualified System.Environment
import qualified System.IO
import qualified System.TimeIt

class Monad m => TheOutsideWorld m where
  time :: m a -> m (Double, a)
  getArgs :: m [String]
  emit :: String -> m ()

instance TheOutsideWorld IO where
  time = System.TimeIt.timeItT
  getArgs = System.Environment.getArgs
  emit = System.IO.putStrLn
