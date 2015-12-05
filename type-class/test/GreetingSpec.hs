{-# LANGUAGE FlexibleInstances    #-}

module GreetingSpec (
  spec
) where

import           Control.Monad.State  (State, execState, modify)
import           Prelude              hiding (readFile)
import           Test.Hspec           (Spec, describe, it, shouldBe)

import           Greeting             (greet)
import           TheOutsideWorld      (TheOutsideWorld(..))

newtype ConsoleOut = ConsoleOut { unConsoleOut :: [String] }

instance TheOutsideWorld (State ConsoleOut) where
  emit arg = modify $ ConsoleOut . (arg:) . unConsoleOut

spec :: Spec
spec = do
  describe "greet" $
    it "emits a greeting to the provided target" $
      unConsoleOut (execState (greet "Rupert") (ConsoleOut [])) `shouldBe` ["Hello, Rupert!"]
