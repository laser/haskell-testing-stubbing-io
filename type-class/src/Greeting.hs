module Greeting (
  greet
) where

import           TheOutsideWorld    (TheOutsideWorld(..))

makeGreeting :: String -> String
makeGreeting target = "Hello, " ++ target ++ "!"

greet :: TheOutsideWorld m => FilePath -> m ()
greet = emit . makeGreeting
