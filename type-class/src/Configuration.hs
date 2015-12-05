module Configuration (
  Configuration(..),
  getTarget
) where

import           Prelude hiding (readFile)
import qualified Prelude

class Monad m => Configuration m where
  readFile :: FilePath -> m String

instance Configuration IO where
  readFile = Prelude.readFile

getTarget :: Configuration m => FilePath -> m String
getTarget = readFile
