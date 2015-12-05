module Hello (
  app
) where

import           Configuration   (getTarget)
import           Greeting        (greet)
import           Report          (timeTaken)
import           TheOutsideWorld (TheOutsideWorld (..))

app :: TheOutsideWorld m => m ()
app = do
  (duration,_) <- measureTime $ do
    (path:_) <- getArgs
    target <- getTarget path
    greet target
  timeTaken duration
