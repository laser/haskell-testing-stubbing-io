module Configuration (
  getTarget
) where

import           Prelude         hiding (readFile)
import           TheOutsideWorld (TheOutsideWorld (..))

getTarget :: TheOutsideWorld m => FilePath -> m String
getTarget = readFile
