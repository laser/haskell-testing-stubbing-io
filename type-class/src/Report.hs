module Report (
  timeTaken
) where

import           Text.Printf        (printf)
import           TheOutsideWorld    (TheOutsideWorld(..))

makeReport :: Double -> String
makeReport = flip (++) " milliseconds" . printf "%.5F"

timeTaken :: TheOutsideWorld m => Double -> m ()
timeTaken = emit . makeReport
