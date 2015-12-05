module Application (
  run
) where

import           Configuration   (getTarget)
import           Greeting        (greet)
import           Report          (timeTaken)
import           TheOutsideWorld (TheOutsideWorld (..))

run :: TheOutsideWorld m => m ()
run = do
  (duration,_) <- measureTime $ do
    (path:_) <- getArgs
    target <- getTarget path
    greet target
  timeTaken duration
