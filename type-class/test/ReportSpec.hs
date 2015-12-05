{-# LANGUAGE FlexibleInstances    #-}

module ReportSpec (
  spec
) where

import           Control.Monad.State  (State, execState, modify)
import           Prelude              hiding (readFile)
import           Test.Hspec           (Spec, describe, it, shouldBe)

import           Report               (timeTaken)
import           TheOutsideWorld      (TheOutsideWorld(..))

newtype ConsoleOut = ConsoleOut { unConsoleOut :: [String] }

instance TheOutsideWorld (State ConsoleOut) where
  emit arg = modify $ ConsoleOut . (arg:) . unConsoleOut

spec :: Spec
spec = do
  describe "timeTaken" $
    it "emits a duration with label" $
      unConsoleOut (execState (timeTaken 1234) (ConsoleOut [])) `shouldBe` ["1234.00000 milliseconds"]
